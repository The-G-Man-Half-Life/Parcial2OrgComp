# Sqrt.asm

## Descripción

`Sqrt.asm` se encarga de obtener, única y exclusivamente, la parte entera de la raíz cuadrada de un número **x**, que debe ser un entero positivo y mayor o igual a cero.

## Entrada y salida

El programa ubica el valor del cual se obtendrá la raíz cuadrada en la posición **0** de la RAM, como se ve aquí:

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

## Funcionamiento

### Candidato a raíz cuadrada

Los posibles números que vamos probando, para ver si son o no la solución, se ubican en esta sección del código, iniciando en 0:

```hack_asm
@x
M=0
```

### Preparación de la multiplicación

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

### Multiplicación por sumas sucesivas

Esta sección realiza la multiplicación por medio de la suma consecutiva del multiplicando `a`, tantas veces como lo indique el multiplicador `b`, guardando el resultado en `prod`. Cuando `b` llega a 0, se pasa a la verificación de la raíz cuadrada, en la parte de abajo. Además, la condición de que `b` sea igual a 0 se comprueba desde el inicio del bucle, para cubrir correctamente el caso de la raíz cuadrada de 0.

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

### Verificación de la raíz y actualización de la respuesta

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

### Finalización

En esta última parte se realiza un ciclo infinito para terminar el programa, una vez que ya se obtuvo la parte entera de la raíz cuadrada del número.

```hack_asm
(END)
    @END
    0;JMP
```