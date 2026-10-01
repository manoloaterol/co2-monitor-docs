# Getting started

## 1. Power it

Plug the monitor into any USB charger with the included cable. A 5 V,
0.5 A charger or more is enough.

The boot screen shows three versions: the firmware, the hardware and the
sensor's own firmware. If the sensor line shows `ERROR` in red, see
[Help](help.md#no-readings-check-the-sensor).

The first readings appear within seconds and settle after a few minutes.

!!! tip "Where to put it"
    Place it at about head height, away from windows, heaters and direct
    sunlight, and where nobody breathes straight onto it. Exhaled air carries
    about 40,000 ppm of CO₂, so a monitor on a desk right in front of you
    reads high.

At this point it already works as a stand-alone monitor. Connecting it to a
network is optional.

## 2. Connect it to your Wi-Fi

On first power-up, the monitor has no network saved. It starts **setup
mode**: it creates its own Wi-Fi network, called `CO2-Monitor-xxxxxx`. The
screen shows its exact name.

1. On your phone or computer, join the `CO2-Monitor-xxxxxx` network. It has
   no password.
2. The setup page opens by itself. If it does not, open a browser and go to
   **`http://192.168.4.1`**.
3. Under **Network**, choose your Wi-Fi and type its password.
4. Optionally, under **MQTT**, enter your broker. For Home Assistant, see
   [MQTT & Home Assistant](mqtt.md#home-assistant).
5. Press **Save**. The monitor restarts and joins your network.

!!! warning "2.4 GHz only"
    The monitor cannot join a 5 GHz network. Most routers offer both bands
    under the same name, and that works. A router with only 5 GHz does not.

## 3. Find it on your network

Once on your network, the same page is at
**`http://co2-monitor-xxxxxx.local`**, where `xxxxxx` is the same code as in
the setup network's name. Use it to change any setting, update the firmware
or calibrate the sensor. See [Web page & settings](web-page.md).

If the `.local` address does not open, look up the monitor's IP address in
your router and use that. See [Help](help.md#the-local-address-does-not-open).

The blue LED is steady once the monitor is connected. See [Status LED](user-guide.md#status-led).
