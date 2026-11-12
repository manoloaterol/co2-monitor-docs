# Integrations

Step-by-step guides for each system the monitor has been tested with. The
full list, with versions, and what should work although it has not been
validated, are in [MQTT & compatibility](mqtt.md#tested).

Home Assistant, openHAB and Domoticz understand the monitor's auto-discovery
messages and set it up on their own. They only need to reach the same MQTT
broker. Others, like Node-RED, ioBroker and ThingsBoard, read the monitor's
topics directly.

For openHAB and Domoticz, leave **Home Assistant auto-discovery** ticked on
the monitor's web page, even if you do not use Home Assistant: they read the
same messages. If you changed the **Discovery prefix**, use the same one in
them.

Any other MQTT client can read the plain topics directly. They are described
in [Topics](mqtt.md#topics).

## Home Assistant

An open-source home automation platform that brings devices from hundreds of
brands together on one dashboard and lets you automate them. It runs on a
computer in your home, such as a Raspberry Pi or a mini PC, with no need for
the cloud.

You need Home Assistant with the **MQTT integration** set up and connected
to a broker, for example the Mosquitto add-on.

1. On the monitor's web page, under **MQTT**, enter the broker address, for
   example `mqtt://192.168.1.10:1883`, and its user and password.
2. Leave **Home Assistant auto-discovery** ticked. It is on by default.
3. Save.

The monitor appears in Home Assistant as a device with three sensors: CO₂,
temperature and humidity. It shows as unavailable when it goes offline. Its
name is the **Name** setting on the web page.

Discovery uses retained messages under `homeassistant/sensor/…/config`,
which point to the same [topics](mqtt.md#topics). Clients that are not Home Assistant
simply ignore them. The CO₂ sensor also carries the `chart_bar_s` attribute,
taken from `info`, so the dashboard card below draws the same chart as the
display.

If Home Assistant uses another discovery prefix, change **Discovery prefix**
to match it. If you turn discovery off or change the prefix, the monitor
removes the old discovery messages when it restarts. Home Assistant then
deletes the entities instead of leaving them orphaned.

### Dashboard card

The **CO2 Monitor Card** shows the monitor's screens in a Home Assistant
dashboard: the same layout, typefaces and color scale, with the history chart.
The three screens rotate like a carousel, and a tap moves to the next one.

<figure markdown="span">
  ![Three CO2 Monitor cards in a Home Assistant dashboard, on the big CO₂ screen](img/ha-card.png)
  <figcaption>Three monitors in a Home Assistant dashboard, each one on its big CO₂ screen.</figcaption>
</figure>

The card is optional: the monitor works in Home Assistant without it. The
easiest way to install it is **HACS** (Home Assistant Community Store), which
**does not come with Home Assistant**. If you do not have it yet, install it
first by following the [official HACS guide](https://hacs.xyz/docs/use/). It
takes a few minutes, a restart and a GitHub account. If you would rather not
install HACS, the [card's page](https://github.com/manoloaterol/co2-monitor-card#manual) explains how to install it by
hand.

With HACS installed:

1. In HACS, open the menu (⋮), choose **Custom repositories** and add
   `https://github.com/manoloaterol/co2-monitor-card` with the type **Dashboard**.
2. Find **CO2 Monitor Card** in HACS, download it and reload the browser.
3. Edit a dashboard, choose **Add card** and search for **CO2 Monitor**.

The card picks your monitor and its sensors on its own, and takes the
seconds per bar from the monitor, so its chart matches the display. It can show
more bars than the display, as a longer stretch of history. The card's page
explains every option.

## openHAB

An open-source home automation platform that connects devices of different
brands and protocols and lets you automate them with rules. It runs on your
own network, with no need for the cloud.

The steps are for the main UI of openHAB 5.

1. In **Settings → Add-on Store → Bindings**, install the **MQTT Binding** and
   the **Home Assistant Binding**. In openHAB 5 they are two separate
   add-ons, and without the second one the monitor is not found.
2. In **Settings → Things**, press **+**, choose **MQTT Binding** and then
   **MQTT Broker**. Enter the broker address, port, user and password, and
   save. The broker Thing should show **ONLINE**.
3. Open the **Inbox**. The monitor appears with its name from the web page,
   as a single device with the CO₂, temperature and humidity sensors. Approve
   it.
4. Open the new Thing, go to **Channels** and link an item to each of them, or
   use **Add Equipment to Model** to do it in one go.

!!! warning "Units of CO₂ and humidity"
    openHAB stores CO₂ and humidity as dimensionless numbers. If the item has
    no unit, they appear as a fraction: `0.0026` instead of 2600 ppm, `0.48`
    instead of 48 %. When you create the items, set the unit to `ppm` for CO₂
    and `%` for humidity. Temperature needs nothing.

The CO₂ sensor has one more advanced channel, **JSON Attributes**, with the
seconds per chart bar. You can ignore it.

When the monitor goes offline the Thing changes to **OFFLINE**, and back to
**ONLINE** when it returns.

??? example "The same set up with text files"
    With `binding = mqtt,homeassistant` in `services/addons.cfg`, a broker in
    `things/mqtt.things`:

    ```java
    Bridge mqtt:broker:mosquitto "Mosquitto" [ host="192.168.1.10", port=1883, secure=false, username="user", password="password" ]
    ```

    the monitor still appears in the Inbox. Once approved, the items can go in
    `items/co2.items`. Replace `co2monitor_5Fxxxxxx` and `co2monitor_xxxxxx`
    with your monitor's code, as shown in the Thing:

    ```java
    Number:Dimensionless CO2         "CO₂ [%d ppm]"           { channel="homeassistant:device:mosquitto:co2monitor_5Fxxxxxx:co2monitor_xxxxxx_co2#sensor", unit="ppm" }
    Number:Temperature   Temperature "Temperature [%.1f °C]"  { channel="homeassistant:device:mosquitto:co2monitor_5Fxxxxxx:co2monitor_xxxxxx_temperature" }
    Number:Dimensionless Humidity    "Humidity [%.0f %%]"     { channel="homeassistant:device:mosquitto:co2monitor_5Fxxxxxx:co2monitor_xxxxxx_humidity", unit="%" }
    ```

## Domoticz

A lightweight open-source home automation system, made for modest hardware
such as a Raspberry Pi. It logs sensors and switches, keeps their history and
lets you write events and scripts.

1. In **Setup → Hardware**, add a hardware of the type **MQTT Auto Discovery
   Client Gateway with LAN interface**.
2. Enter the broker address and port, and the user and password. Leave
   **Auto Discovery Prefix** as `homeassistant`.
3. Press **Add**.

Two devices appear at once, already in use:

- **CO₂**, as an *Air Quality* device in ppm, under **Utility**. Domoticz
  adds its own quality label, from Excellent to Bad.
- **Temperature and humidity**, joined in a single *Temp + Humidity* device
  under **Temperature**, with the comfort label Domoticz gives to humidity
  (Normal, Comfortable, Dry or Wet).

Domoticz does not use the monitor's `offline` status. When the monitor goes
offline, the devices keep the last value until the **Sensor Timeout** in
Domoticz's settings expires (60 minutes by default), and then they show a
timeout.

## Node-RED

An open-source tool for visual programming, wiring blocks into a flow from the
browser. It is widely used to connect devices and services to each other, on
its own or next to other home automation systems.

Node-RED does not read auto-discovery: a flow subscribes to the monitor's
topics directly. The handiest one is `<base>/state`, which carries the three
readings in a single JSON message, plus `<base>/status` to know whether the
monitor is online.

The example below does just that. It shows the readings on a dashboard and
warns when CO₂ goes above 1000 ppm and when it comes back down.

<div class="photo-todo" markdown>
**TODO:** screenshot of the Node-RED dashboard
</div>

The dashboard is the **FlowFuse Dashboard** (Dashboard 2.0). Install it first
from the menu (☰) → **Manage palette** → **Install**: search for
`@flowfuse/node-red-dashboard`. Then import the flow from the menu (☰) →
**Import**, and:

1. Open the **Broker** node and enter your broker address, and the user and
   password in the **Security** tab.
2. If you changed the **Topic base** on the monitor, use it in the two MQTT
   nodes. `co2monitor/+/…` matches every monitor with the default topic base.
3. Press **Deploy**.

Open `http://<node-red>:1880/dashboard` to see a gauge with the monitor's
color scale, temperature, humidity, the status and a chart of the last six
hours. The chart is kept in Node-RED's memory, so it starts empty again when
Node-RED restarts. The readings and the status also show in the debug sidebar
and under the nodes. To
act on the warning, replace the **Ventilate** node with a notification, a
relay or whatever fits your setup.

??? example "Example flow"
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

The `+` matches any monitor, so one flow serves several of them; `msg.topic`
tells them apart, for example `co2monitor/a64102/state`.

## ioBroker

An open-source integration and home automation platform. Each integration is
an adapter, and the data from all of them becomes states that can be shown on
dashboards and used in automations.

ioBroker reads the monitor's topics with the **MQTT Broker/Client** adapter,
used as a client of your broker. It does not read auto-discovery: it creates
one state per topic.

1. In **Adapters**, find **MQTT Broker/Client** and add an instance.
2. In the instance settings, tab **Connection**: choose the client type, and
   enter the broker address, port, user and password.
3. Tab **Client settings**: in **Subscribe patterns**, replace the default
   with `co2monitor/#`, or with your **Topic base** followed by `/#`.
4. Tab **MQTT Settings**: clear **Mask to publish own states** and leave
   **Publish own states on connect** unticked. The adapter only has to read;
   otherwise it could publish its own states to the broker.
5. **Save and close.** The instance turns green when it connects.

!!! warning
    The password has to be entered in this settings page. ioBroker stores it
    encrypted, so setting it from the command line with `iobroker set` does
    not work: the adapter is then refused by the broker.

The states appear under **Objects → mqtt.0 → co2monitor → xxxxxx**:

| State | Content |
|---|---|
| `co2`, `temperature`, `humidity` | The readings, as numbers |
| `state` | The three readings as JSON text |
| `status` | `online` / `offline` |
| `info` | Diagnostics as JSON text |

The states have no unit. If you want one in charts and visualisations, edit
the object and set it: `ppm`, `°C` and `%`.

When the monitor goes offline, `status` changes to `offline` and the readings
keep their last value. Use `status` in your scripts to tell a current reading
from an old one.

## InfluxDB and Grafana

InfluxDB is a database made for time-stamped measurements, and Grafana a tool
that draws them on chart dashboards. Telegraf is the agent that carries the
data into InfluxDB. All three are open source.

To keep the readings for months and chart them, the usual recipe is
**Telegraf**, which reads them from the broker, **InfluxDB**, which stores
them, and **Grafana**, which draws them.

<figure markdown="span">
  ![Grafana dashboard with CO₂ gauges, temperature, humidity and CO₂ history for three monitors](img/grafana.png)
  <figcaption>The dashboard you can import in step 4, with three monitors.</figcaption>
</figure>

1. In InfluxDB 2, create a bucket called `co2`, and an API token that can
   write to it (for Telegraf) and read from it (for Grafana). Choose the
   bucket's retention: one reading per minute is about 500,000 points a year
   per monitor, which InfluxDB handles easily.
2. Add this to Telegraf's configuration, with your broker, user, password,
   InfluxDB address, organisation and token:

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

    Telegraf stores one point per message on `<base>/state`, with the fields
    `co2`, `temperature` and `humidity`, in the measurement `co2monitor`. The
    monitor's code becomes the `device` tag, so several monitors share the
    bucket and can still be told apart.

3. In Grafana, add an **InfluxDB** data source with the query language
   **Flux**, the InfluxDB address, the organisation, the token and the default
   bucket `co2`.
4. Download the [dashboard](assets/grafana-co2-monitor.json) and import it
   from **Dashboards → New → Import**, choosing that data source.

The dashboard shows a CO₂ gauge with the monitor's color scale, the current
temperature and humidity, and a chart of each. Each monitor is one line,
named after its code.

!!! note "A topic base of your own"
    The configuration above relies on the default topic base,
    `co2monitor/xxxxxx`, to read the device code. If you changed the
    **Topic base**, put it in `topics` and in `topic_parsing`, and point the
    `device` tag at the level that tells your monitors apart.

## ThingsBoard

An IoT platform to collect, process and visualise device data, with
dashboards, alarms and rules. It has a Community edition that you install on
your own server, plus commercial and cloud versions.

ThingsBoard neither reads auto-discovery nor subscribes to someone else's
broker: devices connect to it. The bridge is the **ThingsBoard IoT Gateway**,
which subscribes to your broker, reads the monitor's topics and registers each
monitor as a ThingsBoard device.

!!! warning "ThingsBoard version"
    Since 4.4, ThingsBoard Community Edition is released under the BUSL 1.1
    licence, and a new installation lets nobody in until it is activated with
    an account on its licence portal, which is free. The 4.3 LTS branch, which
    the test used, does not ask for it. The monitor works the same with both.

1. In ThingsBoard, go to **Entities → Gateways** and add a gateway. Start it
   with the Docker command that ThingsBoard offers, which already carries its
   access token. The gateway must be able to reach your broker.
2. In the gateway, add a connector of type **MQTT** and paste this
   configuration into its advanced mode, with your broker's address, user and
   password:

    ??? example "Connector configuration"
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

3. Save. Each monitor shows up in **Entities → Devices** as
   `co2monitor/xxxxxx`, with the `CO2 monitor` profile, as soon as it
   publishes.
4. Download the [dashboard](assets/thingsboard-co2-monitor.json) and import it
   from **Dashboards → + → Import dashboard**.

Each monitor gets `co2`, `temperature`, `humidity` and `rssi` as telemetry,
and as attributes what it publishes on `<base>/info`: versions, IP, host name,
uptime and the reason for the last restart.

The dashboard shows CO₂ in the monitor's colours, the current temperature and
humidity, the monitor's details and a chart of each reading. With several
monitors, pick the one to show in the selector on the top bar.

<div class="photo-todo" markdown>
**TODO:** screenshot of the ThingsBoard dashboard
</div>

!!! note "Online or offline"
    The gateway cannot match `<base>/status` to a monitor, because that
    message is plain text and the monitor's name is only in the topic.
    ThingsBoard marks the device inactive when readings stop coming, after 10
    minutes by default.

!!! note "A topic base of your own"
    The configuration uses the default topic base, `co2monitor/xxxxxx`. If you
    changed the **Topic base**, put it in both `topicFilter` entries and both
    `deviceNameExpression` entries, which are regular expressions over the
    topic.

## Azure Event Grid

A Microsoft Azure messaging service, paid per use, that includes an MQTT
broker in the cloud. It carries the monitor's readings to other Azure
services, such as databases, functions or data analytics.

The Azure Event Grid MQTT broker takes no user and password: each device
identifies itself with a **client certificate**. The monitor supports that,
so it can publish straight to Azure, with no broker in between.

Three things must match:

| In Azure | On the monitor |
|---|---|
| *Client authentication name* | **User** |
| Client *thumbprint* | Fingerprint of the certificate you paste on the web page |
| *Topic space* template | **Topic base** |

### 1. Create the certificate

With thumbprint validation a self-signed certificate will do, with no CA.
Create it with OpenSSL, with an EC P-256 key and no passphrase:

```sh
openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes \
  -keyout co2-monitor.key -out co2-monitor.crt -days 365 \
  -subj "/CN=co2-monitor-xxxxxx"

openssl x509 -in co2-monitor.crt -noout -fingerprint -sha256 | cut -d= -f2 | tr -d ':'
```

The last command prints the SHA-256 fingerprint in the format Azure asks for.

- **EC P-256** makes the TLS handshake much faster than RSA on the monitor.
- **`-nodes`** leaves the key without a passphrase. The monitor does not take
  encrypted keys.
- **The certificate expires** after 365 days. Before that, create another,
  change the thumbprint in Azure and paste the new one into the monitor.

### 2. Set up Event Grid

In the Event Grid *namespace*, in the Azure portal:

1. **Configuration:** tick **Enable MQTT broker** and save. **Overview** then
   shows the broker's host name, in the form
   `<namespace>.<region>-1.ts.eventgrid.azure.net`.
2. **Clients → + Client:**
    - **Client authentication name:** for example `co2-monitor-xxxxxx`.
    - **Client certificate authentication validation scheme:**
      **Thumbprint Match**.
    - **Primary thumbprint:** the fingerprint from the previous step.
3. **Topic spaces → + Topic space**, with the template `co2monitor/#`. If you
   changed the monitor's **Topic base**, the template must cover it.
4. **Permission bindings → + Permission binding:** **Publisher** permission
   on that topic space. The `$all` group is enough to start with. For real
   use, create a group for the monitors only.

To read the data from another client, register it the same way and add a
**Subscriber** permission on the same topic space.

### 3. Set up the monitor

On the monitor's web page, under **MQTT**:

| Setting | Value |
|---|---|
| Broker | `mqtts://<namespace>.<region>-1.ts.eventgrid.azure.net:8883` |
| User | The *client authentication name* |
| Password | Empty |
| CA certificate | Empty: Azure's authority is built into the firmware |
| Client certificate | The contents of `co2-monitor.crt` |
| Private key | The contents of `co2-monitor.key` |
| Home Assistant auto-discovery | Unticked, unless the topic space also covers `homeassistant/#` |

Save. The monitor connects within a few seconds. In the portal, the
namespace's **Metrics** show the connections and the published messages.

In the test, the monitor stayed connected with its retained messages
(`status` and `info`) and its last will.

!!! note "If it does not connect"
    - **Rejected as not authorised:** the user does not match the
      *client authentication name*, or the registered thumbprint is not the
      one of the certificate on the monitor. Check the certificate's CN too,
      with `openssl x509 -in co2-monitor.crt -noout -subject`.
    - **Connects but nothing arrives:** the **Publisher** permission is
      missing, or the topic base is not covered by the topic space template.

!!! warning
    The private key is stored in the monitor's flash unencrypted, like the
    passwords. If you lose control of the device, disable its client in Azure.
