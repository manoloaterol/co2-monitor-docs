# MQTT y compatibilidad

El medidor publica sus lecturas por MQTT estándar, así que debería funcionar
con cualquier broker y cualquier cliente MQTT. Esta página describe lo que
acepta, sus topics y su seguridad, y con qué se ha probado. Los pasos para
cada sistema están en [Integraciones](integrations.md).

## Qué acepta

| | |
|---|---|
| Protocolo | MQTT 3.1.1. Los brokers con MQTT 5 aceptan clientes 3.1.1 |
| Papel | Solo publica. No se suscribe a ningún topic ni recibe órdenes |
| Conexión | `mqtt://` sin cifrar o `mqtts://` con TLS 1.2, en cualquier puerto |
| Certificado del broker | Siempre se verifica: contra las autoridades públicas más comunes, que lleva el firmware, o contra una CA propia en PEM |
| Autenticación | Usuario y contraseña, certificado de cliente (TLS mutuo), o las dos cosas |
| Identificador de cliente | `co2monitor_xxxxxx`, con el código del aparato. No se puede cambiar |
| Topics | Topic base configurable. Cada lectura en su propio topic y las tres juntas en JSON |
| QoS | 0 para las lecturas; 1 para el estado y para el diagnóstico al conectar. Nunca 2 |
| Mensajes retenidos | Opcionales para las lecturas. El estado y el diagnóstico siempre van retenidos |
| Última voluntad | `<base>/status` pasa a `offline` si el medidor se desconecta sin avisar |
| Descubrimiento | Formato de Home Assistant, con prefijo configurable. Se puede desactivar |

**No admite:** MQTT 5 como protocolo propio, MQTT sobre WebSocket, TLS 1.3,
claves privadas protegidas con contraseña ni órdenes entrantes.

## Topics

Todos los topics cuelgan de un **topic base**. Por defecto es
`co2monitor/xxxxxx`, con el código del aparato, para que varios medidores
compartan broker sin configurar nada. Se puede sustituir en la página web, por
ejemplo por `casa/salon/co2`. No puede llevar `+` ni `#` ni niveles vacíos, ni
pasar de 63 caracteres.

| Topic | Contenido | Retenido | QoS |
|---|---|---|---|
| `<base>/co2` | CO₂ en ppm, entero: `812` | opcional | 0 |
| `<base>/temperature` | °C con un decimal: `22.4` | opcional | 0 |
| `<base>/humidity` | % de humedad relativa, entero: `48` | opcional | 0 |
| `<base>/state` | Las tres en JSON: `{"co2":812,"temperature":22.4,"humidity":48}` | opcional | 0 |
| `<base>/status` | `online` / `offline` | sí | 1 |
| `<base>/info` | Diagnóstico en JSON: `fw`, `hw`, `sensor_fw`, `ip`, `mac`, `hostname`, `rssi`, `uptime_s`, `reset` (por qué se reinició la última vez: `power_on`, `software`, `panic`, `task_wdt`, `brownout`…), `chart_bar_s` (segundos por barra de la gráfica, que es también el periodo de publicación) | sí | 1 al conectar, 0 después |

- **Cadencia.** Las lecturas se publican una vez por barra de la gráfica,
  con la media de las lecturas del sensor en ese tiempo. Por defecto, cada
  20 s, la media de 10 lecturas. Un cliente MQTT ve la misma curva que la
  pantalla. `info` se refresca al conectar y cada 5 minutos.
- **Plano o JSON.** Los topics planos y `state` llevan los mismos valores con
  el mismo redondeo. `state` es lo cómodo para Telegraf/InfluxDB, Node-RED o
  ioBroker, porque cada mensaje lleva una muestra entera.
- **Estado.** El medidor publica `offline` antes de un reinicio voluntario.
  Si desaparece sin avisar, el broker publica `offline` por él, como su
  *last will*.

Para verlo desde un ordenador:

```sh
mosquitto_sub -h broker.local -u usuario -P clave -t 'co2monitor/#' -v
```

### Lecturas retenidas

**Retener las lecturas** es una casilla de la página web, desactivada por
defecto. Con ella, quien se suscribe recibe el último valor al instante. Sin
ella, espera a la siguiente publicación.

Mira siempre también `status`: un valor retenido de un medidor `offline` no
es actual.

### Al reiniciar

Guardar ajustes, actualizar, el botón de reinicio y entrar o salir del modo
configuración reinician el medidor. Antes de reiniciarse, se despide del
broker: publica `offline` y se desconecta limpiamente, así Home Assistant lo
marca como no disponible al momento.

Si desactivas la retención o cambias el topic base, el medidor también borra
lo que dejó retenido con los ajustes anteriores. Solo puede hacerlo si en ese
momento está conectado al broker. Si no, los mensajes antiguos se quedan, y
hay que borrarlos a mano publicando un mensaje vacío retenido en cada topic.

## TLS

El broker puede ser `mqtt://` (normalmente en el puerto 1883) o `mqtts://`
(normalmente en el 8883). Con `mqtts://` el certificado del broker **siempre
se verifica**:

- **Con el campo de la CA vacío**, se comprueba contra las autoridades
  públicas más comunes, que lleva el firmware. Así se probó con Azure Event
  Grid. Debería valer también para otros brokers en la nube, como HiveMQ Cloud
  o EMQX Cloud, y para cualquier broker con certificado de Let's Encrypt,
  aunque no se ha validado.
- **Si tu broker usa una CA propia**, como un Mosquitto con certificados
  autofirmados, pega su `ca.crt` en PEM en el campo de la CA.

El nombre del host en la dirección del broker tiene que coincidir con el del
certificado. Si el certificado es para `broker.midominio.com`, conectar por IP
o por un nombre `.local` falla la verificación.

### Certificados de cliente

Algunos brokers identifican al aparato por un **certificado de cliente** en
lugar de por contraseña (TLS mutuo), como Azure Event Grid (ver la
[guía](integrations.md#azure-event-grid)) o AWS IoT Core, que debería funcionar
pero no se ha validado. Para ellos, pega en la página web el certificado y su
clave privada en PEM.

- La clave no puede estar protegida con contraseña.
- La clave no se vuelve a mostrar nunca. Deja el campo en blanco para
  conservar la guardada.
- Vaciar el certificado borra los dos.
- El usuario se sigue enviando, porque Event Grid lo compara con el
  *authentication name* del cliente.

!!! note
    La clave se guarda en la flash del medidor sin cifrar, igual que las
    contraseñas de la Wi-Fi y de MQTT.

## Probado

Pruebas hechas en octubre de 2026 con las versiones indicadas. Cada sistema
tiene su guía.

### Domótica

| Sistema | Versión | Cómo |
|---|---|---|
| Home Assistant | 2026.9 | Lo encuentra solo. [Guía](integrations.md#home-assistant) |
| openHAB | 5.2 | Lo encuentra solo. [Guía](integrations.md#openhab) |
| Domoticz | 2026.4 | Lo encuentra solo. [Guía](integrations.md#domoticz) |
| Node-RED | 5.0 | Lee los topics. [Guía](integrations.md#node-red) |
| ioBroker | js-controller 7.2, adaptador MQTT 6.1 | Lee los topics. [Guía](integrations.md#iobroker) |

### Datos y plataformas IoT

| Sistema | Versión | Cómo |
|---|---|---|
| InfluxDB + Grafana | Telegraf 1.40, InfluxDB 2.9, Grafana 13.2 | Telegraf lee los topics. [Guía](integrations.md#influxdb-y-grafana) |
| ThingsBoard | 4.3 LTS, IoT Gateway 3.8 | El gateway lee los topics. [Guía](integrations.md#thingsboard) |

### Brokers

| Broker | Conexión | Guía |
|---|---|---|
| Mosquitto 2 | `mqtt://` con usuario y contraseña | [Home Assistant](integrations.md#home-assistant) |
| Azure Event Grid | `mqtts://` con certificado de cliente | [Guía](integrations.md#azure-event-grid) |

## Debería funcionar, pero no se ha validado

Estos casos usan lo mismo que ya se ha probado, pero no se han comprobado con
el medidor:

- **Cualquier otro broker MQTT 3.1.1 o 5** en tu red, como EMQX, HiveMQ CE,
  NanoMQ o el broker integrado de otros sistemas domóticos.
- **Brokers en la nube con usuario y contraseña**, como HiveMQ Cloud o EMQX
  Cloud. Su certificado suele estar firmado por una autoridad pública de las
  que lleva el firmware.
- **AWS IoT Core**, con certificado de cliente como en Azure. El identificador
  de cliente del medidor no se puede cambiar, así que la política de AWS IoT
  tiene que admitir `co2monitor_xxxxxx`.
- **Otros sistemas que lean MQTT**, como Homey, Hubitat o FHEM, leyendo los
  topics del medidor.

Si lo pruebas con alguno, nos ayuda saber cómo ha ido.
