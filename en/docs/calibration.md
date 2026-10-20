# Calibration

The sensor comes calibrated from the factory, and most monitors never need
anything else. This page covers the three corrections the web page offers:
altitude, CO₂ and temperature.

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

## CO₂ calibration

The SCD30's tolerance is ±(30 ppm + 3 %). If it drifts over time, the
**CO₂ calibration** section tells the sensor how much CO₂ is really around it,
and the sensor adjusts its curve. This is called *forced recalibration*
(FRC). The usual reference is outdoor air.

If the monitor already reads between about 400 and 470 ppm outdoors, it is
within its tolerance and calibrating adds little.

### How to do it

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
   more near a city. If you have a reference meter right next to it, use its
   value instead.
6. Press **Calibrate now** and confirm.

### What the monitor checks

- **The average, not the last reading.** It calibrates against the average of
  the last 2 minutes.
- **A correction limit.** A correction of more than 150 ppm needs a second,
  explicit confirmation. It is far more likely that the air is not a good
  reference than that the sensor has drifted that much. See
  [Wide calibration](#wide-calibration).
- **The reference** must be between 400 and 2000 ppm.

### Wide calibration

Now and then a sensor comes out of the box far off: a few hundred ppm low or
high, while it reacts normally to breath and follows another monitor's curve.
For that case the page allows a **wide calibration**. Enter a reference more
than 150 ppm away from the reading and, instead of refusing it, the page asks
you to confirm.

- **Only with a reference you trust:** outdoor air, or a calibrated monitor
  right next to it. With another monitor, use the average of its last 2
  minutes (`cal.avg` in its `/api/status`), not the last reading. It copies
  that monitor's error, but both will agree.
- The readings may vary by up to 150 ppm over the 2 minutes, instead of 40.
- **Undo needs the right air.** Undoing applies the opposite correction to
  the current reading, and the sensor accepts no reference below 400 ppm. So
  the reading minus the correction must stay at 400 or more. After a
  correction of +370 ppm, for instance, that means more than about 770 ppm,
  as indoors with people around, but not outdoors. The page disables the
  button and says why when the air does not allow it. Calibrating again, with
  a new reference, is always possible.

### It lasts

The correction is stored in the sensor itself and survives power cuts.

### Undo

The SCD30 has no way back to its factory calibration. Instead, the monitor
remembers what the sensor read and what it was set to in the last
calibration. **Undo last calibration** applies the opposite correction.

Unlike calibrating, undo works in any steady air, indoors too, because the
reference comes from the current reading.

### Automatic self-calibration

The SCD30 also has an automatic self-calibration (ASC). The monitor leaves
it as it is. If the sensor has it switched on, the page warns you, because
over the following days it would override a manual calibration.

### From a script

```sh
curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"reference": 430}' http://co2-monitor-xxxxxx.local/api/frc

curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"reference": 430, "wide": true}' http://co2-monitor-xxxxxx.local/api/frc

curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"undo": true}' http://co2-monitor-xxxxxx.local/api/frc
```

## Temperature

The SCD30 warms itself slightly while it works, and the electronics around
it add some heat. So the monitor reads a little higher than the room. The
**Calibrate temperature** field corrects this:

1. Leave the monitor running for at least 10 minutes, with the case closed,
   next to a thermometer you trust.
2. Enter **what the monitor shows minus what the thermometer shows**. If the
   monitor says 27.5 and the thermometer 25.0, enter **2.5**.
3. Save.

The value is **added** to the current correction, not written in its place,
so leave the field empty unless you are calibrating. A negative value undoes
too large a correction. The page shows the correction the sensor holds now.
The correction is stored in the sensor and survives power cuts.
