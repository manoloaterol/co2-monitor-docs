# Compatibilidad

El medidor publica sus lecturas por MQTT, así que puede trabajar con cualquier
sistema que hable MQTT. Esta página resume lo que el medidor acepta, con qué
se ha probado y qué debería funcionar aunque no se haya comprobado.

## MQTT

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

Los topics y sus formatos están en [MQTT y Home Assistant](mqtt.md#topics), y
los detalles de TLS en [TLS](mqtt.md#tls).

## Probado

Pruebas hechas en octubre de 2026 con las versiones indicadas. Cada sistema
tiene su guía.

### Domótica

| Sistema | Versión | Cómo |
|---|---|---|
| Home Assistant | 2026.9 | Lo encuentra solo. [Guía](mqtt.md#home-assistant) |
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
| Mosquitto 2 | `mqtt://` con usuario y contraseña | [MQTT y Home Assistant](mqtt.md) |
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
