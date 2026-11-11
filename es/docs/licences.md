# Licencias

## Firmware

El firmware del medidor es software libre, bajo la
[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).
El código fuente está en <https://github.com/manoloaterol/co2-monitor-firmware>. Los mismos avisos están en la propia
página web del medidor, en **Sistema → Licencias**.

Incluye el software de terceros que sigue. Sus avisos se reproducen aquí, tal
como exigen sus licencias. Los textos legales se dejan en su idioma original.

## Driver del Sensirion SCD30

Se usa para comunicarse con el sensor de CO₂. Licencia BSD de 3 cláusulas.

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

## Valores de inicialización de la pantalla

Los valores analógicos y de gamma de la pantalla salen de
[Sang.IoT.NV3030B](https://github.com/sangyuxiaowu/NV3030B).

```text
Copyright [sangsq] (sang93@qq.com)
Licensed under the Apache License, Version 2.0.
```

El firmware los reescribe como una tabla en C. El texto completo de la
licencia está en <https://www.apache.org/licenses/LICENSE-2.0>.

## Fuentes

Las fuentes de la pantalla son mapas de bits generados a partir de estas
tipografías:

- **Goldman**. Copyright 2018 The Goldman Project Authors
  (<https://github.com/magictype/goldman>). SIL Open Font License 1.1.
- **Russo One**. Copyright (c) 2011-2012, Jovanny Lemonad (jovanny.ru), with
  Reserved Font Name "Russo". SIL Open Font License 1.1.
- **6×9 de X11 misc-fixed**. Dominio público.

La SIL Open Font License está en <https://openfontlicense.org>.

## ESP-IDF

El firmware está construido sobre
[ESP-IDF](https://github.com/espressif/esp-idf) de Espressif, licencia
Apache 2.0, que incluye a su vez otros componentes de terceros con sus propias
licencias. El firmware usa además los componentes `mqtt` y `mdns` de
Espressif, con la misma licencia.

## cJSON

Se usa para leer y escribir JSON. Licencia MIT.

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
