# Página web y ajustes

El medidor sirve su propia página de ajustes:

- en modo configuración, en `http://192.168.4.1`. Ver [Modo configuración](user-guide.md#modo-configuracion);
- en tu red, en `http://co2-monitor-xxxxxx.local` o en su dirección IP.

La página está en inglés y en castellano. Sale en el idioma de la pantalla, y
el selector EN/ES de arriba recuerda otra elección en ese navegador.

## Estado en vivo

Arriba, la página muestra en vivo:

- la lectura actual;
- el estado del sensor;
- la señal Wi-Fi y la potencia con la que emite el medidor (ver
  [La Wi-Fi llega débil](help.md#la-wi-fi-llega-debil-donde-quiero-ponerlo));
- si MQTT está conectado;
- el tiempo encendido.

## Ajustes

Los ajustes van en secciones plegables. **El brillo, el idioma de la pantalla
y el LED** se aplican al guardar, sin reiniciar. Cualquier otro cambio
reinicia el medidor.

### Red

| Ajuste | |
|---|---|
| Wi-Fi activada | Con la Wi-Fi apagada, el medidor deja de emitir del todo: ni red, ni red de configuración, ni página. Para volver, mantén pulsado el centro del joystick 3 segundos |
| Wi-Fi | La red a la que unirse. **Volver a buscar** actualiza la lista |
| Contraseña | Si se deja en blanco, se conserva la guardada |

### MQTT

| Ajuste | |
|---|---|
| Broker | `mqtt://host:1883` sin cifrar, o `mqtts://host:8883` con TLS. Vacío no publica nada |
| Usuario, Contraseña | Las credenciales del broker. Al cambiar el host del broker se borra la contraseña guardada, salvo que escribas otra |
| Borrar la contraseña guardada | Para un broker sin contraseña, después de usar uno que la tenía |
| Alta automática en Home Assistant | Activada por defecto. Ver [Home Assistant](integrations.md#home-assistant) |
| Prefijo de Discovery | `homeassistant` por defecto. Cámbialo solo si Home Assistant usa otro |

En **Avanzado: topics y TLS**:

| Ajuste | |
|---|---|
| Topic base | De donde cuelgan todos los topics. Vacío usa `co2monitor/xxxxxx`. Ver [Topics](mqtt.md#topics) |
| Retener las lecturas | Desactivado por defecto. Ver [Lecturas retenidas](mqtt.md#lecturas-retenidas) |
| Certificado de la CA | Solo para un broker con CA propia. Ver [TLS](mqtt.md#tls) |
| Certificado de cliente, clave privada | Para brokers que identifican al aparato por certificado. Ver [TLS](mqtt.md#certificados-de-cliente) |

### Pantalla

| Ajuste | Por defecto | |
|---|---|---|
| Brillo | 100 % | Es la mayor parte del consumo |
| Brillo atenuado | 3 % | El que da una pulsación corta. Con 0 la pantalla se apaga |
| Idioma de la pantalla | Inglés | Inglés o castellano |
| LED de estado | Encendido | Ver [LED de estado](user-guide.md#led-de-estado) |
| Barras de la gráfica | 40 | 20, 25, 40, 50 o 100 |
| Cada barra | 20 s | De 20 s a 5 min. También es cada cuánto se publican las lecturas por MQTT |

Cambiar la gráfica reinicia el medidor y vacía su historial.

### Sensor

| Ajuste | |
|---|---|
| Altitud (m) | Las lecturas de CO₂ dependen de la presión del aire. Por debajo de unos 200 m la corrección es menor que el error del propio sensor. Ver [Altitud](calibration.md#altitud) |
| Calibrar temperatura | Ver [Temperatura](calibration.md#temperatura) |

### Calibración de CO₂

Recalibra el sensor contra aire limpio y deshace la última calibración. Ver
[Calibración de CO₂](calibration.md#calibracion-de-co2).

### Sistema

| Ajuste | |
|---|---|
| Nombre | El que muestra Home Assistant. Vacío usa el nombre por defecto con el código del aparato |
| Versiones | Firmware, hardware y sensor SCD30 |
| Actualizar firmware | Ver [Actualizar el firmware](firmware-update.md) |
| Reiniciar sin guardar | Reinicia el medidor. En modo configuración, además, sale de él |

## Seguridad

La página no tiene contraseña: cualquiera en tu red puede abrirla, igual que
puede ver el aparato. Lo que sí impide es que una web de internet la use a
través del navegador de alguien de tu casa:

- Toda petición que cambia algo (guardar, reiniciar, subir firmware) debe
  llevar la cabecera `X-CO2-Monitor`. Una web ajena no puede añadirla sin
  preguntar antes al aparato, y el aparato nunca lo permite.
- El medidor solo atiende peticiones dirigidas a una IP o a su propio nombre.
  Eso frena el *DNS rebinding*.
- Al cambiar el host del broker se borra la contraseña MQTT guardada, salvo
  que se escriba otra. Nadie puede apuntar el medidor a su propio broker para
  quedarse con tu contraseña.
- La actualización solo acepta firmware de este aparato.

Para tus propios scripts, añade la cabecera:

```sh
curl -H 'X-CO2-Monitor: 1' ...
```
