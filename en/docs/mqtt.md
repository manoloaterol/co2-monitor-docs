# MQTT & compatibility

The monitor publishes its readings over standard MQTT, so it should work with
any MQTT broker and any MQTT client. This page describes what it accepts, its
topics and its security, and what it has been tested with. The steps for each
system are in [Integrations](integrations.md).

## What it accepts

| | |
|---|---|
| Protocol | MQTT 3.1.1. Brokers with MQTT 5 accept 3.1.1 clients |
| Role | Publishes only. It subscribes to no topic and takes no commands |
| Connection | `mqtt://` unencrypted or `mqtts://` with TLS 1.2, on any port |
| Broker certificate | Always verified: against the common public authorities built into the firmware, or against a CA of your own in PEM |
| Authentication | User and password, client certificate (mutual TLS), or both |
| Client identifier | `co2monitor_xxxxxx`, with the device code. It cannot be changed |
| Topics | Configurable topic base. Each reading on its own topic, and the three together in JSON |
| QoS | 0 for readings; 1 for the status and for the diagnostics on connecting. Never 2 |
| Retained messages | Optional for readings. Status and diagnostics are always retained |
| Last will | `<base>/status` turns `offline` if the monitor drops without notice |
| Discovery | Home Assistant format, with a configurable prefix. It can be turned off |

**Not supported:** MQTT 5 as its own protocol, MQTT over WebSocket, TLS 1.3,
passphrase-protected private keys or incoming commands.

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
| `<base>/info` | Diagnostics as JSON: `fw`, `hw`, `sensor_fw`, `ip`, `mac`, `hostname`, `rssi`, `tx_dbm` (transmit power in use: 15 or 20 dBm), `uptime_s`, `reset` (why it last restarted: `power_on`, `software`, `panic`, `task_wdt`, `brownout`…), `chart_bar_s` (seconds per chart bar, which is also how often readings are published) | yes | 1 on connect, 0 after |

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
  authorities built into the firmware. That is how it was tested with Azure
  Event Grid. It should also do for other cloud brokers, such as HiveMQ Cloud
  or EMQX Cloud, and for any broker with a Let's Encrypt certificate, although
  that has not been validated.
- **If your broker uses its own CA**, such as a Mosquitto with self-signed
  certificates, paste its `ca.crt` in PEM into the CA field.

The host name in the broker address must match the certificate. If the
certificate is for `broker.example.com`, connecting by IP address or by a
`.local` name fails the verification.

### Client certificates

Some brokers identify the device by a **client certificate** instead of a
password (mutual TLS), such as Azure Event Grid (see the
[guide](integrations.md#azure-event-grid)) or AWS IoT Core, which should work
but has not been validated. For them, paste the certificate and its private
key in PEM on the web page.

- The key cannot be protected with a passphrase.
- The key is never shown again. Leave the field blank to keep the stored one.
- Emptying the certificate deletes both.
- The user name is still sent, because Event Grid checks it against the
  client's *authentication name*.

!!! note
    The key is stored in the monitor's flash without encryption, the same as
    the Wi-Fi and MQTT passwords.

## Tested

Tests made in October 2026 with the versions shown. Each system has its own
guide.

### Home automation

| System | Version | How |
|---|---|---|
| Home Assistant | 2026.9 | Finds it on its own. [Guide](integrations.md#home-assistant) |
| openHAB | 5.2 | Finds it on its own. [Guide](integrations.md#openhab) |
| Domoticz | 2026.4 | Finds it on its own. [Guide](integrations.md#domoticz) |
| Node-RED | 5.0 | Reads the topics. [Guide](integrations.md#node-red) |
| ioBroker | js-controller 7.2, MQTT adapter 6.1 | Reads the topics. [Guide](integrations.md#iobroker) |

### Data and IoT platforms

| System | Version | How |
|---|---|---|
| InfluxDB + Grafana | Telegraf 1.40, InfluxDB 2.9, Grafana 13.2 | Telegraf reads the topics. [Guide](integrations.md#influxdb-and-grafana) |
| ThingsBoard | 4.3 LTS, IoT Gateway 3.8 | The gateway reads the topics. [Guide](integrations.md#thingsboard) |

### Brokers

| Broker | Connection | Guide |
|---|---|---|
| Mosquitto 2 | `mqtt://` with user and password | [Home Assistant](integrations.md#home-assistant) |
| Azure Event Grid | `mqtts://` with a client certificate | [Guide](integrations.md#azure-event-grid) |

## Should work, but not validated

These cases use the same features that have been tested, but have not been
checked with the monitor:

- **Any other MQTT 3.1.1 or 5 broker** on your network, such as EMQX,
  HiveMQ CE, NanoMQ or the broker built into other home automation systems.
- **Cloud brokers with user and password**, such as HiveMQ Cloud or EMQX
  Cloud. Their certificate is usually signed by one of the public authorities
  built into the firmware.
- **AWS IoT Core**, with a client certificate as in Azure. The monitor's
  client identifier cannot be changed, so the AWS IoT policy must allow
  `co2monitor_xxxxxx`.
- **Other systems that read MQTT**, such as Homey, Hubitat or FHEM, by
  reading the monitor's topics.

If you try it with one of them, we would like to hear how it went.
