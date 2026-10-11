# Web page & settings

The monitor serves its own settings page:

- in setup mode, at `http://192.168.4.1`. See [Setup mode](user-guide.md#setup-mode);
- on your network, at `http://co2-monitor-xxxxxx.local`, or at its IP address.

The page is in English and Spanish. It opens in the language of the
display, and the EN/ES selector at the top remembers another choice in that
browser.

## Live status

The top of the page shows, live:

- the current reading;
- the sensor state;
- the Wi-Fi signal;
- whether MQTT is connected;
- the uptime.

## Settings

The settings are grouped in sections that fold open. **Brightness, the display
language and the LED** apply when you save, without a restart. Any other
change restarts the monitor.

### Network

| Setting | |
|---|---|
| Wi-Fi enabled | With Wi-Fi off, the monitor stops transmitting altogether: no network, no setup network and no page. To get back, hold the centre of the joystick for 3 seconds |
| Wi-Fi | The network to join. **Scan again** refreshes the list |
| Password | Left blank, the stored one is kept |

### MQTT

| Setting | |
|---|---|
| Broker | `mqtt://host:1883` unencrypted, or `mqtts://host:8883` with TLS. Empty publishes nothing |
| User, Password | The broker's credentials. Changing the broker's host clears the stored password unless you type it again |
| Clear the stored password | For a broker with no password, after using one with |
| Home Assistant auto-discovery | On by default. See [Home Assistant](integrations.md#home-assistant) |
| Discovery prefix | `homeassistant` by default. Only change it if Home Assistant uses another one |

Under **Advanced: topics and TLS**:

| Setting | |
|---|---|
| Topic base | Where every topic hangs from. Empty uses `co2monitor/xxxxxx`. See [Topics](mqtt.md#topics) |
| Retain readings | Off by default. See [Retained readings](mqtt.md#retained-readings) |
| CA certificate | Only for a broker with its own CA. See [TLS](mqtt.md#tls) |
| Client certificate, private key | For brokers that identify the device by certificate. See [TLS](mqtt.md#client-certificates) |

### Display

| Setting | Default | |
|---|---|---|
| Brightness | 100 % | It is the largest share of the power draw |
| Dimmed brightness | 3 % | What a short press gives. At 0 the display goes off |
| Screen language | English | English or Spanish |
| Status LED | On | See [Status LED](user-guide.md#status-led) |
| Chart bars | 40 | 20, 25, 40, 50 or 100 |
| Each bar | 20 s | From 20 s to 5 min. It is also how often readings are published over MQTT |

Changing the chart restarts the monitor and clears its history.

### Sensor

| Setting | |
|---|---|
| Altitude (m) | CO₂ readings depend on air pressure. Below about 200 m the correction is smaller than the sensor's own error. See [Altitude](calibration.md#altitude) |
| Calibrate temperature | See [Temperature](calibration.md#temperature) |

### CO₂ calibration

Recalibrates the sensor against fresh air, and undoes the last
calibration. See [CO₂ calibration](calibration.md#co2-calibration).

### System

| Setting | |
|---|---|
| Name | What Home Assistant shows. Empty uses the default name with the device code |
| Versions | Firmware, hardware and SCD30 sensor |
| Firmware update | See [Firmware update](firmware-update.md) |
| Restart without saving | Restarts the monitor. In setup mode, it also leaves it |

## Security

The page has no password: anyone on your network can open it, as they can
see the device. What it does prevent is a website on the internet using it
through the browser of someone in your home:

- Every request that changes something (save, restart, upload firmware)
  must carry the `X-CO2-Monitor` header. A foreign website cannot add it
  without asking the device first, and the device never allows it.
- The monitor only answers requests addressed to an IP address or to its own
  name. This stops *DNS rebinding*.
- Changing the broker's host clears the stored MQTT password, unless a new
  one is typed. Nobody can point the monitor at their own broker to collect
  your password.
- Firmware updates only accept firmware for this device.

For your own scripts, add the header:

```sh
curl -H 'X-CO2-Monitor: 1' ...
```
