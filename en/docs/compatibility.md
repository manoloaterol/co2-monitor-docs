# Compatibility

The monitor publishes its readings over MQTT, so it can work with any system
that speaks MQTT. This page sums up what the monitor accepts, what it has
been tested with, and what should work although it has not been checked.

## MQTT

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

The topics and their formats are in [MQTT & Home Assistant](mqtt.md#topics),
and the TLS details in [TLS](mqtt.md#tls).

## Tested

Tests made in October 2026 with the versions shown. Each system has its own
guide.

### Home automation

| System | Version | How |
|---|---|---|
| Home Assistant | 2026.9 | Finds it on its own. [Guide](mqtt.md#home-assistant) |
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
| Mosquitto 2 | `mqtt://` with user and password | [MQTT & Home Assistant](mqtt.md) |
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
