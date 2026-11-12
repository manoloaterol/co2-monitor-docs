# User guide

## Screens

Move the joystick **left or right** to change screen.

| Screen | Shows |
|---|---|
| **Big CO₂** | Only the value, 85 px tall, framed in the colour of its level. It can be read from across the room. This is the screen at start-up |
| **CO₂** | The CO₂ value in large digits and its history chart |
| **CO₂ + climate** | The same, plus temperature and humidity |

<div class="screens" markdown>
<figure markdown="span">
  ![Big CO₂ screen: 1505 ppm framed in yellow](img/screen-large.jpg)
  <figcaption>Big CO₂</figcaption>
</figure>
<figure markdown="span">
  ![CO₂ screen: 1497 ppm and the history chart](img/screen-chart.jpg)
  <figcaption>CO₂</figcaption>
</figure>
<figure markdown="span">
  ![CO₂ + climate screen: 1492 ppm, 23.7 °C, 79 % and the chart](img/screen-climate.jpg)
  <figcaption>CO₂ + climate</figcaption>
</figure>
</div>

Each bar of the chart is the average of the readings over its time. By
default there are 40 bars of 20 s each, which gives 13 minutes of history. Both
can be changed on the [web page](web-page.md#display).

## Joystick

| Action | What it does |
|---|---|
| ++arrow-left++ / ++arrow-right++ | Change screen |
| Short press | Dim the display. Any press, centre or side, brings the normal brightness back |
| Hold the centre for 3 s | Enter setup mode, or leave it. See [Setup mode](#setup-mode) |

The display keeps updating while dimmed. Both brightness levels can be
changed on the web page. By default they are 100 % and 3 %. At 0 % the
dimmed display goes off completely.

## Reading the colours

The value and every bar of the chart are coloured by their CO₂ level:

| Colour | CO₂ | Meaning |
|---|---|---|
| <span class="co2 green"></span>Green | up to 800 ppm | Well ventilated |
| <span class="co2 yellow"></span>Yellow | 1000–1400 ppm | Ventilate soon |
| <span class="co2 orange"></span>Orange | 1700–2000 ppm | Ventilate |
| <span class="co2 red"></span>Red | from 2000 ppm, full red at 2500 | Ventilate now |

Between those bands the colour changes gradually, so it never jumps at a
single threshold.

The thresholds are based on published indoor air guidelines:

- **UBA (German Federal Environment Agency, 2008):** below 1000 ppm is
  hygienically harmless, 1000 to 2000 ppm is elevated, and above 2000 ppm is
  unacceptable.
- **EN 16798-1** (European standard) and the **Spanish RITE** (IDA
  categories). They set limits above outdoor air, and place good air at about
  800 to 950 ppm in absolute terms.

!!! note "What CO₂ tells you"
    At these levels, CO₂ is not harmful in itself. It shows how much exhaled
    air is in the room, which makes it the best simple indicator of
    ventilation. It is not a complete air quality index. It says nothing about
    particles, VOCs or radon.

## Status LED

| LED | Normal use | Setup mode |
|---|---|---|
| Steady | Connected to the network and, if one is set, to the MQTT broker | Someone has joined the monitor's own network |
| Blinking | Waiting for the network or, if one is set, for the broker | Waiting for someone to join |
| Off | Wi-Fi is disabled, or the LED is switched off | — |

The LED can be switched off on the web page, for a bedroom. It still shows
in setup mode.

## If the sensor stops responding

If the sensor gives no readings for 10 seconds, the display shows dashes
instead of values. It also shows a red warning over the chart:
**NO READINGS · CHECK THE SENSOR**. The chart keeps its history.

The warning clears on its own as soon as a reading comes back. The web page
shows the same state. See [Help](help.md#no-readings-check-the-sensor).

## Setup mode

In setup mode, the monitor creates its own open Wi-Fi network,
`CO2-Monitor-xxxxxx`, and serves the setup page at `http://192.168.4.1`. The
screen shows which network to join.

**To enter it**, hold the centre of the joystick for 3 seconds. The screen
shows **SETUP MODE · RESTARTING…** and the monitor restarts. It also starts in
setup mode by itself when it has no network saved.

**To leave it**, if a network is already saved, do any of these:

- hold the centre for 3 seconds again;
- save from the page;
- press **Restart without saving** on the page;
- wait 5 minutes without anyone joining its network.

Without a saved network, setup mode waits for as long as it takes.

## Language

The text on the display is in English by default. It can be switched to
Spanish under **Display** on the web page. The web page has its own EN/ES
selector at the top.
