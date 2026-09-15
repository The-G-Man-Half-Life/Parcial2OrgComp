// Programa que lee el teclado y dibuja C, M o S en la pantalla
//Parte superior izquierda

(INICIO)
    @KBD
    D=M         // Leer la tecla actual

    // Comprobar si es C
    @67 // Valor Ascii de la C con el cual se averiguara si el input es c o no
    D=D-A   // La resta aqui determinara si es la C o no
    @DIBUJAR_C
    D;JEQ    //Viajamos a donde se hace la c si D == 0

    @KBD
    D=M         // Volver a leer la tecla
    
    // Comprobar si es M
    @77 //valor ascii de la M
    D=D-A //resta para verificar si el input es o no la M
    @DIBUJAR_M
    D;JEQ       //Si el valor es igual a 0 viajamos a donde se hace la M

    @KBD
    D=M         // Volver a leer la tecla
    
    // Comprobar si es la S
    @83 //Valor ascii de la S
    D=D-A //Resta para verificar si el input es la S o no
    @DIBUJAR_S
    D;JEQ       // Si D == 0 viajamos a donde se hace la S

    // Si no es ninguna, volvemos al inicio a comprobar
    @INICIO
    0;JMP

// Proceso para dibujar la C
(DIBUJAR_C)
    @SCREEN //La pantalla para hacer el dibujo
    D=A
    @R0
    M=D         // R0 guarda la dirección actual de la pantalla

    // Borde superior (3 filas horizontales)
    @3
    D=A
    @R1
    M=D         // R1 es nuestro contador de filas
(C_ARRIBA)
    D=-1        // -1 = todos los píxeles negros
    @R0
    A=M
    M=D         // Dibujar en pantalla
    @32
    D=A
    @R0
    M=D+M       // Moverse a la siguiente fila (sumar 32 palabras)
    @R1
    M=M-1       // Restar 1 al contador
    D=M
    @C_ARRIBA
    D;JGT

    // Lado izquierdo (10 filas)
    @10
    D=A
    @R1
    M=D
(C_MEDIO)
    @15         // 15 = 4 píxeles negros a la izquierda
    D=A
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M
    @R1
    M=M-1
    D=M
    @C_MEDIO
    D;JGT

    // Borde inferior (3 filas)
    @3
    D=A
    @R1
    M=D
(C_ABAJO)
    D=-1
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M
    @R1
    M=M-1
    D=M
    @C_ABAJO
    D;JGT

    @INICIO
    0;JMP       // Terminar y volver a escuchar el teclado

// Dibujar la M
(DIBUJAR_M)
    @SCREEN
    D=A
    @R0
    M=D

    // Las piernas de la M
    @8185
    D=-A
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M

    // Hacer la diagonal
    @12277
    D=-A
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M

    @14317
    D=-A
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M

    @15325
    D=-A
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M

    @15805
    D=-A
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M

    @15997
    D=-A
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M

    // Patas
    @10
    D=A
    @R1
    M=D
(M_PATAS)
    @16381
    D=-A        // -16381 = únicamente las columnas 0,1,14,15 (las dos patas)
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M
    @R1
    M=M-1
    D=M
    @M_PATAS
    D;JGT

    @INICIO
    0;JMP

// ==========================================
// RUTINA PARA DIBUJAR LA 'S'
// ==========================================
(DIBUJAR_S)
    @SCREEN
    D=A
    @R0
    M=D

    // parte superior
    @3
    D=A
    @R1
    M=D
(S_P1)
    D=-1
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M
    @R1
    M=M-1
    D=M
    @S_P1
    D;JGT

    // Lado izquierdo arriba
    @4
    D=A
    @R1
    M=D
(S_P2)
    @15
    D=A
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M
    @R1
    M=M-1
    D=M
    @S_P2
    D;JGT

    // Medio horizontal (3 filas)
    @3
    D=A
    @R1
    M=D
(S_P3)
    D=-1
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M
    @R1
    M=M-1
    D=M
    @S_P3
    D;JGT

    // Lado derecho abajo (3 filas)
    @3
    D=A
    @R1
    M=D
(S_P4)
    @4096
    D=-A        // -4096 = 4 píxeles a la derecha
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M
    @R1
    M=M-1
    D=M
    @S_P4
    D;JGT

    // Borde inferior (3 filas)
    @3
    D=A
    @R1
    M=D
(S_P5)
    D=-1
    @R0
    A=M
    M=D
    @32
    D=A
    @R0
    M=D+M
    @R1
    M=M-1
    D=M
    @S_P5
    D;JGT


    @INICIO
    0;JMP