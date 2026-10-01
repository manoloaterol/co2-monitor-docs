# Guía de uso

## Pantallas

Mueve el joystick **a la izquierda o a la derecha** para cambiar de pantalla.

| Pantalla | Muestra |
|---|---|
| **CO₂** | El valor de CO₂ en grande y su gráfica histórica |
| **CO₂ + ambiente** | Lo mismo, más temperatura y humedad |
| **CO₂ grande** | Solo el valor, a 85 px de alto, con un marco del color de su nivel. Se lee desde el otro lado de la habitación |

<div class="photo-todo" markdown>
**TODO:** fotos de las tres pantallas
</div>

Cada barra de la gráfica es la media de las lecturas en su tiempo. Por
defecto hay 40 barras de 20 s, que dan 13 minutos de historia. Las dos cosas
se cambian en la [página web](web-page.md#pantalla).

## Joystick

| Acción | Qué hace |
|---|---|
| ++arrow-left++ / ++arrow-right++ | Cambiar de pantalla |
| Pulsación corta | Atenuar la pantalla. Cualquier pulsación, central o lateral, devuelve el brillo normal |
| Mantener el centro 3 s | Entrar en el modo configuración o salir de él. Ver [Modo configuración](#modo-configuracion) |

Atenuada, la pantalla sigue actualizándose. Los dos niveles de brillo se
cambian en la página web. Por defecto son 100 % y 3 %. Con 0 %, la pantalla
atenuada se apaga del todo.

## Leer los colores

El valor y cada barra de la gráfica toman el color de su nivel de CO₂:

| Color | CO₂ | Significado |
|---|---|---|
| <span class="co2 green"></span>Verde | hasta 800 ppm | Bien ventilado |
| <span class="co2 yellow"></span>Amarillo | 1000–1400 ppm | Ventila pronto |
| <span class="co2 orange"></span>Naranja | 1700–2000 ppm | Ventila |
| <span class="co2 red"></span>Rojo | desde 2000 ppm, rojo pleno en 2500 | Ventila ya |

Entre esas franjas el color cambia de forma gradual, así que nunca salta de
golpe en un umbral.

Los umbrales se basan en guías publicadas de calidad del aire interior:

- **UBA (Agencia Federal de Medio Ambiente de Alemania, 2008):** por debajo
  de 1000 ppm es higiénicamente inocuo, de 1000 a 2000 ppm es elevado y por
  encima de 2000 ppm es inaceptable.
- **UNE-EN 16798-1** (norma europea) y el **RITE** (categorías IDA). Fijan
  límites sobre el aire exterior y sitúan el aire bueno en unos 800 a 950 ppm
  en valor absoluto.

!!! note "Qué te dice el CO₂"
    A estas concentraciones, el CO₂ no es dañino por sí mismo. Indica cuánto
    aire exhalado hay en la habitación, y por eso es el mejor indicador
    sencillo de la ventilación. No es un índice completo de calidad del aire:
    no dice nada de partículas, COV ni radón.

## LED de estado

| LED | Uso normal | Modo configuración |
|---|---|---|
| Fijo | Conectado a la red y, si hay uno configurado, al broker MQTT | Alguien se ha conectado a la red del propio medidor |
| Parpadeando | Esperando a la red o, si hay uno configurado, al broker | Esperando a que alguien se conecte |
| Apagado | Wi-Fi desactivada, o LED apagado desde la web | — |

El LED se puede apagar desde la página web, para un dormitorio. En modo
configuración se enciende igualmente.

## Si el sensor deja de responder

Si el sensor no da lecturas durante 10 segundos, la pantalla pone guiones en
lugar de valores. También muestra un aviso rojo sobre la gráfica:
**NO READINGS · CHECK THE SENSOR** (o **SIN LECTURAS · REVISA EL SENSOR** con
la pantalla en castellano). La gráfica conserva su historial.

El aviso desaparece solo en cuanto vuelve una lectura. La página web muestra
lo mismo. Ver [Ayuda](help.md#no-readings-check-the-sensor).

## Modo configuración

En modo configuración, el medidor crea su propia red Wi-Fi abierta,
`CO2-Monitor-xxxxxx`, y sirve la página de configuración en
`http://192.168.4.1`. La pantalla indica a qué red conectarse.

**Para entrar**, mantén pulsado el centro del joystick 3 segundos. La pantalla
muestra **SETUP MODE · RESTARTING…** y el medidor se reinicia. También arranca
solo en modo configuración cuando no tiene ninguna red guardada.

**Para salir**, si ya hay una red guardada, de cualquiera de estas formas:

- otra pulsación de 3 segundos en el centro;
- guardar desde la página;
- pulsar **Reiniciar sin guardar** en la página;
- esperar 5 minutos sin que nadie se conecte a su red.

Sin una red guardada, el modo configuración espera lo que haga falta.

## Idioma

Los textos de la pantalla salen en inglés por defecto. Se pueden poner en
castellano en **Pantalla**, en la página web. La página web tiene su propio
selector EN/ES arriba.
