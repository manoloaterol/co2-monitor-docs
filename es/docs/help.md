# Ayuda

## NO READINGS · CHECK THE SENSOR

Con la pantalla en castellano, **SIN LECTURAS · REVISA EL SENSOR**.

El sensor lleva 10 segundos sin dar lecturas. La pantalla pone guiones, y la
página web muestra lo mismo. El aviso desaparece solo en cuanto vuelve una
lectura.

Desenchufa el medidor y vuelve a enchufarlo. Si el aviso sigue, o la pantalla
de arranque muestra la línea del sensor en rojo como `ERROR`, ponte en
contacto con nosotros. Ver [Contacto](#contacto).

## Las lecturas salen altas nada más enchufarlo

El sensor necesita unos minutos para estabilizarse. Comprueba también que
nadie le esté respirando encima: el aire exhalado lleva unos 40.000 ppm de
CO₂.

## La temperatura sale alta

El sensor se calienta un poco mientras funciona. Corrígelo una vez contra un
buen termómetro. Ver [Temperatura](calibration.md#temperatura).

## El CO₂ no cuadra con otro medidor o con el exterior

En el exterior debería marcar unos 430 ppm, y dos medidores juntos pueden
diferir algo sin que ninguno esté mal. Ver [Calibración](calibration.md), que
empieza con una tabla de cada situación y qué hacer.

## La página de configuración no se abre

- Comprueba que el móvil está conectado a la red `CO2-Monitor-xxxxxx`.
  Algunos móviles abandonan solos una red sin internet. Si el tuyo pregunta,
  elige seguir conectado.
- Abre `http://192.168.4.1` en el navegador. Escribe `http://`: algunos
  navegadores prueban antes `https://`, y el medidor no lo sirve.

## No se une a mi Wi-Fi

- La red tiene que ser de **2,4 GHz**. 5 GHz no está soportado.
- Revisa la contraseña. Entra en modo configuración (mantén pulsado el centro
  del joystick 3 segundos) y escríbela de nuevo.
- Si tienes una consola serie conectada, registra el motivo de cada
  desconexión: `201`, no encuentra la red; `202`, o `15` repetido, contraseña
  incorrecta; `200`, se perdió la señal.

Si pierde la Wi-Fi, el medidor no se rinde nunca. Reintenta cada vez más
espaciado: 1 s, 2 s, 4 s… hasta un intento por minuto.

## La Wi-Fi llega débil donde quiero ponerlo

El medidor ajusta solo su potencia de emisión. Normalmente emite a 15 dBm,
que basta cerca del router y consume menos. Si la señal del router baja de
unos −70 dBm, o no consigue conectarse tras varios intentos, sube a 20 dBm, el
máximo. Vuelve a 15 dBm cuando la señal mejora por encima de unos −60 dBm. La
página web muestra arriba la potencia en uso, junto a la señal.

El medidor se conecta directamente a tu router, como cualquier otro aparato
Wi-Fi. Si aun así la señal llega débil donde quieres ponerlo, amplía tu
Wi-Fi con un repetidor o un sistema Wi-Fi mesh. El medidor se une a él como
un aparato más, y su página web, la dirección `.local` y las actualizaciones
siguen funcionando.

## La dirección `.local` no abre

El nombre `co2-monitor-xxxxxx.local` funciona con mDNS. La mayoría de los
ordenadores y móviles lo admiten, pero algunas redes, móviles Android antiguos
y algunos navegadores no. En su lugar:

- busca la IP del medidor en la lista de dispositivos de tu router y abre
  `http://<esa IP>`;
- o, si tu router registra los nombres de los dispositivos, prueba
  `http://co2-monitor-xxxxxx` con el dominio de tu router, por ejemplo
  `co2-monitor-xxxxxx.home`.

## El LED no deja de parpadear

El medidor está en tu red pero no llega al broker MQTT. Revisa la dirección
del broker, el usuario y la contraseña en la página web. El estado en vivo de
arriba dice si MQTT está conectado y a qué host.

Con `mqtts://`, el nombre del host tiene que coincidir con el certificado del
broker. Ver [TLS](mqtt.md#tls).

## No aparece en Home Assistant

- Comprueba que la integración MQTT de Home Assistant está conectada al
  **mismo broker** que el medidor.
- Comprueba que **Alta automática en Home Assistant** está marcada y que el
  **Prefijo de Discovery** coincide con el de Home Assistant. Por defecto es
  `homeassistant`.
- Mira el broker con `mosquitto_sub -t 'homeassistant/#' -v` para ver si
  llegan los mensajes de descubrimiento.

## Apagué la Wi-Fi y perdí la página

Con la Wi-Fi desactivada, el medidor no emite nada. Mantén pulsado el centro
del joystick 3 segundos para entrar en modo configuración, y vuelve a activar
la Wi-Fi desde la página.

## Contacto

**TODO:** contacto de soporte (correo, issues de GitHub).
