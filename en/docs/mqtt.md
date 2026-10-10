# MQTT & Home Assistant

The monitor works with any MQTT broker and any MQTT client. Home Assistant is
one more client, not a requirement: openHAB and Domoticz also find the
monitor on their own, see [Other systems](integrations.md).

## Topics

Every topic hangs from a **topic base**. By default it is
`co2monitor/xxxxxx`, with the device code, so several monitors can share a
broker without any setup. It can be replaced on the web page, for example
with `home/living-room/co2`. It cannot contain `+` or `#` or empty levels, and
it can be at most 63 characters long.

| Topic | Content | Retained | QoS |
|---|---|---|---|
| `<base>/co2` | CO₂ in ppm, integer: `812` | optional | 0 |
| `<base>/temperature` | °C with one decimal: `22.4` | optional | 0 |
| `<base>/humidity` | % relative humidity, integer: `48` | optional | 0 |
| `<base>/state` | All three as JSON: `{"co2":812,"temperature":22.4,"humidity":48}` | optional | 0 |
| `<base>/status` | `online` / `offline` | yes | 1 |
| `<base>/info` | Diagnostics as JSON: `fw`, `hw`, `sensor_fw`, `ip`, `mac`, `hostname`, `rssi`, `uptime_s`, `reset` (why it last restarted: `power_on`, `software`, `panic`, `task_wdt`, `brownout`…), `chart_bar_s` (seconds per chart bar, which is also how often readings are published) | yes | 1 on connect, 0 after |

- **How often.** Readings are published once per chart bar, as the average
  of the sensor's readings over that time. By default that is every 20 s, the
  average of 10 readings. An MQTT client sees the same curve as the display.
  `info` is refreshed on connect and every 5 minutes.
- **Plain or JSON.** The plain topics and `state` carry the same values with
  the same rounding. `state` is handy for Telegraf/InfluxDB, Node-RED or
  ioBroker, because each message carries a whole sample.
- **Status.** The monitor publishes `offline` before a restart it makes on
  purpose. If it disappears without warning, the broker publishes `offline`
  for it, as its *last will*.

To watch it from a computer:

```sh
mosquitto_sub -h broker.local -u user -P password -t 'co2monitor/#' -v
```

### Retained readings

**Retain readings** is a checkbox on the web page, off by default. With it, a
new subscriber gets the last value at once. Without it, the subscriber waits
for the next publication.

Always check `status` as well: a retained value from a monitor that is
`offline` is not current.

### On restart

Saving settings, updating, the restart button, and entering or leaving setup
mode all restart the monitor. Before it restarts, it signs off from the broker:
it publishes `offline` and disconnects cleanly, so Home Assistant shows it as
unavailable at once.

If you turn retained readings off, or change the topic base, the monitor also
clears what it left retained under the old settings. It can only do this if
it is connected to the broker at that moment. If it is not, the old messages
stay, and you have to clear them by hand by publishing an empty retained
message to each topic.

## TLS

The broker can be `mqtt://` (usually port 1883) or `mqtts://` (usually port
8883). With `mqtts://` the broker's certificate **is always verified**:

- **With the CA field empty**, it is checked against the common public
  authorities built into the firmware. This is right for cloud brokers (HiveMQ
  Cloud, EMQX Cloud…) and for any broker with a Let's Encrypt certificate.
- **If your broker uses its own CA**, such as a Mosquitto with self-signed
  certificates, paste its `ca.crt` in PEM into the CA field.

The host name in the broker address must match the certificate. If the
certificate is for `broker.example.com`, connecting by IP address or by a
`.local` name fails the verification.

### Client certificates

Some brokers identify the device by a **client certificate** instead of a
password (mutual TLS), such as Azure Event Grid or AWS IoT. For them, paste
the certificate and its private key in PEM on the web page.

- The key cannot be protected with a passphrase.
- The key is never shown again. Leave the field blank to keep the stored one.
- Emptying the certificate deletes both.
- The user name is still sent, because Event Grid checks it against the
  client's *authentication name*.

!!! note
    The key is stored in the monitor's flash without encryption, the same as
    the Wi-Fi and MQTT passwords.

## Home Assistant

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
which point to the same topics as above. Clients that are not Home Assistant
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

<div class="photo-todo" markdown>
**TODO:** screenshot of the card
</div>

1. In HACS, open the menu (⋮), choose **Custom repositories** and add
   **TODO: card repository URL** with the type **Dashboard**.
2. Find **CO2 Monitor Card** in HACS, download it and reload the browser.
3. Edit a dashboard, choose **Add card** and search for **CO2 Monitor**.

The card picks your monitor and its sensors on its own, and takes the
seconds per bar from the monitor, so its chart matches the display. It can show
more bars than the display, as a longer stretch of history. The card's page
explains every option and how to install it without HACS.
