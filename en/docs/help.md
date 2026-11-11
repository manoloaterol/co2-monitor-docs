# Help

## NO READINGS · CHECK THE SENSOR

The sensor has not given a reading for 10 seconds. The display shows dashes,
and the web page shows the same state. The warning clears on its own as soon
as a reading comes back.

Unplug the monitor and plug it back in. If the warning stays, or the boot
screen shows the sensor line as `ERROR` in red, contact us. See [Contact](#contact).

## Readings are high right after power-up

The sensor needs a few minutes to settle. Check also that nobody is breathing
onto it: exhaled air carries about 40,000 ppm of CO₂.

## The temperature reads high

The sensor warms itself slightly while it works. Correct it once against a
good thermometer. See [Temperature](calibration.md#temperature).

## CO₂ does not match another monitor or outdoor air

Outdoors it should read about 430 ppm, and two monitors side by side can
differ somewhat without either being wrong. See [Calibration](calibration.md),
which starts with a table of each situation and what to do.

## The setup page does not open

- Check that your phone is joined to the `CO2-Monitor-xxxxxx` network. Some
  phones leave a network with no internet on their own. If yours asks, choose
  to stay connected.
- Open `http://192.168.4.1` in a browser. Type `http://`: some browsers try
  `https://` first, and the monitor does not serve it.

## It does not join my Wi-Fi

- The network must be **2.4 GHz**. 5 GHz is not supported.
- Check the password. Enter setup mode (hold the centre of the joystick for
  3 seconds) and type it again.
- If you have a serial console connected, it logs the reason for every
  disconnection: `201` means the network was not found; `202`, or `15`
  repeated, means a wrong password; `200` means the signal was lost.

If it loses the Wi-Fi, the monitor never gives up. It retries more and more
slowly: 1 s, 2 s, 4 s… up to one attempt a minute.

## The Wi-Fi is weak where I want to put it

The monitor adjusts its transmit power on its own. It normally transmits at
15 dBm, which is enough near the router and draws less. If the router's
signal drops below about −70 dBm, or it fails to connect after several
attempts, it goes up to 20 dBm, the maximum. It goes back to 15 dBm once the
signal recovers above about −60 dBm. The top of the web page shows the power
in use, next to the signal.

The monitor connects straight to your router, like any other Wi-Fi device.
If even so the signal is weak where you want it, extend your Wi-Fi with a
repeater or a mesh Wi-Fi system. The monitor joins it as an ordinary device,
and its web page, `.local` address and updates keep working.

## The `.local` address does not open

The `co2-monitor-xxxxxx.local` name relies on mDNS. Most computers and phones
support it, but some networks, older Android phones and some browsers do
not. Instead:

- find the monitor's IP address in your router's list of devices, and open
  `http://<that IP>`;
- or, if your router registers device names, try `http://co2-monitor-xxxxxx`
  with your router's domain, for example `co2-monitor-xxxxxx.home`.

## The LED keeps blinking

The monitor is on your network but cannot reach the MQTT broker. Check the
broker address, user and password on the web page. The live status at the
top of the page says whether MQTT is connected and to which host.

With `mqtts://`, the host name must match the broker's certificate. See [TLS](mqtt.md#tls).

## It does not appear in Home Assistant

- Check that Home Assistant's MQTT integration is connected to the **same
  broker** as the monitor.
- Check that **Home Assistant auto-discovery** is ticked, and that the
  **Discovery prefix** matches Home Assistant's. The default is `homeassistant`.
- Watch the broker with `mosquitto_sub -t 'homeassistant/#' -v` to see whether
  the discovery messages arrive.

## I turned Wi-Fi off and lost the page

With Wi-Fi disabled, the monitor does not transmit at all. Hold the centre of
the joystick for 3 seconds to enter setup mode, and turn Wi-Fi back on from
the page.

## Contact

Open an issue in the [firmware repository](https://github.com/manoloaterol/co2-monitor-firmware/issues), or write to us
through the shop where you bought the monitor.
