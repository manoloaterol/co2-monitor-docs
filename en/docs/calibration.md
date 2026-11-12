# Calibration

The sensor comes calibrated from the factory, and most monitors never need
anything else. This page covers the three corrections the web page offers:
altitude, CO₂ and temperature. Each one ends with the most common problems
and what to do about each.

| If this happens | Go to |
|---|---|
| You live higher than about 200 m | [Altitude](#altitude) |
| Outdoors it reads well above or below about 430 ppm | [Does it need calibrating?](#does-it-need-calibrating) |
| Two monitors side by side disagree | [Two monitors disagree](#two-monitors-disagree) |
| A new sensor reads hundreds of ppm low or high | [Wide calibration](#wide-calibration) |
| You calibrated wrongly | [Undo](#undo) |
| The **Calibrate now** button stays disabled | [The button stays disabled](#the-calibrate-now-button-stays-disabled) |
| The temperature reads high | [Temperature](#temperature) |
| You corrected the temperature and nothing seems to change | [The correction seems to do nothing](#the-correction-seems-to-do-nothing) |

## Altitude

CO₂ readings depend on air pressure, and air pressure depends on altitude.
Under **Sensor**, set the altitude of the place where the monitor is, in
metres, and save. The monitor restarts and passes it to the sensor.

Below about 200 m the correction is smaller than the sensor's own error, so it
can be left at 0. Higher up it is worth setting.

!!! warning "Set the altitude before calibrating CO₂"
    The pressure correction is part of every reading. A CO₂ calibration made
    with one altitude does not match another. The monitor refuses to
    calibrate while the saved altitude is not the one the sensor is using.

**If you take the monitor to another altitude**, when moving house for
instance, change the altitude and save. If it was calibrated, check outdoors
afterwards that it still reads about 430 ppm, and calibrate again if not.

## CO₂ calibration

The SCD30's tolerance is ±(30 ppm + 3 %). If it drifts, the
**CO₂ calibration** section of the web page tells the sensor how much CO₂ is
really around it, and the sensor corrects every reading by that amount. This
is called *forced recalibration* (FRC).

There are two good references:

- **Outdoor air**, about 430 ppm (2026). The usual one, and the most reliable.
  It rises by about 2–2.5 ppm a year; NOAA publishes the current value from
  the Mauna Loa observatory, in Hawaii:
  [Trends in atmospheric CO₂](https://gml.noaa.gov/ccgg/trends/). That is
  clean air, far from any city: near home there is usually a little more.
- **Another calibrated monitor**, right next to it. It works indoors, and
  leaves both monitors in agreement.

<figure markdown="span">
  ![The CO₂ calibration section open, with the steps, the reference field and the Calibrate now button](img/web-calibration-en.png){ .page }
  <figcaption>The CO₂ calibration section. Taken indoors, so the page warns that the correction would be too large.</figcaption>
</figure>

### Does it need calibrating?

Take the monitor outdoors as explained in [With outdoor air](#with-outdoor-air)
and see what it reads once steady:

| Outdoors it reads | What it means | What to do |
|---|---|---|
| Between about 400 and 470 ppm | Within its tolerance | Nothing: calibrating adds little |
| Between about 300 and 400, or 470 and 600 | Off | [Calibrate with outdoor air](#with-outdoor-air) |
| Below about 300, or above 600 | Far off, or the air is not good | Measure again on another day and at another time. If it gives the same, see [Wide calibration](#wide-calibration) |

A quick way to check that the sensor is healthy: breathe on it from close up.
It should climb to several thousand ppm within seconds and then come down
slowly. If it reacts like that, any offset can be calibrated away.

!!! tip "Once a year"
    The SCD30 drifts very little over time. Checking it outdoors once a year
    is enough.

### With outdoor air

1. **Set the altitude first**, under **Sensor**, and save. Calibrate after the
   restart that follows, never before.
2. Take the monitor **outdoors**, or to a wide-open window with a draught. Keep
   it in the shade and away from traffic, chimneys and boilers. Midday or
   afternoon with some wind is best. Avoid the night and dawn, when CO₂
   builds up near the ground.
3. Keep a metre or two away and **do not breathe towards it**. Follow the
   reading from your phone.
4. **Wait until the reading settles.** The **Calibrate now** button unlocks
   after 2 minutes of unbroken readings that vary by less than 40 ppm. Waiting
   5 to 10 minutes is better.
5. Enter the reference. Outdoor air is about **430 ppm** (2026), somewhat
   more near a city. For other years, take the latest value from
   [NOAA](https://gml.noaa.gov/ccgg/trends/).
6. Press **Calibrate now** and confirm.

### With another monitor as reference

Useful when you cannot take the monitor outside, or when you want several
monitors to agree. The reference monitor has to be well calibrated: this
method copies its error.

1. Put both monitors **together**, with their air inlets a few centimetres
   apart, in a closed room with nobody breathing nearby. Ideally the CO₂ is
   around 600–1000 ppm, where the monitor is used day to day.
2. Wait 10–15 minutes without touching anything.
3. On the reference monitor's page, in **CO₂ calibration**, read the
   **average of the last 2 minutes**. Do not use the current reading: the
   average is what the other monitor compares against.
4. On the page of the monitor you want to correct, enter that value as the
   reference, press **Calibrate now** and confirm.

A meter that works out an "eCO₂" from other gases is no reference: it does
not measure CO₂.

### Wide calibration

Now and then a sensor comes out of the box far off: it reads hundreds of ppm
low or high, while it reacts normally to breath and follows the same curve as
another monitor. For instance, 50 ppm outdoors, or 400 ppm less than the
monitor next to it in every situation.

At first the monitor does not allow a correction of more than 150 ppm, because
the usual cause is air that is not a good reference. Enter a reference
further away and the page does not refuse it: it warns you and, when you
calibrate, asks you to confirm a **wide calibration**.

- **Only with a reference you trust**: outdoor air in good conditions, or a
  calibrated monitor right next to it.
- The readings may vary by up to 150 ppm over the 2 minutes, instead of 40.
- Undoing it later needs air with enough CO₂. See [Undo](#undo).

### What the monitor checks

- **The altitude** saved has to be the one the sensor is using.
- **The average, not the last reading.** It calibrates against the average of
  the last 2 minutes, which have to be unbroken and steady.
- **A correction limit** of 150 ppm, except for a wide calibration.
- **The reference** has to be between 400 and 2000 ppm. That is the range the
  sensor accepts.

### It lasts

The correction is stored in the sensor itself and survives power cuts and
firmware updates.

### Undo

The SCD30 has no way back to its factory calibration. Instead, the monitor
remembers what the sensor read and what it was set to in the last
calibration. **Undo last calibration** applies the opposite correction to
the current reading.

That is why it works in any steady air, indoors too: there is no need to know
how much CO₂ there is. There is just one condition. The sensor accepts no
reference below 400 ppm, so **the reading minus the correction must stay at
400 or more**.

| Last correction | Undo works when the monitor reads |
|---|---|
| +50 ppm | 450 ppm or more: nearly always |
| +150 ppm | 550 ppm or more |
| +370 ppm | 770 ppm or more: indoors, with people around |

When the air does not allow it, the page disables the button and says why.
Wait for the room's CO₂ to rise, or simply calibrate again against a good
reference: that is always possible.

Only the **last** calibration can be undone, and only if it was made from the
monitor's page or API.

### Automatic self-calibration

The monitor does not use automatic self-calibration. It is a function of the
SCD30 sensor itself (ASC), which assumes the sensor sees fresh air regularly,
something that rarely holds indoors. The monitor never switches it on or off:
it only checks it at start-up. If a sensor came with it switched on, the
**CO₂ calibration** section shows a warning, because over the following days
it would override a manual calibration.

### CO₂ problems

#### The Calibrate now button stays disabled

The **CO₂ calibration** section says what is missing, under the button:

| The page says | What to do |
|---|---|
| The altitude in the form is not the one in the sensor | Save, wait for the restart and go back to the page |
| No readings from the sensor | See [Help](help.md#no-readings-check-the-sensor) |
| Measuring for… | Wait: it needs 2 minutes of unbroken readings. A restart starts the count again |
| The readings vary by… ppm | The air is not still. See the next section |
| The reference must be between 400 and 2000 ppm | Fix the number |

#### The readings do not settle

- **Do not breathe near it**, and keep people away: exhaled air carries about
  40,000 ppm.
- **Outdoors**, gusts of wind, direct sun, traffic or a nearby chimney move
  the reading. Find a sheltered spot in the shade, or protect it with a box
  with holes.
- **Just after power-up**, the sensor needs a few minutes to settle.
- **Indoors**, close doors and windows and let the room settle. An opening
  window or someone walking in changes the CO₂ within seconds.

#### Two monitors disagree

Two sensors within tolerance can differ quite a lot, because each has its own
margin:

| Concentration | Each one's margin | Normal difference between two |
|---|---|---|
| 450 ppm | ±44 ppm | up to about 90 ppm |
| 1000 ppm | ±60 ppm | up to about 120 ppm |
| 2000 ppm | ±90 ppm | up to about 180 ppm |

- **Differences within those margins** are normal. If you want them to agree,
  calibrate one [against the other](#with-another-monitor-as-reference).
- **Larger differences, but both follow the same curve:** one of them is off.
  Take both outdoors to find out which, and calibrate that one.
- **The difference grows with the concentration:** that is partly normal.
  A calibration corrects exactly the point where it is made, so calibrate
  near the values that matter most to you.
- **One reacts differently or much more slowly:** that is not a calibration
  problem. Check that both are seeing the same air.

#### I calibrated against the wrong reference

Someone breathed nearby, for instance, or you typed the wrong number. Use
[Undo](#undo), or calibrate again against a good reference: the new
calibration replaces the old one.

#### Calibration errors

| Error | What it means |
|---|---|
| The sensor is not giving readings | No recent readings. Wait, or restart |
| The altitude saved is not in the sensor yet | Restart first |
| The readings are not steady yet | The readings changed just before calibrating. Wait |
| There is no calibration to undo | This monitor has no calibration on record |
| The reference must be between 400 and 2000 ppm | The sensor requires it, when undoing too |
| The correction is too large | Through the API only, without `"wide": true` |
| The sensor did not answer in time | It may have been applied. **Check the reading before retrying**, or you will correct twice |
| Another calibration is under way | Wait a few seconds |
| The sensor refused it | Restart the monitor and try again |

### From a script

```sh
# Calibrate
curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"reference": 430}' http://co2-monitor-xxxxxx.local/api/frc

# Wide calibration
curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"reference": 430, "wide": true}' http://co2-monitor-xxxxxx.local/api/frc

# Undo the last one
curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"undo": true}' http://co2-monitor-xxxxxx.local/api/frc
```

`GET /api/status` returns under `cal` whether the readings are ready
(`ready`, and `ready_wide` for a wide calibration), their average (`avg`) and
how much they vary (`spread`).

## Temperature

The SCD30 warms itself slightly while it works, and the electronics around
it add some heat. So the monitor reads a little higher than the room. The
**Calibrate temperature** field, under **Sensor**, corrects this.

- The correction is **subtracted** from every reading. The sensor cannot add:
  it only corrects a monitor that reads high.
- The **humidity** is worked out again from the corrected temperature. It has
  no setting of its own: correct the temperature and the humidity follows.
- It does not affect CO₂.
- It is stored in the sensor itself and survives power cuts.

### How to do it

The correction depends on how much the monitor warms up, and that changes with
the case, the screen brightness and the spot. Measure it **the way you are
going to use it**.

1. Put the monitor in its place, with the case closed and the brightness you
   will use, next to a thermometer you trust. Keep both away from sunlight,
   radiators and other appliances that give off heat.
2. Leave it running for **20–30 minutes**.
3. Enter **what the monitor shows minus what the thermometer shows**. If the
   monitor says 27.5 and the thermometer 25.0, enter **2.5**.
4. Save. The monitor restarts.
5. **Wait 20–30 minutes** before comparing again. See the next section.

The value is **added** to the current correction, not written in its place.
So what you measure afterwards is always what is left to correct, with no
sums to do. Leave the field empty unless you are calibrating.

### What to expect after saving

Two things keep the change from showing straight away:

- **The restart.** Saving restarts the monitor, and for a few minutes it warms
  up again. The temperature climbs slowly until it settles.
- **The sensor itself.** The SCD30 does not apply the correction all at once:
  the reading moves towards the new value over about 10–15 minutes.

Do not chain corrections while watching the reading: you would end up
correcting too much.

### Temperature problems

#### The correction seems to do nothing

Look at the sentence under **Sensor**: *The sensor now holds a correction of
X °C*. If it shows the new value, the correction is in place. Wait 20–30
minutes, as in [What to expect after saving](#what-to-expect-after-saving).

#### Now it reads lower than the thermometer

The correction went too far. Enter the difference with its sign, which will be
negative: if the monitor says 23.0 and the thermometer 23.5, enter **-0.5**.

#### It reads lower than the thermometer with no correction at all

The sensor cannot add degrees. Check the thermometer, and that both are in the
same spot. The SCD30's tolerance is about ±0.4 °C.

#### I changed the case, the brightness or the spot

The correction no longer holds: measure it again. To start from zero, enter
the current correction as a negative (if it holds 3.7 °C, enter **-3.7**) and
save. Then follow [How to do it](#how-to-do-it).

#### It climbs for a while after power-up

That is normal. The monitor warms up over the first 10–20 minutes, and the
reading rises with it. The correction is meant for once it has settled.

#### The humidity does not match

Correct the temperature first: the humidity depends on it. If it still does
not match after that, bear in mind that the SCD30's tolerance is ±3 % relative
humidity, and that many household hygrometers are much further off.

#### Setting an exact value

The page only adds differences. To write the total correction, send it
through the API in hundredths of a degree. For 2.90 °C, for instance:

```sh
curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"temp_offset_c100": 290}' http://co2-monitor-xxxxxx.local/api/config

curl -X POST -H 'X-CO2-Monitor: 1' http://co2-monitor-xxxxxx.local/api/reboot
```

The correction reaches the sensor at start-up. The page restarts the monitor
on its own when saving; through the API you have to ask, as in the second
line.
