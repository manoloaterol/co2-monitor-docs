# Other home automation systems

Besides Home Assistant, several home automation systems understand the
monitor's auto-discovery messages and set it up on their own. They only need
to reach the same MQTT broker. Others, like Node-RED, read the monitor's
topics directly.

| System | Tested version | Finds the monitor on its own | Notes |
|---|---|---|---|
| Home Assistant | 2026.9 | Yes | See [MQTT & Home Assistant](mqtt.md#home-assistant) |
| openHAB | 5.2 | Yes, in the Inbox | Needs two add-ons; set the units of the items |
| Domoticz | 2026.4 | Yes | Temperature and humidity become a single device |
| Node-RED | 5.0 | No: it reads the topics | Example flow to import below |

In every case, leave **Home Assistant auto-discovery** ticked on the monitor's
web page, even if you do not use Home Assistant: these systems read the same
messages. If you changed the **Discovery prefix**, use the same one in them.

Any other MQTT client can read the plain topics directly. They are described
in [MQTT & Home Assistant](mqtt.md#topics).

## openHAB

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

Node-RED does not read auto-discovery: a flow subscribes to the monitor's
topics directly. The handiest one is `<base>/state`, which carries the three
readings in a single JSON message, plus `<base>/status` to know whether the
monitor is online.

The example below does just that, and warns when CO₂ goes above 1000 ppm and
when it comes back down. Import it from the menu (☰) → **Import**, then:

1. Open the **Broker** node and enter your broker address, and the user and
   password in the **Security** tab.
2. If you changed the **Topic base** on the monitor, use it in the two MQTT
   nodes. `co2monitor/+/…` matches every monitor with the default topic base.
3. Press **Deploy**.

The readings and the status show in the debug sidebar and under the nodes. To
act on the warning, replace the **Ventilate** node with a notification, a
relay or whatever fits your setup.

??? example "Example flow"
    ```json
    [
      {"id": "co2tab", "type": "tab", "label": "CO2 monitor"},
      {"id": "co2broker", "type": "mqtt-broker", "name": "Broker", "broker": "192.168.1.10", "port": "1883", "clientid": "", "autoConnect": true, "usetls": false, "protocolVersion": "4", "keepalive": "60", "cleansession": true},
      {"id": "co2state", "type": "mqtt in", "z": "co2tab", "name": "Readings", "topic": "co2monitor/+/state", "qos": "0", "datatype": "json", "broker": "co2broker", "nl": false, "rap": true, "rh": 0, "inputs": 0, "x": 120, "y": 80, "wires": [["co2debug", "co2high"]]},
      {"id": "co2status", "type": "mqtt in", "z": "co2tab", "name": "Online / offline", "topic": "co2monitor/+/status", "qos": "1", "datatype": "utf8", "broker": "co2broker", "nl": false, "rap": true, "rh": 0, "inputs": 0, "x": 130, "y": 200, "wires": [["co2debugstatus"]]},
      {"id": "co2high", "type": "function", "z": "co2tab", "name": "Above 1000 ppm?", "func": "// Warn only when CO2 crosses the threshold, not on every reading\nconst high = msg.payload.co2 >= 1000;\nconst key = \"high_\" + msg.topic;\nif (context.get(key) === high) return null;\ncontext.set(key, high);\nmsg.payload = `CO2 ${msg.payload.co2} ppm: ` + (high ? \"ventilate\" : \"back to normal\");\nreturn msg;", "outputs": 1, "x": 360, "y": 140, "wires": [["co2alert"]]},
      {"id": "co2alert", "type": "debug", "z": "co2tab", "name": "Ventilate", "active": true, "tosidebar": true, "console": false, "tostatus": false, "complete": "payload", "targetType": "msg", "x": 580, "y": 140, "wires": []},
      {"id": "co2debug", "type": "debug", "z": "co2tab", "name": "Reading", "active": true, "tosidebar": true, "console": false, "tostatus": true, "complete": "payload", "targetType": "msg", "statusVal": "payload.co2", "statusType": "msg", "x": 340, "y": 80, "wires": []},
      {"id": "co2debugstatus", "type": "debug", "z": "co2tab", "name": "Status", "active": true, "tosidebar": true, "console": false, "tostatus": true, "complete": "payload", "targetType": "msg", "statusVal": "payload", "statusType": "msg", "x": 340, "y": 200, "wires": []}
    ]
    ```

The `+` matches any monitor, so one flow serves several of them; `msg.topic`
tells them apart, for example `co2monitor/a64102/state`.
