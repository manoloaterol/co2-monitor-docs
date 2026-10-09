# Otros sistemas domóticos

Además de Home Assistant, varios sistemas domóticos entienden los mensajes de
autodescubrimiento del medidor y lo dan de alta solos. Solo necesitan llegar al
mismo broker MQTT.

| Sistema | Versión probada | Encuentra el medidor solo | Notas |
|---|---|---|---|
| Home Assistant | 2026.9 | Sí | Ver [MQTT y Home Assistant](mqtt.md#home-assistant) |
| openHAB | 5.2 | Sí, en la bandeja de entrada | Necesita dos complementos; hay que poner las unidades de los items |
| Domoticz | 2026.4 | Sí | Temperatura y humedad quedan en un solo dispositivo |

En todos los casos, deja marcada **Alta automática en Home Assistant** en la
página web del medidor, aunque no uses Home Assistant: estos sistemas leen los
mismos mensajes. Si cambiaste el **Prefijo de descubrimiento**, usa el mismo
en ellos.

Cualquier otro cliente MQTT puede leer directamente los topics planos. Están
descritos en [MQTT y Home Assistant](mqtt.md#topics).

## openHAB

Los pasos son para la interfaz principal de openHAB 5.

1. En **Settings → Add-on Store → Bindings**, instala **MQTT Binding** y
   **Home Assistant Binding**. En openHAB 5 son dos complementos separados, y
   sin el segundo el medidor no aparece.
2. En **Settings → Things**, pulsa **+**, elige **MQTT Binding** y después
   **MQTT Broker**. Escribe la dirección del broker, el puerto, el usuario y la
   contraseña, y guarda. El Thing del broker debe quedar en **ONLINE**.
3. Abre la bandeja de entrada (**Inbox**). El medidor aparece con el nombre
   que tiene en su página web, como un solo dispositivo con los sensores de
   CO₂, temperatura y humedad. Apruébalo.
4. Abre el Thing nuevo, ve a **Channels** y enlaza un item a cada canal, o usa
   **Add Equipment to Model** para hacerlo de una vez.

!!! warning "Unidades del CO₂ y la humedad"
    openHAB guarda el CO₂ y la humedad como números sin dimensión. Si el item no
    tiene unidad, salen como una fracción: `0.0026` en vez de 2600 ppm, `0.48`
    en vez de 48 %. Al crear los items, pon la unidad `ppm` al CO₂ y `%` a la
    humedad. La temperatura no necesita nada.

El sensor de CO₂ tiene además un canal avanzado, **JSON Attributes**, con los
segundos por barra de la gráfica. Puedes ignorarlo.

Cuando el medidor se desconecta, el Thing pasa a **OFFLINE**, y vuelve a
**ONLINE** cuando regresa.

??? example "La misma configuración con ficheros de texto"
    Con `binding = mqtt,homeassistant` en `services/addons.cfg` y un broker en
    `things/mqtt.things`:

    ```java
    Bridge mqtt:broker:mosquitto "Mosquitto" [ host="192.168.1.10", port=1883, secure=false, username="usuario", password="contraseña" ]
    ```

    el medidor aparece igualmente en la bandeja de entrada. Una vez aprobado,
    los items pueden ir en `items/co2.items`. Sustituye `co2monitor_5Fxxxxxx` y
    `co2monitor_xxxxxx` por el código de tu medidor, tal como sale en el Thing:

    ```java
    Number:Dimensionless CO2         "CO₂ [%d ppm]"           { channel="homeassistant:device:mosquitto:co2monitor_5Fxxxxxx:co2monitor_xxxxxx_co2#sensor", unit="ppm" }
    Number:Temperature   Temperatura "Temperatura [%.1f °C]"  { channel="homeassistant:device:mosquitto:co2monitor_5Fxxxxxx:co2monitor_xxxxxx_temperature" }
    Number:Dimensionless Humedad     "Humedad [%.0f %%]"      { channel="homeassistant:device:mosquitto:co2monitor_5Fxxxxxx:co2monitor_xxxxxx_humidity", unit="%" }
    ```

## Domoticz

1. En **Configuración → Hardware**, añade un hardware del tipo **MQTT Auto
   Discovery Client Gateway with LAN interface**.
2. Escribe la dirección y el puerto del broker, y el usuario y la contraseña.
   Deja **Auto Discovery Prefix** en `homeassistant`.
3. Pulsa **Añadir**.

Aparecen al momento dos dispositivos, ya en uso:

- **CO₂**, como dispositivo *Air Quality* en ppm, en **Utilidades**. Domoticz
  le añade su propia etiqueta de calidad, de *Excellent* a *Bad*.
- **Temperatura y humedad**, juntas en un único dispositivo *Temp + Humidity*
  en **Temperatura**, con la etiqueta de confort que Domoticz da a la humedad
  (*Normal*, *Comfortable*, *Dry* o *Wet*).

Domoticz no usa el estado `offline` del medidor. Cuando el medidor se
desconecta, los dispositivos conservan el último valor hasta que vence el
**tiempo de espera de sensores** (*Sensor Timeout*) de los ajustes de Domoticz,
60 minutos por defecto, y entonces lo marcan como sin datos.
