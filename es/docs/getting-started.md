# Primeros pasos

## 1. Enchúfalo

Conecta el medidor con el cable incluido a cualquier cargador USB. Basta con
uno de 5 V y 0,5 A o más.

La pantalla de arranque muestra tres versiones: la del firmware, la del
hardware y la del firmware interno del sensor. Si la línea del sensor sale en
rojo como `ERROR`, ver [Ayuda](help.md#no-readings-check-the-sensor).

Las primeras lecturas salen en segundos y se estabilizan en unos minutos.

!!! tip "Dónde ponerlo"
    Colócalo más o menos a la altura de la cabeza, lejos de ventanas,
    radiadores y del sol directo, y donde nadie le respire encima. El aire
    exhalado lleva unos 40.000 ppm de CO₂, así que un medidor en la mesa
    justo delante de ti marca de más.

Llegado aquí ya funciona como medidor independiente. Conectarlo a una red es
opcional.

## 2. Conéctalo a tu Wi-Fi

En el primer arranque, el medidor no tiene ninguna red guardada. Arranca en
**modo configuración**: crea su propia red Wi-Fi, llamada
`CO2-Monitor-xxxxxx`. La pantalla muestra el nombre exacto.

1. Desde el móvil o el ordenador, conéctate a la red `CO2-Monitor-xxxxxx`. No
   tiene contraseña.
2. La página de configuración se abre sola. Si no, abre el navegador y entra
   en **`http://192.168.4.1`**.
3. En **Red**, elige tu Wi-Fi y escribe su contraseña.
4. Si quieres, en **MQTT**, pon tu broker. Para Home Assistant, ver
   [Integraciones](integrations.md#home-assistant).
5. Pulsa **Guardar**. El medidor se reinicia y se une a tu red.

!!! warning "Solo 2,4 GHz"
    El medidor no puede unirse a una red de 5 GHz. La mayoría de los routers
    ofrecen las dos bandas con el mismo nombre, y eso funciona. Un router que
    solo tenga 5 GHz, no.

## 3. Encuéntralo en tu red

Una vez en tu red, la misma página está en
**`http://co2-monitor-xxxxxx.local`**, donde `xxxxxx` es el mismo código que
lleva el nombre de la red de configuración. Desde ahí se cambia cualquier
ajuste, se actualiza el firmware o se calibra el sensor. Ver
[Página web y ajustes](web-page.md).

Si la dirección `.local` no abre, busca la IP del medidor en tu router y usa
esa. Ver [Ayuda](help.md#la-direccion-local-no-abre).

El LED azul se queda fijo cuando el medidor está conectado. Ver [LED de estado](user-guide.md#led-de-estado).
