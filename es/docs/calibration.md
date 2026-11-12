# Calibración

El sensor sale calibrado de fábrica, y la mayoría de los medidores no
necesitan nada más. Esta página trata las tres correcciones que ofrece la
página web: altitud, CO₂ y temperatura. Cada una termina con los problemas
más habituales y qué hacer en cada caso.

| Si te pasa esto | Ve a |
|---|---|
| Vives a más de unos 200 m de altitud | [Altitud](#altitud) |
| En el exterior marca bastante por encima o por debajo de unos 430 ppm | [¿Hace falta calibrar?](#hace-falta-calibrar) |
| Dos medidores juntos no marcan lo mismo | [Dos medidores no coinciden](#dos-medidores-no-coinciden) |
| Un sensor nuevo marca cientos de ppm de menos o de más | [Calibración amplia](#calibracion-amplia) |
| Calibraste mal | [Deshacer](#deshacer) |
| El botón **Calibrar ahora** no se activa | [El botón no se activa](#el-boton-calibrar-ahora-no-se-activa) |
| La temperatura sale alta | [Temperatura](#temperatura) |
| Corregiste la temperatura y parece que no cambia | [Parece que la corrección no hace nada](#parece-que-la-correccion-no-hace-nada) |

## Altitud

Las lecturas de CO₂ dependen de la presión del aire, y la presión depende de
la altitud. En **Sensor**, pon la altitud del lugar donde está el medidor, en
metros, y guarda. El medidor se reinicia y se la pasa al sensor.

Por debajo de unos 200 m la corrección es menor que el error del propio
sensor, así que puede dejarse en 0. Más arriba merece la pena ponerla.

!!! warning "Pon la altitud antes de calibrar el CO₂"
    La compensación de presión forma parte de cada lectura. Una calibración
    de CO₂ hecha con una altitud deja de cuadrar con otra. El medidor se niega
    a calibrar mientras la altitud guardada no sea la que usa el sensor.

**Si te llevas el medidor a otra altitud**, por ejemplo al mudarte, cambia la
altitud y guarda. Si lo habías calibrado, comprueba después en el exterior
que sigue marcando unos 430 ppm, y vuelve a calibrar si no.

## Calibración de CO₂

La tolerancia del SCD30 es de ±(30 ppm + 3 %). Si se desvía, la sección
**Calibración de CO₂** de la página web le dice al sensor cuánto CO₂ hay de
verdad a su alrededor, y el sensor corrige todas sus lecturas en esa
cantidad. Se llama *recalibración forzada* (FRC).

Hay dos referencias válidas:

- **El aire exterior**, unos 430 ppm (2026). Es la habitual y la más fiable.
  Sube unos 2–2,5 ppm cada año; el valor del año en curso lo publica la NOAA
  con las medidas del observatorio de Mauna Loa, en Hawái:
  [Trends in atmospheric CO₂](https://gml.noaa.gov/ccgg/trends/). Es aire
  limpio, lejos de cualquier ciudad: cerca de casa suele haber algo más.
- **Otro medidor calibrado**, justo al lado. Sirve en interior, y deja los dos
  medidores de acuerdo.

<figure markdown="span">
  ![La sección Calibración de CO₂ abierta, con los pasos, el campo de referencia y el botón Calibrar ahora](img/web-calibration-es.png){ .page }
  <figcaption>La sección Calibración de CO₂. Hecha en interior, así que la página avisa de que la corrección sería demasiado grande.</figcaption>
</figure>

### ¿Hace falta calibrar?

Saca el medidor al exterior como se explica en
[Con aire exterior](#con-aire-exterior) y mira qué marca una vez estable:

| En el exterior marca | Qué significa | Qué hacer |
|---|---|---|
| Entre unos 400 y 470 ppm | Está dentro de su tolerancia | Nada: calibrar aporta poco |
| Entre unos 300 y 400, o entre 470 y 600 | Desviado | [Calibrar con aire exterior](#con-aire-exterior) |
| Menos de unos 300, o más de 600 | Muy desviado, o el aire no es bueno | Repite la medida otro día y a otra hora. Si da lo mismo, mira [Calibración amplia](#calibracion-amplia) |

Una forma rápida de comprobar que el sensor está sano: échale el aliento de
cerca. Tiene que subir en segundos a varios miles de ppm y luego bajar poco a
poco. Si reacciona así, cualquier desviación se corrige calibrando.

!!! tip "Una vez al año"
    El SCD30 se desvía muy poco con el tiempo. Comprobarlo en el exterior una
    vez al año es suficiente.

### Con aire exterior

1. **Primero, la altitud**, en **Sensor**, y guarda. Calibra después del
   reinicio que sigue, nunca antes.
2. Lleva el medidor **al exterior**, o a una ventana abierta de par en par con
   corriente. A la sombra y lejos de tráfico, chimeneas y calderas. Lo mejor,
   a mediodía o por la tarde con algo de viento. Evita la noche y el
   amanecer, cuando el CO₂ se acumula cerca del suelo.
3. Apártate uno o dos metros y **no le respires encima**. Sigue la lectura
   desde el móvil.
4. **Espera a que la lectura se estabilice.** El botón **Calibrar ahora** se
   activa tras 2 minutos de lecturas sin cortes que varíen menos de 40 ppm.
   Esperar de 5 a 10 minutos es mejor.
5. Pon la referencia. El aire exterior tiene unos **430 ppm** (2026), algo
   más cerca de una ciudad. Para otros años, toma el último valor de
   [la NOAA](https://gml.noaa.gov/ccgg/trends/).
6. Pulsa **Calibrar ahora** y confirma.

### Con otro medidor de referencia

Útil cuando no puedes sacar el medidor, o cuando quieres que varios medidores
marquen lo mismo. El que hace de referencia tiene que estar bien calibrado:
este método copia su error.

1. Pon los dos medidores **juntos**, con las entradas de aire a pocos
   centímetros, en una habitación cerrada y sin nadie respirando cerca. Lo
   ideal es que el CO₂ ronde los 600–1000 ppm, que es donde el medidor se usa
   a diario.
2. Espera 10–15 minutos sin tocar nada.
3. En la página del medidor de referencia, sección **Calibración de CO₂**, lee
   la **media de los últimos 2 minutos**. No uses la lectura del momento: la
   media es la que compara el otro medidor.
4. En la página del medidor que quieres corregir, pon ese valor como
   referencia, pulsa **Calibrar ahora** y confirma.

Un medidor de los que calculan un "eCO₂" a partir de otros gases no sirve
como referencia: no mide CO₂.

### Calibración amplia

A veces un sensor llega de fábrica muy desviado: marca cientos de ppm de menos
o de más, aunque reacciona con normalidad al aliento y sigue la misma curva
que otro medidor. Por ejemplo, 50 ppm en el exterior, o 400 ppm menos que el
medidor de al lado en cualquier situación.

El medidor no admite de primeras una corrección de más de 150 ppm, porque lo
habitual es que el aire no sirva de referencia. Si pones una referencia más
lejana, la página no la rechaza: avisa y, al calibrar, pide una confirmación
de **calibración amplia**.

- **Solo con una referencia de confianza**: aire exterior en buenas
  condiciones, o un medidor calibrado justo al lado.
- Las lecturas pueden variar hasta 150 ppm en los 2 minutos, en vez de 40.
- Para deshacerla luego hace falta un aire con bastante CO₂. Ver
  [Deshacer](#deshacer).

### Qué comprueba el medidor

- **La altitud** guardada tiene que ser la que usa el sensor.
- **La media, no la última lectura.** Calibra contra la media de los últimos
  2 minutos, que tienen que ser seguidos y estables.
- **Un límite de corrección** de 150 ppm, salvo en la calibración amplia.
- **La referencia** tiene que estar entre 400 y 2000 ppm. Es el rango que
  acepta el sensor.

### Se conserva

La corrección se guarda en el propio sensor y sobrevive a los apagados y a
las actualizaciones de firmware.

### Deshacer

El SCD30 no tiene forma de volver a la calibración de fábrica. En su lugar,
el medidor recuerda qué marcaba el sensor y a qué se ajustó en la última
calibración. **Deshacer la última calibración** aplica la corrección
contraria sobre la lectura actual.

Por eso funciona con cualquier aire estable, también en interior: no hace
falta saber cuánto CO₂ hay. Solo hay una condición. El sensor no acepta
referencias por debajo de 400 ppm, así que **la lectura menos la corrección
tiene que quedar en 400 o más**.

| Última corrección | Deshacer funciona cuando el medidor marca |
|---|---|
| +50 ppm | 450 ppm o más: casi siempre |
| +150 ppm | 550 ppm o más |
| +370 ppm | 770 ppm o más: en interior, con gente |

Si el aire no lo permite, la página desactiva el botón y explica por qué.
Espera a que suba el CO₂ de la habitación, o simplemente vuelve a calibrar con
una referencia buena: eso siempre se puede.

Solo se puede deshacer la **última** calibración, y solo si se hizo desde la
página o la API del medidor.

### Autocalibración

El medidor no usa la autocalibración automática. Es una función del propio
sensor SCD30 (ASC), que da por hecho que el sensor ve aire fresco con
regularidad, algo que en interior rara vez se cumple. El medidor nunca la
activa ni la desactiva: solo la comprueba al arrancar. Si un sensor viniera con
ella activada, la sección **Calibración de CO₂** muestra un aviso, porque en
los días siguientes sustituiría a la calibración manual.

### Problemas con el CO₂

#### El botón Calibrar ahora no se activa

La sección **Calibración de CO₂** dice debajo del botón qué falta:

| La página dice | Qué hacer |
|---|---|
| La altitud del formulario no es la del sensor | Guarda, espera al reinicio y vuelve a la página |
| El sensor no da lecturas | Ver [Ayuda](help.md#no-readings-check-the-sensor) |
| Midiendo desde hace… | Espera: hacen falta 2 minutos de lecturas sin cortes. Un reinicio vuelve a empezar la cuenta |
| Las lecturas varían… ppm | El aire no está quieto. Ver la sección siguiente |
| La referencia debe estar entre 400 y 2000 ppm | Corrige el número |

#### Las lecturas no se estabilizan

- **No le respires cerca**, ni dejes que haya gente al lado: el aire exhalado
  lleva unos 40.000 ppm.
- **En el exterior**, ráfagas de viento, el sol directo, el tráfico o una
  chimenea cercana mueven la lectura. Busca un sitio a la sombra y resguardado,
  o protégelo con una caja con agujeros.
- **Recién encendido**, el sensor necesita unos minutos para estabilizarse.
- **En interior**, cierra puertas y ventanas y espera a que la habitación se
  asiente. Una ventana que se abre o alguien que entra cambia el CO₂ en
  segundos.

#### Dos medidores no coinciden

Dos sensores en tolerancia pueden diferir bastante, porque cada uno tiene su
propio margen:

| Concentración | Margen de cada uno | Diferencia normal entre dos |
|---|---|---|
| 450 ppm | ±44 ppm | hasta unos 90 ppm |
| 1000 ppm | ±60 ppm | hasta unos 120 ppm |
| 2000 ppm | ±90 ppm | hasta unos 180 ppm |

- **Diferencias dentro de esos márgenes:** son normales. Si quieres que
  coincidan, calibra uno [con el otro como referencia](#con-otro-medidor-de-referencia).
- **Diferencias mayores, pero los dos siguen la misma curva:** uno de los dos
  está desviado. Sácalos al exterior para saber cuál, y calibra ese.
- **La diferencia crece con la concentración:** es normal en parte. La
  calibración corrige exactamente el punto donde se hace, así que calíbralo
  cerca de los valores que más te importan.
- **Uno reacciona distinto o mucho más lento:** no es un problema de
  calibración. Comprueba que los dos ven el mismo aire.

#### Calibré con una referencia equivocada

Por ejemplo, alguien respiró cerca, o pusiste mal el número. Usa
[Deshacer](#deshacer), o vuelve a calibrar con una referencia buena: la nueva
calibración sustituye a la anterior.

#### Errores al calibrar

| Error | Qué significa |
|---|---|
| El sensor no da lecturas | No hay lecturas recientes. Espera o reinicia |
| La altitud guardada aún no está en el sensor | Reinicia primero |
| Las lecturas aún no son estables | Las lecturas cambiaron justo antes de calibrar. Espera |
| No hay ninguna calibración que deshacer | No hay ninguna calibración registrada en este medidor |
| La referencia debe estar entre 400 y 2000 ppm | Lo exige el sensor, también al deshacer |
| La corrección es demasiado grande | Solo por API, sin `"wide": true` |
| El sensor no respondió a tiempo | Puede que se haya aplicado. **Mira la lectura antes de reintentar**, o corregirás dos veces |
| Hay otra calibración en curso | Espera unos segundos |
| El sensor la rechazó | Reinicia el medidor e inténtalo otra vez |

### Desde un script

```sh
# Calibrar
curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"reference": 430}' http://co2-monitor-xxxxxx.local/api/frc

# Calibración amplia
curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"reference": 430, "wide": true}' http://co2-monitor-xxxxxx.local/api/frc

# Deshacer la última
curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"undo": true}' http://co2-monitor-xxxxxx.local/api/frc
```

`GET /api/status` devuelve en `cal` si las lecturas están listas (`ready`,
y `ready_wide` para la calibración amplia), su media (`avg`) y cuánto
varían (`spread`).

## Temperatura

El SCD30 se calienta un poco mientras funciona, y la electrónica de alrededor
añade algo de calor. Por eso el medidor marca algo más que la habitación. El
campo **Calibrar temperatura**, en **Sensor**, lo corrige.

- La corrección se **resta** de cada lectura. El sensor no puede sumar: solo
  corrige un medidor que marca de más.
- La **humedad** se recalcula con la temperatura corregida. No tiene ajuste
  propio: corrige la temperatura y la humedad se corrige con ella.
- No afecta al CO₂.
- Se guarda en el propio sensor y sobrevive a los apagados.

### Cómo hacerlo

La corrección depende de cuánto se calienta el medidor, y eso cambia con la
caja, el brillo de la pantalla y el sitio. Mídela **tal como vas a usarlo**.

1. Pon el medidor en su sitio, con la caja cerrada y el brillo que vayas a
   usar, junto a un termómetro de confianza. Los dos lejos del sol, de
   radiadores y de otros aparatos que calienten.
2. Déjalo funcionando **20–30 minutos**.
3. Escribe **lo que marca el medidor menos lo que marca el termómetro**. Si el
   medidor dice 27,5 y el termómetro 25,0, escribe **2,5**.
4. Guarda. El medidor se reinicia.
5. **Espera 20–30 minutos** antes de volver a comparar. Ver la sección
   siguiente.

El valor se **suma** a la corrección actual, no la sustituye. Así, lo que
mides después es siempre lo que falta corregir, sin cuentas. Deja el campo
vacío salvo cuando estés calibrando.

### Qué esperar después de guardar

Dos cosas hacen que el cambio no se vea al momento:

- **El reinicio.** Al guardar, el medidor se reinicia, y durante unos minutos
  vuelve a calentarse. La temperatura sube poco a poco hasta estabilizarse.
- **El propio sensor.** El SCD30 no aplica la corrección de golpe: la lectura
  se va acercando al valor nuevo a lo largo de unos 10–15 minutos.

No encadenes correcciones mirando la lectura al momento: acabarías corrigiendo
de más.

### Problemas con la temperatura

#### Parece que la corrección no hace nada

Mira la frase de la sección **Sensor**: *El sensor guarda ahora X °C de
corrección*. Si muestra el valor nuevo, la corrección está aplicada. Espera
20–30 minutos, como en [Qué esperar después de guardar](#que-esperar-despues-de-guardar).

#### Ahora marca menos que el termómetro

La corrección se pasó. Escribe la diferencia con su signo, que será negativa:
si el medidor dice 23,0 y el termómetro 23,5, escribe **-0,5**.

#### Marca menos que el termómetro sin ninguna corrección

El sensor no puede sumar grados. Comprueba el termómetro y que los dos están
en el mismo sitio. La tolerancia del SCD30 es de unos ±0,4 °C.

#### Cambié la caja, el brillo o el sitio

La corrección ya no vale: mídela otra vez. Para empezar de cero, escribe la
corrección actual en negativo (si guarda 3,7 °C, escribe **-3,7**) y guarda.
Después sigue los pasos de [Cómo hacerlo](#como-hacerlo).

#### Sube durante un rato después de encenderlo

Es normal. El medidor se calienta durante los primeros 10–20 minutos, y la
lectura sube con él. La corrección está pensada para cuando ya está estable.

#### La humedad no cuadra

Corrige primero la temperatura: la humedad depende de ella. Si después sigue
sin cuadrar, ten en cuenta que la tolerancia del SCD30 es de ±3 % de humedad
relativa, y que muchos higrómetros domésticos fallan bastante más.

#### Fijar un valor exacto

La página solo suma diferencias. Para escribir la corrección total, envíala
por API en centésimas de grado. Por ejemplo, 2,90 °C:

```sh
curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"temp_offset_c100": 290}' http://co2-monitor-xxxxxx.local/api/config

curl -X POST -H 'X-CO2-Monitor: 1' http://co2-monitor-xxxxxx.local/api/reboot
```

La corrección llega al sensor al arrancar. La página reinicia el medidor sola
al guardar; por API hay que pedirlo, como en la segunda línea.
