# Integraciones

Guías paso a paso para cada sistema con el que se ha probado el medidor. La
lista completa, con las versiones, y lo que debería funcionar aunque no se
haya validado, están en [MQTT y compatibilidad](mqtt.md#probado).

Home Assistant, openHAB y Domoticz entienden los mensajes de autodescubrimiento
del medidor y lo dan de alta solos. Solo necesitan llegar al mismo broker MQTT.
Otros, como Node-RED, ioBroker o ThingsBoard, leen directamente los topics del
medidor.

Para openHAB y Domoticz, deja marcada **Alta automática en Home Assistant** en
la página web del medidor, aunque no uses Home Assistant: leen los mismos
mensajes. Si cambiaste el **Prefijo de descubrimiento**, usa el mismo en
ellos.

Cualquier otro cliente MQTT puede leer directamente los topics planos. Están
descritos en [Topics](mqtt.md#topics).

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
que apuntan a los mismos [topics](mqtt.md#topics). Los clientes que no son Home
Assistant simplemente los ignoran. El sensor de CO₂ lleva además el atributo
`chart_bar_s`, sacado de `info`, para que la tarjeta de más abajo dibuje la
misma gráfica que la pantalla.

Si Home Assistant usa otro prefijo de descubrimiento, cambia **Prefijo de
Discovery** para que coincida. Si desactivas el alta o cambias el prefijo, el
medidor borra al reiniciar los mensajes de descubrimiento antiguos. Home
Assistant elimina entonces las entidades en lugar de dejarlas huérfanas.

### Tarjeta para el panel

La **CO2 Monitor Card** muestra las pantallas del medidor en un panel de Home
Assistant: la misma disposición, las mismas fuentes y la misma escala de
colores, con la gráfica del historial. Las tres pantallas giran como un
carrusel, y un toque pasa a la siguiente.

<div class="photo-todo" markdown>
**TODO:** captura de la tarjeta
</div>

1. En HACS, abre el menú (⋮), elige **Repositorios personalizados** (*Custom repositories*) y añade
   **TODO: URL del repositorio de la tarjeta** con el tipo **Dashboard**.
2. Busca **CO2 Monitor Card** en HACS, descárgala y recarga el navegador.
3. Edita un panel, elige **Añadir tarjeta** (*Add card*) y busca **CO2 Monitor**.

La tarjeta encuentra sola el medidor y sus sensores, y toma del medidor los
segundos por barra, así que su gráfica coincide con la de la pantalla. Puede
mostrar más barras que la pantalla, como un tramo más largo del historial. La
página de la tarjeta explica todas las opciones y cómo instalarla sin HACS.

## openHAB

Los pasos son para la interfaz principal de openHAB 5.

1. En **Settings → Add-on Store → Bindings**, instala **MQTT Binding** y
   **Home Assistant Binding**. En openHAB 5 son dos complementos separados, y
   sin el segundo el medidor no aparece.
2. En **Settings → Things**, pulsa **+**, elige **MQTT Binding** y después
   **MQTT Broker**. Escribe la dirección del broker, el puerto, el usuario y la
   contraseña, y guarda. El Thing del broker debe quedar en **ONLINE**.
3. Abre la bandeja de entrada (**Inbox**). El medidor aparece con el nombre
   que tiene en su página web, como un solo dispositivo con los sensores de
   CO₂, temperatura y humedad. Apruébalo.
4. Abre el Thing nuevo, ve a **Channels** y enlaza un item a cada canal, o usa
   **Add Equipment to Model** para hacerlo de una vez.

!!! warning "Unidades del CO₂ y la humedad"
    openHAB guarda el CO₂ y la humedad como números sin dimensión. Si el item no
    tiene unidad, salen como una fracción: `0.0026` en vez de 2600 ppm, `0.48`
    en vez de 48 %. Al crear los items, pon la unidad `ppm` al CO₂ y `%` a la
    humedad. La temperatura no necesita nada.

El sensor de CO₂ tiene además un canal avanzado, **JSON Attributes**, con los
segundos por barra de la gráfica. Puedes ignorarlo.

Cuando el medidor se desconecta, el Thing pasa a **OFFLINE**, y vuelve a
**ONLINE** cuando regresa.

??? example "La misma configuración con ficheros de texto"
    Con `binding = mqtt,homeassistant` en `services/addons.cfg` y un broker en
    `things/mqtt.things`:

    ```java
    Bridge mqtt:broker:mosquitto "Mosquitto" [ host="192.168.1.10", port=1883, secure=false, username="usuario", password="contraseña" ]
    ```

    el medidor aparece igualmente en la bandeja de entrada. Una vez aprobado,
    los items pueden ir en `items/co2.items`. Sustituye `co2monitor_5Fxxxxxx` y
    `co2monitor_xxxxxx` por el código de tu medidor, tal como sale en el Thing:

    ```java
    Number:Dimensionless CO2         "CO₂ [%d ppm]"           { channel="homeassistant:device:mosquitto:co2monitor_5Fxxxxxx:co2monitor_xxxxxx_co2#sensor", unit="ppm" }
    Number:Temperature   Temperatura "Temperatura [%.1f °C]"  { channel="homeassistant:device:mosquitto:co2monitor_5Fxxxxxx:co2monitor_xxxxxx_temperature" }
    Number:Dimensionless Humedad     "Humedad [%.0f %%]"      { channel="homeassistant:device:mosquitto:co2monitor_5Fxxxxxx:co2monitor_xxxxxx_humidity", unit="%" }
    ```

## Domoticz

1. En **Configuración → Hardware**, añade un hardware del tipo **MQTT Auto
   Discovery Client Gateway with LAN interface**.
2. Escribe la dirección y el puerto del broker, y el usuario y la contraseña.
   Deja **Auto Discovery Prefix** en `homeassistant`.
3. Pulsa **Añadir**.

Aparecen al momento dos dispositivos, ya en uso:

- **CO₂**, como dispositivo *Air Quality* en ppm, en **Utilidades**. Domoticz
  le añade su propia etiqueta de calidad, de *Excellent* a *Bad*.
- **Temperatura y humedad**, juntas en un único dispositivo *Temp + Humidity*
  en **Temperatura**, con la etiqueta de confort que Domoticz da a la humedad
  (*Normal*, *Comfortable*, *Dry* o *Wet*).

Domoticz no usa el estado `offline` del medidor. Cuando el medidor se
desconecta, los dispositivos conservan el último valor hasta que vence el
**tiempo de espera de sensores** (*Sensor Timeout*) de los ajustes de Domoticz,
60 minutos por defecto, y entonces lo marcan como sin datos.

## Node-RED

Node-RED no lee el autodescubrimiento: un flujo se suscribe directamente a los
topics del medidor. El más cómodo es `<base>/state`, que lleva las tres
lecturas en un solo mensaje JSON, junto con `<base>/status` para saber si el
medidor está conectado.

El ejemplo de abajo hace justo eso. Muestra las lecturas en un panel y avisa
cuando el CO₂ pasa de 1000 ppm y cuando vuelve a bajar.

<div class="photo-todo" markdown>
**TODO:** captura del panel de Node-RED
</div>

El panel es **FlowFuse Dashboard** (Dashboard 2.0). Instálalo antes desde el
menú (☰) → **Manage palette** → **Install**, buscando
`@flowfuse/node-red-dashboard`. Después importa el flujo desde el menú (☰) →
**Import** y:

1. Abre el nodo **Broker** y pon la dirección de tu broker, y el usuario y la
   contraseña en la pestaña **Security**.
2. Si cambiaste el **Topic base** del medidor, ponlo en los dos nodos MQTT.
   `co2monitor/+/…` encaja con cualquier medidor que tenga el topic base por
   defecto.
3. Pulsa **Deploy**.

Abre `http://<node-red>:1880/dashboard` para ver un medidor de aguja con la
escala de colores del monitor, la temperatura, la humedad, el estado y una
gráfica de las últimas seis horas. La gráfica se guarda en la memoria de
Node-RED, así que vuelve a empezar vacía cuando Node-RED se reinicia. Las
lecturas y el estado se ven también en la barra lateral de depuración y debajo
de los nodos. Para hacer algo con el aviso, cambia el nodo **Ventilate** por una
notificación, un relé o lo que encaje en tu instalación.

??? example "Flujo de ejemplo"
    ```json
    [
      {"id": "co2tab", "type": "tab", "label": "CO2 monitor"},
      {"id": "co2broker", "type": "mqtt-broker", "name": "Broker", "broker": "192.168.1.10", "port": "1883", "clientid": "", "autoConnect": true, "usetls": false, "protocolVersion": "4", "keepalive": "60", "cleansession": true},
      {"id": "co2state", "type": "mqtt in", "z": "co2tab", "name": "Readings", "topic": "co2monitor/+/state", "qos": "0", "datatype": "json", "broker": "co2broker", "nl": false, "rap": true, "rh": 0, "inputs": 0, "x": 120, "y": 80, "wires": [["co2debug", "co2high", "co2split"]]},
      {"id": "co2status", "type": "mqtt in", "z": "co2tab", "name": "Online / offline", "topic": "co2monitor/+/status", "qos": "1", "datatype": "utf8", "broker": "co2broker", "nl": false, "rap": true, "rh": 0, "inputs": 0, "x": 130, "y": 200, "wires": [["co2debugstatus", "co2online"]]},
      {"id": "co2high", "type": "function", "z": "co2tab", "name": "Above 1000 ppm?", "func": "// Warn only when CO2 crosses the threshold, not on every reading\nconst high = msg.payload.co2 >= 1000;\nconst key = \"high_\" + msg.topic;\nif (context.get(key) === high) return null;\ncontext.set(key, high);\nmsg.payload = `CO2 ${msg.payload.co2} ppm: ` + (high ? \"ventilate\" : \"back to normal\");\nreturn msg;", "outputs": 1, "x": 360, "y": 140, "wires": [["co2alert"]]},
      {"id": "co2alert", "type": "debug", "z": "co2tab", "name": "Ventilate", "active": true, "tosidebar": true, "console": false, "tostatus": false, "complete": "payload", "targetType": "msg", "x": 580, "y": 140, "wires": []},
      {"id": "co2debug", "type": "debug", "z": "co2tab", "name": "Reading", "active": true, "tosidebar": true, "console": false, "tostatus": true, "complete": "payload", "targetType": "msg", "statusVal": "payload.co2", "statusType": "msg", "x": 340, "y": 80, "wires": []},
      {"id": "co2debugstatus", "type": "debug", "z": "co2tab", "name": "Status", "active": true, "tosidebar": true, "console": false, "tostatus": true, "complete": "payload", "targetType": "msg", "statusVal": "payload", "statusType": "msg", "x": 340, "y": 200, "wires": []},
      {"id": "co2uibase", "type": "ui-base", "name": "CO2 monitor", "path": "/dashboard", "appIcon": "", "includeClientData": true, "acceptsClientConfig": ["ui-notification", "ui-control"], "showPathInSidebar": false, "headerContent": "page", "navigationStyle": "default", "titleBarStyle": "default", "showReconnectNotification": true, "notificationDisplayTime": 1, "showDisconnectNotification": true, "allowInstall": false},
      {"id": "co2uitheme", "type": "ui-theme", "name": "Default", "colors": {"surface": "#fcfcfd", "primary": "#0d74ce", "bgPage": "#f9f9fb", "groupBg": "#ffffff", "groupOutline": "#d9d9e0"}, "sizes": {"density": "default", "pagePadding": "12px", "groupGap": "12px", "groupBorderRadius": "4px", "widgetGap": "12px"}},
      {"id": "co2uipage", "type": "ui-page", "name": "CO2", "ui": "co2uibase", "path": "/co2", "icon": "molecule-co2", "layout": "grid", "theme": "co2uitheme", "breakpoints": [{"name": "Default", "px": "0", "cols": "3"}, {"name": "Tablet", "px": "576", "cols": "6"}, {"name": "Small Desktop", "px": "768", "cols": "9"}, {"name": "Desktop", "px": "1024", "cols": "12"}], "order": 1, "className": "", "visible": "true", "disabled": "false"},
      {"id": "co2uigroup", "type": "ui-group", "name": "CO2 monitor", "page": "co2uipage", "width": "6", "height": "1", "order": 1, "showTitle": true, "className": "", "visible": "true", "disabled": "false", "groupType": "default"},
      {"id": "co2split", "type": "function", "z": "co2tab", "name": "Split readings", "func": "// One output per widget: CO2, temperature and humidity\nconst s = msg.payload;\nreturn [\n    { topic: \"CO2\", payload: s.co2 },\n    { payload: `${s.temperature} °C` },\n    { payload: `${s.humidity} %` },\n];", "outputs": 3, "x": 360, "y": 280, "wires": [["co2gauge", "co2chart"], ["co2temp"], ["co2hum"]]},
      {"id": "co2gauge", "type": "ui-gauge", "z": "co2tab", "name": "CO2", "group": "co2uigroup", "order": 1, "width": "6", "height": "4", "gtype": "gauge-half", "gstyle": "needle", "title": "CO₂", "alwaysShowTitle": false, "floatingTitlePosition": "top-left", "units": "ppm", "icon": "", "prefix": "", "suffix": "", "value": "payload", "valueType": "msg", "segments": [{"from": "400", "color": "#76b043"}, {"from": "1000", "color": "#f2d02e"}, {"from": "1700", "color": "#e07b26"}, {"from": "2500", "color": "#9e2b25"}], "min": "400", "max": "3000", "sizeThickness": 16, "sizeGap": 4, "sizeKeyThickness": 8, "styleRounded": true, "styleGlow": false, "className": "", "x": 590, "y": 240, "wires": []},
      {"id": "co2temp", "type": "ui-text", "z": "co2tab", "name": "", "group": "co2uigroup", "order": 2, "width": "3", "height": "1", "label": "Temperature", "format": "{{msg.payload}}", "layout": "col-center", "style": false, "font": "", "fontSize": 16, "color": "#717171", "wrapText": false, "className": "", "value": "payload", "valueType": "msg", "x": 600, "y": 280, "wires": []},
      {"id": "co2hum", "type": "ui-text", "z": "co2tab", "name": "", "group": "co2uigroup", "order": 3, "width": "3", "height": "1", "label": "Humidity", "format": "{{msg.payload}}", "layout": "col-center", "style": false, "font": "", "fontSize": 16, "color": "#717171", "wrapText": false, "className": "", "value": "payload", "valueType": "msg", "x": 590, "y": 320, "wires": []},
      {"id": "co2chart", "type": "ui-chart", "z": "co2tab", "name": "", "group": "co2uigroup", "order": 4, "width": "6", "height": "5", "label": "Last 6 hours", "chartType": "line", "category": "topic", "categoryType": "msg", "xAxisLabel": "", "xAxisProperty": "", "xAxisPropertyType": "timestamp", "xAxisType": "time", "xAxisFormat": "", "xAxisFormatType": "auto", "yAxisLabel": "ppm", "yAxisProperty": "payload", "yAxisPropertyType": "msg", "ymin": "400", "ymax": "", "action": "append", "stackSeries": false, "pointShape": "false", "pointRadius": 4, "showLegend": false, "removeOlder": "6", "removeOlderUnit": "3600", "removeOlderPoints": "", "colors": ["#0095ff"], "textColor": ["#666666"], "textColorDefault": true, "gridColor": ["#e5e5e5"], "gridColorDefault": true, "className": "", "interpolation": "linear", "x": 590, "y": 360, "wires": []},
      {"id": "co2online", "type": "ui-text", "z": "co2tab", "name": "", "group": "co2uigroup", "order": 5, "width": "6", "height": "1", "label": "Status", "format": "{{msg.payload}}", "layout": "row-spread", "style": false, "font": "", "fontSize": 14, "color": "#717171", "wrapText": false, "className": "", "value": "payload", "valueType": "msg", "x": 590, "y": 400, "wires": []}
    ]
    ```

El `+` encaja con cualquier medidor, así que un solo flujo sirve para varios;
`msg.topic` los distingue, por ejemplo `co2monitor/a64102/state`.

## ioBroker

ioBroker lee los topics del medidor con el adaptador **MQTT Broker/Client**,
usado como cliente de tu broker. No lee el autodescubrimiento: crea un estado
por cada topic.

1. En **Adapters**, busca **MQTT Broker/Client** y añade una instancia.
2. En los ajustes de la instancia, pestaña **Connection**: elige el tipo
   cliente y escribe la dirección del broker, el puerto, el usuario y la
   contraseña.
3. Pestaña **Client settings**: en **Subscribe patterns**, cambia el valor por
   defecto por `co2monitor/#`, o por tu **Topic base** seguido de `/#`.
4. Pestaña **MQTT Settings**: vacía **Mask to publish own states** y deja sin
   marcar **Publish own states on connect**. El adaptador solo tiene que leer;
   si no, podría publicar sus propios estados en el broker.
5. **Save and close.** La instancia se pone en verde cuando conecta.

!!! warning
    La contraseña hay que escribirla en esta página de ajustes. ioBroker la
    guarda cifrada, así que ponerla desde la línea de órdenes con
    `iobroker set` no funciona: el broker rechaza entonces al adaptador.

Los estados aparecen en **Objects → mqtt.0 → co2monitor → xxxxxx**:

| Estado | Contenido |
|---|---|
| `co2`, `temperature`, `humidity` | Las lecturas, como números |
| `state` | Las tres lecturas como texto JSON |
| `status` | `online` / `offline` |
| `info` | Diagnóstico como texto JSON |

Los estados no tienen unidad. Si la quieres en gráficas y visualizaciones,
edita el objeto y ponla: `ppm`, `°C` y `%`.

Cuando el medidor se desconecta, `status` pasa a `offline` y las lecturas
conservan su último valor. Usa `status` en tus scripts para distinguir una
lectura actual de una antigua.

## InfluxDB y Grafana

Para guardar las lecturas durante meses y verlas en gráficas, la receta
habitual es **Telegraf**, que las lee del broker, **InfluxDB**, que las guarda,
y **Grafana**, que las dibuja.

<div class="photo-todo" markdown>
**TODO:** captura del panel de Grafana
</div>

1. En InfluxDB 2, crea un bucket llamado `co2` y un token de API que pueda
   escribir en él (para Telegraf) y leerlo (para Grafana). Elige la retención
   del bucket: una lectura por minuto son unos 500.000 puntos al año por
   medidor, que InfluxDB maneja sin problema.
2. Añade esto a la configuración de Telegraf, con tu broker, usuario,
   contraseña, dirección de InfluxDB, organización y token:

    ```toml
    [[inputs.mqtt_consumer]]
      servers = ["tcp://192.168.1.10:1883"]
      topics = ["co2monitor/+/state"]
      username = "user"
      password = "password"
      data_format = "json"
      name_override = "co2monitor"
      tagexclude = ["topic"]

      [[inputs.mqtt_consumer.topic_parsing]]
        topic = "co2monitor/+/state"
        tags = "_/device/_"

    [[outputs.influxdb_v2]]
      urls = ["http://192.168.1.10:8086"]
      token = "TOKEN"
      organization = "home"
      bucket = "co2"
    ```

    Telegraf guarda un punto por cada mensaje de `<base>/state`, con los
    campos `co2`, `temperature` y `humidity`, en la medida `co2monitor`. El
    código del medidor pasa a ser la etiqueta `device`, así que varios
    medidores comparten el bucket y se siguen distinguiendo.

3. En Grafana, añade una fuente de datos **InfluxDB** con el lenguaje de
   consulta **Flux**, la dirección de InfluxDB, la organización, el token y el
   bucket por defecto `co2`.
4. Descarga el [panel](assets/grafana-co2-monitor.json) e impórtalo desde
   **Dashboards → New → Import**, eligiendo esa fuente de datos.

El panel muestra un medidor de CO₂ con la escala de colores del monitor, la
temperatura y la humedad actuales, y una gráfica de cada una. Cada medidor es
una línea, con su código como nombre.

!!! note "Un topic base propio"
    La configuración de arriba usa el topic base por defecto,
    `co2monitor/xxxxxx`, para sacar el código del medidor. Si cambiaste el
    **Topic base**, ponlo en `topics` y en `topic_parsing`, y haz que la
    etiqueta `device` apunte al nivel que distingue a tus medidores.

## ThingsBoard

ThingsBoard no lee el autodescubrimiento ni se suscribe a un broker ajeno: los
dispositivos se conectan a él. El puente es el **ThingsBoard IoT Gateway**, que
se suscribe a tu broker, lee los topics del medidor y da de alta cada medidor
como un dispositivo de ThingsBoard.

!!! warning "Versión de ThingsBoard"
    Desde la 4.4, ThingsBoard Community Edition se distribuye con licencia
    BUSL 1.1 y una instalación nueva no deja entrar hasta activarla con una
    cuenta en su portal de licencias, que es gratuita. La rama 4.3 LTS, con la
    que se hizo la prueba, no lo pide. El medidor funciona igual con las dos.

1. En ThingsBoard, ve a **Entities → Gateways** y añade un gateway. Arráncalo
   con la orden de Docker que te propone ThingsBoard, que ya lleva su token de
   acceso. El gateway debe poder llegar a tu broker.
2. En el gateway, añade un conector de tipo **MQTT** y pega en su modo
   avanzado esta configuración, con la dirección de tu broker, el usuario y la
   contraseña:

    ??? example "Configuración del conector"
        ```json
        {
          "broker": {
            "host": "192.168.1.10",
            "port": 1883,
            "clientId": "tb-gateway-co2",
            "version": 5,
            "cleanSession": true,
            "cleanStart": true,
            "sessionExpiryInterval": 0,
            "security": {
              "type": "basic",
              "username": "user",
              "password": "password"
            }
          },
          "mapping": [
            {
              "topicFilter": "co2monitor/+/state",
              "subscriptionQos": 0,
              "converter": {
                "type": "json",
                "deviceInfo": {
                  "deviceNameExpressionSource": "topic",
                  "deviceNameExpression": "^co2monitor/[^/]+",
                  "deviceProfileExpressionSource": "constant",
                  "deviceProfileExpression": "CO2 monitor"
                },
                "attributes": [],
                "timeseries": [
                  {
                    "type": "integer",
                    "key": "co2",
                    "value": "${co2}"
                  },
                  {
                    "type": "double",
                    "key": "temperature",
                    "value": "${temperature}"
                  },
                  {
                    "type": "integer",
                    "key": "humidity",
                    "value": "${humidity}"
                  }
                ]
              }
            },
            {
              "topicFilter": "co2monitor/+/info",
              "subscriptionQos": 0,
              "converter": {
                "type": "json",
                "deviceInfo": {
                  "deviceNameExpressionSource": "topic",
                  "deviceNameExpression": "^co2monitor/[^/]+",
                  "deviceProfileExpressionSource": "constant",
                  "deviceProfileExpression": "CO2 monitor"
                },
                "timeseries": [
                  {
                    "type": "integer",
                    "key": "rssi",
                    "value": "${rssi}"
                  }
                ],
                "attributes": [
                  {
                    "type": "string",
                    "key": "fw",
                    "value": "${fw}"
                  },
                  {
                    "type": "string",
                    "key": "hw",
                    "value": "${hw}"
                  },
                  {
                    "type": "string",
                    "key": "sensor_fw",
                    "value": "${sensor_fw}"
                  },
                  {
                    "type": "string",
                    "key": "ip",
                    "value": "${ip}"
                  },
                  {
                    "type": "string",
                    "key": "mac",
                    "value": "${mac}"
                  },
                  {
                    "type": "string",
                    "key": "hostname",
                    "value": "${hostname}"
                  },
                  {
                    "type": "integer",
                    "key": "uptime_s",
                    "value": "${uptime_s}"
                  },
                  {
                    "type": "string",
                    "key": "reset",
                    "value": "${reset}"
                  }
                ]
              }
            }
          ],
          "requestsMapping": {}
        }
        ```

3. Guarda. En **Entities → Devices** aparece cada medidor como
   `co2monitor/xxxxxx`, con el perfil `CO2 monitor`, en cuanto publique.
4. Descarga el [panel](assets/thingsboard-co2-monitor.json) e impórtalo desde
   **Dashboards → + → Import dashboard**.

Cada medidor recibe como telemetría `co2`, `temperature`, `humidity` y `rssi`,
y como atributos lo que publica en `<base>/info`: versiones, IP, nombre de
red, tiempo encendido y motivo del último reinicio.

El panel muestra el CO₂ con los colores del monitor, la temperatura y la
humedad actuales, la ficha del medidor y una gráfica de cada lectura. Con
varios medidores, elige cuál ver en el selector de la barra superior.

<div class="photo-todo" markdown>
**TODO:** captura del panel de ThingsBoard
</div>

!!! note "Conectado o desconectado"
    El gateway no puede asignar `<base>/status` a un medidor, porque ese
    mensaje es texto plano y el nombre del medidor solo está en el topic.
    ThingsBoard marca el dispositivo como inactivo cuando deja de recibir
    lecturas, al cabo de 10 minutos por defecto.

!!! note "Un topic base propio"
    La configuración usa el topic base por defecto, `co2monitor/xxxxxx`. Si
    cambiaste el **Topic base**, ponlo en los dos `topicFilter` y en los dos
    `deviceNameExpression`, que es una expresión regular sobre el topic.

## Azure Event Grid

El broker MQTT de Azure Event Grid no admite usuario y contraseña: cada
aparato se identifica con un **certificado de cliente**. El medidor lo admite,
así que puede publicar directamente en Azure, sin un broker intermedio.

Tienen que coincidir tres cosas:

| En Azure | En el medidor |
|---|---|
| *Client authentication name* | **Usuario** |
| *Thumbprint* del cliente | Huella del certificado que pegas en la página web |
| Plantilla del *topic space* | **Topic base** |

### 1. Crear el certificado

Con validación por huella vale un certificado autofirmado, sin CA. Genéralo
con OpenSSL, con clave EC P-256 y sin contraseña:

```sh
openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes \
  -keyout co2-monitor.key -out co2-monitor.crt -days 365 \
  -subj "/CN=co2-monitor-xxxxxx"

openssl x509 -in co2-monitor.crt -noout -fingerprint -sha256 | cut -d= -f2 | tr -d ':'
```

La última orden da la huella SHA-256 en el formato que pide Azure.

- **EC P-256** hace el saludo TLS bastante más rápido que RSA en el medidor.
- **`-nodes`** deja la clave sin contraseña. El medidor no admite claves
  cifradas.
- **El certificado caduca** a los 365 días. Antes de esa fecha, genera otro,
  cambia la huella en Azure y pega el nuevo en el medidor.

### 2. Configurar Event Grid

En el *namespace* de Event Grid, en el portal de Azure:

1. **Configuration:** marca **Enable MQTT broker** y guarda. En **Overview**
   aparece el nombre del broker, con la forma
   `<namespace>.<región>-1.ts.eventgrid.azure.net`.
2. **Clients → + Client:**
    - **Client authentication name:** por ejemplo `co2-monitor-xxxxxx`.
    - **Client certificate authentication validation scheme:**
      **Thumbprint Match**.
    - **Primary thumbprint:** la huella del paso anterior.
3. **Topic spaces → + Topic space**, con la plantilla `co2monitor/#`. Si
   cambiaste el **Topic base** del medidor, la plantilla tiene que cubrirlo.
4. **Permission bindings → + Permission binding:** permiso **Publisher** sobre
   ese topic space. El grupo `$all` sirve para empezar. En uso real, crea un
   grupo solo para los medidores.

Para leer los datos desde otro cliente, dale de alta igual y añade un permiso
**Subscriber** sobre el mismo topic space.

### 3. Configurar el medidor

En la página web del medidor, en **MQTT**:

| Ajuste | Valor |
|---|---|
| Broker | `mqtts://<namespace>.<región>-1.ts.eventgrid.azure.net:8883` |
| Usuario | El *client authentication name* |
| Contraseña | Vacía |
| Certificado de la CA | Vacío: la autoridad de Azure va incluida en el firmware |
| Certificado de cliente | El contenido de `co2-monitor.crt` |
| Clave privada | El contenido de `co2-monitor.key` |
| Alta automática en Home Assistant | Desmarcada, salvo que el topic space incluya también `homeassistant/#` |

Guarda. El medidor conecta en unos segundos. En el portal, las **Metrics** del
namespace muestran las conexiones y los mensajes publicados.

En la prueba, el medidor se mantuvo conectado con sus mensajes retenidos
(`status` e `info`) y su última voluntad.

!!! note "Si no conecta"
    - **Rechazo por autorización:** el usuario no coincide con el
      *client authentication name*, o la huella registrada no es la del
      certificado que tiene el medidor. Comprueba también el CN del
      certificado con `openssl x509 -in co2-monitor.crt -noout -subject`.
    - **Conecta pero no llega nada:** falta el permiso **Publisher**, o el
      topic base no entra en la plantilla del topic space.

!!! warning
    La clave privada se guarda en la flash del medidor sin cifrar, como las
    contraseñas. Si pierdes el control del aparato, deshabilita su cliente en
    Azure.
