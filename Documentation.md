# Segundo Examen Parcial | Organización de Computadores

## Índice
1. [Parte 1 de la entrega: Raíz cuadrada entera](#parte-1-de-la-entrega-raíz-cuadrada-entera)
   1. [Pasos de ejecución](#pasos-de-ejecución)
2. [Parte 2 de la entrega: Interfaz gráfica de matriz](#parte-2-de-la-entrega-interfaz-gráfica-de-matriz)
   1. [Pasos de ejecución](#pasos-de-ejecución-1)
3. [Autores](#autores)
4. [Información del curso](#información-del-curso)

## Parte 1 de la entrega: Raíz cuadrada entera

`Sqrt.asm` calcula la parte entera de la raíz cuadrada de un número positivo. El valor de entrada se ubica en `RAM[0]`; el resultado se guarda en `RAM[1]`.

El algoritmo prueba candidatos `x = 0, 1, 2, ...` en un loop. En cada vuelta calcula `x²` (multiplicación por sumas sucesivas, ya que Hack no tiene instrucción de multiplicar), y compara ese cuadrado contra el valor original (`RAM[0]`). Mientras `x² ≤ RAM[0]`, ese `x` se guarda como la mejor respuesta hasta el momento y se prueba con `x+1`. En cuanto `x² > RAM[0]`, el programa se detiene: la última respuesta guardada es la parte entera de la raíz cuadrada.

### Pasos de ejecución

1. Cargar `Sqrt.asm` en el CPU Emulator (Nand2Tetris).
2. Escribir el número a evaluar en `RAM[0]`.
3. Ejecutar (Run).
4. Leer el resultado en `RAM[1]`.

## Parte 2 de la entrega: Interfaz gráfica de matriz

`GlyphMatrix.asm` hace polling continuo del teclado (`KBD`) y dibuja glifos de 32×32 píxeles en pantalla. Se pueden teclear hasta 3 iniciales (**M**, **S**, **C**), en cualquier orden, y cada una ocupa el siguiente puesto libre de izquierda a derecha, centradas como grupo en pantalla.

Al presionar una tecla válida con los 3 puestos ya ocupados, se libera memoria automáticamente (limpia todo y reinicia el conteo). La barra espaciadora limpia todo en cualquier momento, sin importar cuántos puestos estén ocupados.

**Detalles técnicos relevantes:**
- Cada letra se dibuja en la posición determinada por el orden en que se tecleó, no por su identidad — mediante un desplazamiento (`slotOffset`) calculado en tiempo de ejecución y un salto indirecto a la rutina de dibujo correspondiente.
- Los patrones de píxeles de 16 bits que necesitan el bit más significativo encendido (valor ≥ 32768) no caben en una sola instrucción `@valor` (límite de 15 bits en Hack). Se resuelve construyendo una constante `BIT15 = 32768` una sola vez al inicio y combinándola con `OR` cuando hace falta.
- La limpieza de pantalla (`RESET`) usa un loop anidado de 32 filas × 8 columnas en vez de instrucciones repetidas una por una, para reducir el tamaño del programa.

### Pasos de ejecución

1. Cargar `GlyphMatrix.asm` en el CPU Emulator.
2. Ejecutar con animación desactivada (**Run → Animate → No Animation**).
3. Con la ventana del emulador enfocada, presionar `M`, `S` o `C` — el glifo aparece en el siguiente puesto libre.
4. Repetir con otra inicial para ver cómo se ubican una al lado de la otra.
5. Presionar una 4ta tecla válida con los 3 puestos llenos, o presionar la barra espaciadora en cualquier momento: la pantalla se limpia.

## Autores

**Mateo Montoya Ospina** <br>
**Sebastian Ibarra Prada** <br>
**Miguel Angel Colorado Castaño**

## Información del curso
**Curso:** Organización de Computadores - S2666-0322 <br>
**Profesor:** Edison Valencia Diaz