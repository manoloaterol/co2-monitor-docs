# Calibración

El sensor sale calibrado de fábrica, y la mayoría de los medidores no
necesitan nada más. Esta página trata las tres correcciones que ofrece la
página web: altitud, CO₂ y temperatura.

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

## Calibración de CO₂

La tolerancia del SCD30 es de ±(30 ppm + 3 %). Si con el tiempo se desvía, la
sección **Calibración de CO₂** le dice al sensor cuánto CO₂ hay de verdad a
su alrededor, y el sensor ajusta su curva. Se llama *recalibración forzada*
(FRC). La referencia habitual es el aire exterior.

Si el medidor ya marca entre unos 400 y 470 ppm en el exterior, está dentro de
su tolerancia y calibrar aporta poco.

### Cómo hacerlo

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
   más cerca de una ciudad. Si tienes un medidor de referencia justo al lado,
   usa su valor.
6. Pulsa **Calibrar ahora** y confirma.

### Qué comprueba el medidor

- **La media, no la última lectura.** Calibra contra la media de los últimos
  2 minutos.
- **Un límite de corrección.** Se rechaza una corrección de más de 150 ppm.
  Es mucho más probable un aire que no sirve de referencia que un sensor tan
  desviado.
- **La referencia** tiene que estar entre 400 y 2000 ppm.

### Se conserva

La corrección se guarda en el propio sensor y sobrevive a los apagados.

### Deshacer

El SCD30 no tiene forma de volver a la calibración de fábrica. En su lugar,
el medidor recuerda qué marcaba el sensor y a qué se ajustó en la última
calibración. **Deshacer la última calibración** aplica la corrección
contraria.

A diferencia de calibrar, deshacer funciona con cualquier aire estable,
también en interior, porque la referencia sale de la lectura actual.

### Autocalibración

El SCD30 tiene además una autocalibración (ASC). El medidor no la toca. Si el
sensor la trae activada, la página lo avisa, porque en los días siguientes
sustituiría a la calibración manual.

### Desde un script

```sh
curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"reference": 430}' http://co2-monitor-xxxxxx.local/api/frc

curl -H 'X-CO2-Monitor: 1' -H 'Content-Type: application/json' \
     -d '{"undo": true}' http://co2-monitor-xxxxxx.local/api/frc
```

## Temperatura

El SCD30 se calienta un poco mientras funciona, y la electrónica de alrededor
añade algo de calor. Por eso el medidor marca algo más que la habitación. El
campo **Calibrar temperatura** lo corrige:

1. Deja el medidor funcionando al menos 10 minutos, con la caja cerrada, junto
   a un termómetro de confianza.
2. Escribe **lo que marca el medidor menos lo que marca el termómetro**. Si el
   medidor dice 27,5 y el termómetro 25,0, escribe **2,5**.
3. Guarda.

El valor se **suma** a la corrección actual, no la sustituye, así que deja el
campo vacío salvo cuando estés calibrando. Un valor negativo deshace una
corrección excesiva. La página muestra la corrección que tiene ahora el
sensor. La corrección se guarda en el sensor y sobrevive a los apagados.
