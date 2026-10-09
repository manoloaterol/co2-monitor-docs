# Other home automation systems

Besides Home Assistant, several home automation systems understand the
monitor's auto-discovery messages and set it up on their own. They only need
to reach the same MQTT broker.

| System | Tested version | Finds the monitor on its own | Notes |
|---|---|---|---|
| Home Assistant | 2026.9 | Yes | See [MQTT & Home Assistant](mqtt.md#home-assistant) |
| openHAB | 5.2 | Yes, in the Inbox | Needs two add-ons; set the units of the items |
| Domoticz | 2026.4 | Yes | Temperature and humidity become a single device |

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
