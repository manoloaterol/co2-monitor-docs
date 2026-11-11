# Medidor de CO₂

Un medidor de CO₂ para interiores con tecnología NDIR, pantalla IPS en color y
página web propia, que se abre desde tu red o, sin red, desde su propio punto
de acceso. Publica por MQTT y se integra automáticamente con sistemas como
Home Assistant, openHAB o Domoticz. También funciona como medidor
independiente, sin necesidad de conectarse a ninguna red.

<div class="photo-todo" markdown>
**TODO:** foto del producto
</div>

[:material-cart: Comprar en Tindie](https://www.tindie.com/TODO){ .md-button .md-button--primary }
[:material-cart: Comprar en Lectronz](https://lectronz.com/TODO){ .md-button }

## Qué hace

- **Mide CO₂, temperatura y humedad** con un Sensirion SCD30. Es un sensor
  de CO₂ NDIR de verdad, no una estimación "eCO₂" calculada a partir de otros
  gases.
- **Los muestra en una pantalla IPS en color de 1,83"**, con una gráfica
  histórica. Los colores siguen guías publicadas de calidad del aire interior.
  Ver [Leer los colores](user-guide.md#leer-los-colores).
- **Publica por MQTT** estándar, con o sin TLS. Ver [MQTT y compatibilidad](mqtt.md).
- **Aparece solo en Home Assistant, openHAB y Domoticz** mediante el
  descubrimiento MQTT, sin escribir YAML. Ver [Integraciones](integrations.md).
- **Se configura desde su propia página web.** Sin nube, sin cuenta y sin app.
  Ver [Página web y ajustes](web-page.md).
- **Se actualiza por red**, y si una actualización falla vuelve solo al
  firmware anterior. Ver [Actualizar el firmware](firmware-update.md).

¿Es la primera vez? Empieza por [Primeros pasos](getting-started.md).

## Especificaciones

| | |
|---|---|
| Microcontrolador | ESP32-S2, 4 MB de flash, 2 MB de PSRAM |
| Sensor de CO₂ | Sensirion SCD30, NDIR |
| Rango de CO₂ | 400–10.000 ppm |
| Exactitud de CO₂ | ±(30 ppm + 3 % de la lectura) |
| Mide además | Temperatura y humedad relativa |
| Pantalla | IPS de 1,83", 240×280, color |
| Controles | Joystick de 3 vías |
| Indicador | LED de estado azul |
| Inalámbrico | Wi-Fi 802.11 b/g/n, **solo 2,4 GHz** |
| Protocolos | MQTT 3.1.1 (TLS 1.2 opcional), HTTP, mDNS |
| Alimentación | 5 V por micro-USB (USB Micro-B) |
| Consumo | Unos 77 mA con brillo máximo (≈0,4 W), unos 43 mA con la pantalla apagada |
| Dimensiones / peso | 56 × 56 × 16,5 mm, 35 g |
| Caja | Impresa en 3D, PLA mate de color metálico |
| En la caja | Medidor de CO₂, cable USB. Sin cargador: vale cualquier cargador USB de 5 V de móvil |

![Plano de dimensiones: 56 × 56 × 16,5 mm, vistas lateral, frontal e isométrica](assets/dimensions.svg){ .drawing }
