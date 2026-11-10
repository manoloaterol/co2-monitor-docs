# CO₂ Monitor

An indoor CO₂ monitor with NDIR technology, a colour IPS display and its own
web page, opened from your network or, with no network, through its own access
point. It publishes over MQTT and integrates automatically with systems such
as Home Assistant, openHAB or Domoticz. It also works as a stand-alone
monitor, with no need to join any network.

<div class="photo-todo" markdown>
**TODO:** product photo
</div>

[:material-cart: Buy on Tindie](https://www.tindie.com/TODO){ .md-button .md-button--primary }
[:material-cart: Buy on Lectronz](https://lectronz.com/TODO){ .md-button }

## What it does

- **Measures CO₂, temperature and humidity** with a Sensirion SCD30. It is a
  real NDIR CO₂ sensor, not an "eCO₂" estimate worked out from other gases.
- **Shows them on a 1.83" colour IPS display**, with a history chart. The colours
  follow published indoor air guidelines. See [Reading the colours](user-guide.md#reading-the-colours).
- **Publishes over standard MQTT**, with or without TLS. See [MQTT & compatibility](mqtt.md).
- **Appears in Home Assistant** through MQTT discovery, with no YAML to write.
- **Is set up from its own web page.** No cloud, no account and no app. See [Web page & settings](web-page.md).
- **Updates over the network**, and goes back to the previous firmware on its
  own if an update fails. See [Firmware update](firmware-update.md).

New here? Start with [Getting started](getting-started.md).

## Specifications

| | |
|---|---|
| Microcontroller | ESP32-S2, 4 MB flash, PSRAM |
| CO₂ sensor | Sensirion SCD30, NDIR |
| CO₂ range | 400–10,000 ppm |
| CO₂ accuracy | ±(30 ppm + 3 % of reading) |
| Also measures | Temperature, relative humidity |
| Display | 1.83" IPS, 240×280, colour |
| Controls | 3-way joystick, blue status LED |
| Wireless | Wi-Fi 802.11 b/g/n, **2.4 GHz only** |
| Protocols | MQTT 3.1.1 (TLS 1.2 optional), HTTP, mDNS |
| Power | 5 V over micro-USB (USB Micro-B) |
| Consumption | About 77 mA at full brightness (≈0.4 W), about 43 mA with the screen off |
| Dimensions / weight | **TODO** |
| In the box | CO₂ monitor, USB cable |

<div class="photo-todo" markdown>
**TODO:** dimension drawing
</div>
