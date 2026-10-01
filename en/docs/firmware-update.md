# Firmware update

## Over the network

1. Download the latest firmware `.bin` from **TODO: releases URL**.
2. Open the monitor's web page and go to **System**.
3. Under **Firmware update**, choose the `.bin` file and press **Upload and
   restart**.

The current version is shown under **System → Versions**, on the boot screen,
and in the MQTT `info` topic.

### It is safe to interrupt

- **Nothing changes until the upload is complete.** The new image is written
  next to the running one and checked before anything switches over. If the
  upload is cut off, the current firmware is untouched.
- **The new version starts on trial.** It has to prove that it works: a
  real reading from the sensor, and a radio that has not got stuck trying to
  connect. If it does not, the monitor goes back to the previous version at
  the next restart.
- **Only firmware for this device is accepted.**

After the update, the page shows the version now running. If it is still the
old one, the new version failed to start and was rolled back.

### Settings are kept

Updates keep all settings. The settings are stored as a single entry that is
written whole or not at all, so a power cut in the middle of saving leaves
the previous settings, never a mix of old and new.

## Version numbers

The firmware uses [semantic versioning](https://semver.org): `major.minor.patch`.
A version with `-dev` in it, such as `1.0.0-dev+abc1234`, is a development
build, not a release.
