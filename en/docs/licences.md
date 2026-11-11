# Licences

## Firmware

The monitor's firmware is free software, under the
[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).
The source code is at <https://github.com/manoloaterol/co2-monitor-firmware>. The same notices are on the monitor's own
web page, under **System → Licences**.

It includes the third-party software below. Their notices are reproduced
here as their licences require.

## Sensirion SCD30 driver

Used to talk to the CO₂ sensor. BSD 3-Clause licence.

```text
Copyright (c) 2018, 2022, Sensirion AG
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of Sensirion AG nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
```

## Display initialisation values

The display's analogue and gamma setup values come from
[Sang.IoT.NV3030B](https://github.com/sangyuxiaowu/NV3030B).

```text
Copyright [sangsq] (sang93@qq.com)
Licensed under the Apache License, Version 2.0.
```

The firmware rewrites them as a C table. The full licence text is at
<https://www.apache.org/licenses/LICENSE-2.0>.

## Fonts

The fonts on the display are bitmaps generated from these typefaces:

- **Goldman**. Copyright 2018 The Goldman Project Authors
  (<https://github.com/magictype/goldman>). SIL Open Font License 1.1.
- **Russo One**. Copyright (c) 2011-2012, Jovanny Lemonad (jovanny.ru), with
  Reserved Font Name "Russo". SIL Open Font License 1.1.
- **6×9 from X11 misc-fixed**. Public domain.

The SIL Open Font License is at <https://openfontlicense.org>.

## ESP-IDF

The firmware is built on Espressif's
[ESP-IDF](https://github.com/espressif/esp-idf), Apache License 2.0, which
includes further third-party components under their own licences. The
firmware also uses Espressif's `mqtt` and `mdns` components, under the same
licence.

## cJSON

Used to read and write JSON. MIT licence.

```text
Copyright (c) 2009-2017 Dave Gamble and cJSON contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
