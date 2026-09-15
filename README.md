# Segundo Examen Parcial | Organización de Computadores

## Índice
1. [Parte 1 de la entrega: Raíz cuadrada entera](#parte-1-de-la-entrega-raíz-cuadrada-entera)
   1. [Pasos de ejecución](#pasos-de-ejecución)
2. [Parte 2 de la entrega: Interfaz gráfica de matriz](#parte-2-de-la-entrega-interfaz-gráfica-de-matriz)
   1. [Pasos de ejecución](#pasos-de-ejecución-1)
3. [Autores](#autores)
4. [Información del curso](#información-del-curso)

## Parte 1 de la entrega: Raíz cuadrada entera

`Sqrt.asm` se encarga de obtener, única y exclusivamente, la parte entera de la raíz cuadrada de un número **x**, que debe ser un entero positivo y mayor o igual a cero.

### Entrada y salida

El programa ubica el valor del cual se obtendrá la raíz cuadrada en la posición **0** de la RAM:

```hack_asm
@0
D=A
@0
M=D
```

Y la respuesta se ubica en la posición **1** de la RAM:

```hack_asm
@1
M=0
```

### Funcionamiento

**Candidato a raíz cuadrada**

Los posibles números que vamos probando, para ver si son o no la solución, se ubican en esta sección del código, iniciando en 0:

```hack_asm
@x
M=0
```

**Preparación de la multiplicación**

Aquí se establecen los valores del multiplicando (`a`) y el multiplicador (`b`), ambos con el mismo valor, para obtener el número que se está probando en ese momento, elevado al cuadrado:

```hack_asm
(LOOP)
    @prod
    M=0        

    @x
    D=M
    @a
    M=D        
    @b
    M=D        
```

**Multiplicación por sumas sucesivas**

Esta sección realiza la multiplicación por medio de la suma consecutiva del multiplicando `a`, tantas veces como lo indique el multiplicador `b`, guardando el resultado en `prod`. Cuando `b` llega a 0, se pasa a la verificación de la raíz cuadrada. Además, la condición de que `b` sea igual a 0 se comprueba desde el inicio del bucle, para cubrir correctamente el caso de la raíz cuadrada de 0.

```hack_asm
(MULTIPLICATION_LOOP)
    @b
    D=M
    @MULTIPLICATION_END
    D;JEQ

    @a
    D=M
    @prod
    M=M+D

    @b
    M=M-1

    @MULTIPLICATION_LOOP
    0;JMP
```

**Verificación de la raíz y actualización de la respuesta**

En esta parte verificamos si `x² - R0 > 0`, lo cual indica si el número `x` que estamos probando ya superó la raíz cuadrada del número original. Si esto es verdadero, el proceso termina y ese valor de `x` queda descartado. Si es falso, guardamos ese valor de `x` en la posición 1 de la RAM —la respuesta— y volvemos a probar con un valor de `x` mayor, repitiendo el ciclo llevado hasta ese momento.

```hack_asm
(MULTIPLICATION_END)
    @prod
    D=M
    @R0
    D=D-M          

    @END
    D;JGT

    @x
    D=M
    @1
    M=D

    @x
    M=M+1

    @LOOP
    0;JMP
```

**Finalización**

En esta última parte se realiza un ciclo infinito para terminar el programa, una vez que ya se obtuvo la parte entera de la raíz cuadrada del número.

```hack_asm
(END)
    @END
    0;JMP
```

### Pasos de ejecución

1. Cargar `Sqrt.asm` en el CPU Emulator (Nand2Tetris).
2. Escribir el número a evaluar en `RAM[0]`.
3. Ejecutar (Run).
4. Leer el resultado en `RAM[1]`.

## Parte 2 de la entrega: Interfaz gráfica de matriz

Programa en ensamblador Hack que hace polling continuo del teclado (`KBD`) y dibuja glifos de 32×32 píxeles en pantalla. Se pueden teclear hasta 3 iniciales (**M**, **S**, **C**), en cualquier orden, y cada una ocupa el siguiente puesto libre de izquierda a derecha. Al presionar una tecla válida con los 3 puestos ya llenos, se libera memoria automáticamente. Además, la **barra espaciadora** (ASCII 32) limpia todo en cualquier momento.

### Variables de memoria (RAM)

| Variable | Uso |
| --- | --- |
| `count` | Cuántos puestos ya están ocupados (0, 1, 2 o 3) |
| `slotOffset` | Desplazamiento en palabras (0, 3 o 6) del puesto activo, sumado a la dirección base de cada fila |
| `addr` | Dirección de escritura, recalculada en cada paso de cada rutina |
| `letterTarget` | Dirección de ROM de la rutina `DRAW_X` a ejecutar, usada para un salto indirecto |
| `BIT15` | Constante `32768` (bit 15 encendido), calculada una sola vez al inicio |

### Flujo de control

1. **`WAIT_PRESS`** — Lee `KBD` en loop hasta detectar una tecla presionada.
2. **`CHECK_M` / `CHECK_S` / `CHECK_C`** — Identifica cuál tecla es. Si `count == 3`, salta a `RESET` (la tecla actúa solo como disparador, no se dibuja). Si hay espacio, guarda en `letterTarget` la dirección de la rutina `DRAW_X` correspondiente y continúa. Independientemente de `count`, si la tecla es la **barra espaciadora** (ASCII 32), salta directo a `RESET` — es un disparador manual de limpieza en cualquier momento, no solo cuando los 3 puestos están llenos.
3. **`COMPUTE_OFFSET_AND_JUMP`** — Traduce `count` (0/1/2) al desplazamiento en palabras del puesto (0/3/6), lo guarda en `slotOffset`, y salta indirectamente a `letterTarget` (`A=M` seguido de `0;JMP`).
4. **`DRAW_M` / `DRAW_S` / `DRAW_C`** — Escribe las 32 filas (64 palabras) del glifo en `SCREEN + fila_fija + slotOffset`. Al terminar, incrementa `count` y salta a `WAIT_RELEASE`.
5. **`RESET`** — Limpia el área completa con un loop anidado (32 filas × 8 columnas), reinicia `count = 0`.
6. **`WAIT_RELEASE`** — Espera a que la tecla se suelte antes de volver a `WAIT_PRESS`. Evita que una sola pulsación sostenida se cuente varias veces (debounce).

### Direccionamiento de pantalla

Cada glifo mide 2 palabras de ancho (32 px) × 32 filas. Los 3 puestos están separados por 1 palabra de hueco, con paso fijo `STEP = 3` palabras entre uno y el siguiente. La dirección base de cada fila del puesto 0 es:

base(fila, palabra) = SCREEN + (112 + fila) * 32 + 12 + palabra


`112` centra verticalmente (`(256-32)/2`), `12` centra horizontalmente el bloque de 3 puestos (`(32-8)/2`). Para dibujar en el puesto activo, cada dirección se calcula como `base(fila, palabra) + slotOffset`, donde `slotOffset` es 0, 3 o 6 según cuál puesto le corresponda a la letra actual — esto permite que **cualquier letra aterrice en cualquier puesto** sin triplicar el código.

### Decisión técnica: valores de 16 bits mayores a 32767

Una instrucción `@valor` en Hack solo puede codificar 0–32767 (15 bits). Los patrones de píxeles de un glifo son palabras de 16 bits sin signo, y casi la mitad de ellos necesitan el bit 15 encendido (el píxel más a la derecha de esa palabra) — eso excede el límite de la instrucción.

**Solución:** al arrancar el programa, se calcula `BIT15 = 32768` por duplicación sucesiva. Hack no permite `D=D+D` (el ALU solo suma `D` con `A` o `M`, nunca consigo mismo), así que cada doblez copia primero `D` a `A` (`A=D`) y luego suma (`D=D+A`) — quince veces, partiendo de `D=1`. Para cargar un valor `v ≥ 32768`, se carga `v - 32768` (que sí cabe en 15 bits) y se combina con `D = D | BIT15`, reconstruyendo el patrón completo de 16 bits sin exceder nunca el límite de una A-instrucción.

### Optimizaciones aplicadas

- **Limpieza por loop, no desenrollada:** `RESET` recorre 32 filas × 8 columnas con un loop anidado (~60 líneas) en vez de 192 direcciones escritas una por una (~390 líneas). Limpiar también el hueco entre puestos es inofensivo, porque ahí nunca se escribe nada durante el dibujo.
- **Reutilización de `D`:** dentro de cada `DRAW_X`, si el valor de 16 bits de una fila es igual al de la fila anterior (común en trazos sólidos de los glifos), se omite la recarga y se reutiliza el `D` ya cargado.

### Cómo extender a otra terna de iniciales

1. Generar el patrón de bits de 32×32 de la nueva letra (matriz de 1/0 por píxel).
2. Convertir cada fila a dos enteros de 16 bits (palabra izquierda / derecha), con bit 0 = píxel más a la izquierda.
3. Reemplazar los valores dentro del bloque `DRAW_X` correspondiente.
4. Cambiar el código ASCII comparado en el `CHECK_X` respectivo (p. ej. `@77` para `'M'`).

La estructura de control (loop principal, despachador, reset, debounce) no necesita ningún cambio.

### Pasos de ejecución

1. Cargar `GlyphMatrix.asm` en el CPU Emulator.
2. Ejecutar con animación desactivada (**Run → Animate → No Animation**).
3. Con la ventana del emulador enfocada, presionar `M`, `S` o `C` — que son las iniciales de los nombres de dos integrantes y el apellido de uno - el glifo aparece en el siguiente puesto libre.
4. Repetir con otra inicial para ver cómo se ubican una al lado de la otra.
5. Presionar una 4ta tecla válida con los 3 puestos llenos, o presionar la barra espaciadora en cualquier momento: la pantalla se limpia.

## Autores

**Mateo Montoya Ospina** -> M <br>
**Sebastian Ibarra Prada** -> S <br>
**Miguel Angel Colorado Castaño** -> C

## Información del curso
**Curso:** Organización de Computadores - S2666-0322 <br>
**Profesor:** Edison Valencia Diaz