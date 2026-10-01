# Actualizar el firmware

## Por red

1. Descarga el último firmware `.bin` de **TODO: URL de las versiones**.
2. Abre la página web del medidor y ve a **Sistema**.
3. En **Actualizar firmware**, elige el fichero `.bin` y pulsa **Subir y
   reiniciar**.

La versión actual aparece en **Sistema → Versiones**, en la pantalla de
arranque y en el topic MQTT `info`.

### Se puede interrumpir sin riesgo

- **Nada cambia hasta que la subida termina.** La imagen nueva se escribe
  junto a la que está en marcha y se comprueba antes de cambiar nada. Si la
  subida se corta, el firmware actual no se toca.
- **La versión nueva arranca a prueba.** Tiene que demostrar que funciona:
  una lectura real del sensor y una radio que no se ha quedado atascada
  intentando conectar. Si no lo consigue, el medidor vuelve a la versión
  anterior en el siguiente reinicio.
- **Solo se acepta firmware de este aparato.**

Tras la actualización, la página muestra la versión que está en marcha. Si
sigue siendo la antigua, la nueva no llegó a arrancar y se ha vuelto atrás.

### Los ajustes se conservan

Las actualizaciones conservan todos los ajustes. Se guardan en una sola
entrada que se escribe entera o no se escribe, así que un corte de luz a
mitad de un guardado deja los ajustes anteriores, nunca una mezcla.

## Números de versión

El firmware usa [versionado semántico](https://semver.org/lang/es/):
`mayor.menor.parche`. Una versión con `-dev`, como `1.0.0-dev+abc1234`, es una
compilación de desarrollo, no una versión publicada.
