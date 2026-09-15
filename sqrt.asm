// Valor del cual deseamos obtener la raiz cuadrada
@16
D=A
@0
M=D

// Inicializamos la respuesta en 0
@Solution
M=0

// x es el número que se va a probar como posible raíz cuadrada
@x
M=0

(LOOP)
    // Inicializamos la multiplicación
    @prod
    M=0        // prod = 0

    @x
    D=M
    @a
    M=D        // a = x (el número que sumaremos varias veces)
    @b
    M=D        // b = x (cuenta cuántas veces falta sumar)

(MULTIPLICATION_LOOP)
    // si b == 0, terminamos de multiplicar
    @b
    D=M
    @MULTIPLICATION_END
    D;JEQ

    // sumamos a al producto
    @a
    D=M
    @prod
    M=M+D

    // reducimos en 1 la cantidad de veces que falta sumar
    @b
    M=M-1

    @MULTIPLICATION_LOOP
    0;JMP
(MULTIPLICATION_END)
    @prod
    D=M
    @R0
    D=D-M          

    // si (prod - R0) > 0, nos pasamos: terminamos el proceso
    @END
    D;JGT

    // si no nos pasamos, x sigue siendo una raíz válida: la guardamos
    @x
    D=M
    @Solution
    M=D

    // probamos con el siguiente número
    @x
    M=M+1

    // volvemos al inicio del bucle
    @LOOP
    0;JMP

(END)
    // bucle infinito para terminar el programa
    @END
    0;JMP