# MQTT y Home Assistant

El medidor funciona con cualquier broker y cualquier cliente MQTT. Home
Assistant es un cliente más, no un requisito.

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
| `<base>/info` | Diagnóstico en JSON: `fw`, `hw`, `sensor_fw`, `ip`, `mac`, `hostname`, `rssi`, `uptime_s` | sí | 1 al conectar, 0 después |

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
  públicas más comunes, que lleva el firmware. Esto vale para los brokers en
  la nube (HiveMQ Cloud, EMQX Cloud…) y para cualquier broker con certificado
  de Let's Encrypt.
- **Si tu broker usa una CA propia**, como un Mosquitto con certificados
  autofirmados, pega su `ca.crt` en PEM en el campo de la CA.

El nombre del host en la dirección del broker tiene que coincidir con el del
certificado. Si el certificado es para `broker.midominio.com`, conectar por IP
o por un nombre `.local` falla la verificación.

### Certificados de cliente

Algunos brokers identifican al aparato por un **certificado de cliente** en
lugar de por contraseña (TLS mutuo), como Azure Event Grid o AWS IoT. Para
ellos, pega en la página web el certificado y su clave privada en PEM.

- La clave no puede estar protegida con contraseña.
- La clave no se vuelve a mostrar nunca. Deja el campo en blanco para
  conservar la guardada.
- Vaciar el certificado borra los dos.
- El usuario se sigue enviando, porque Event Grid lo compara con el
  *authentication name* del cliente.

!!! note
    La clave se guarda en la flash del medidor sin cifrar, igual que las
    contraseñas de la Wi-Fi y de MQTT.

## Home Assistant

Necesitas Home Assistant con la **integración MQTT** configurada y conectada
a un broker, por ejemplo el complemento de Mosquitto.

1. En la página web del medidor, en **MQTT**, pon la dirección del broker,
   por ejemplo `mqtt://192.168.1.10:1883`, y su usuario y contraseña.
2. Deja marcada **Alta automática en Home Assistant**. Viene activada por
   defecto.
3. Guarda.

El medidor aparece en Home Assistant como un dispositivo con tres sensores:
CO₂, temperatura y humedad. Sale como no disponible cuando se desconecta. Su
nombre es el ajuste **Nombre** de la página web.

El descubrimiento usa mensajes retenidos en `homeassistant/sensor/…/config`,
que apuntan a los mismos topics de arriba. Los clientes que no son Home
Assistant simplemente los ignoran.

Si Home Assistant usa otro prefijo de descubrimiento, cambia **Prefijo de
Discovery** para que coincida. Si desactivas el alta o cambias el prefijo, el
medidor borra al reiniciar los mensajes de descubrimiento antiguos. Home
Assistant elimina entonces las entidades en lugar de dejarlas huérfanas.
