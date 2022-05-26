/**
 * Referencias importantes:
 * https://developer.arm.com/documentation/dui0552/a
 * https://github.com/ARM-software/abi-aa/tree/main/aapcs32
 */
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.macro defun nombre
    .section .text.\nombre
    .global \nombre
    .type \nombre, %function
\nombre:
.endm

.macro endfun nombre
    .size \nombre, . - \nombre
.endm

defun copiaMemoria
    // Implementación aquí
    // R0: origen, R1: destino, R2: longitud
0:
    tst R2, #(-1)  //basicamente estoy checkeando si ya copie todo, o no, de la memoria.
    beq 1f

    ldrb R3, [R0],#1
    strb R3, [R1],#1 //Guardé en un registro un byte de la memoria y "movi" el cursor al proximo byte y luego lo cargue en R1.
    subs R2,R2,#1 //Cuando la resta sea igual a 0, entonces ya se habrá recorrido toda la memoria y deberia terminar.
    bne 0b
1:
    bx lr
endfun copiaMemoria



defun copiaCadena
    // Implementación aquí
    // R0: origen, R1: destino, R2: longitudMaxima, R3: ContadorLongitud
    push {R3,R4,LR}
    mov R3, #0x01   //Como el rango de valores va desde 0x01 a 0xff, entonces al contador le movemos ese valor primero
    tst R2, #(-1)  //Checkeando si ya copie todo, o no, de la memoria.
    beq 1f

0:

    ldrb R4,[R0],#1  //Guardo un byte del origen al registro R4
    cmp R4, 0x00    //Checkeo si el byte que estoy copiando es 00000000, osea su terminador nulo, y si lo es, saltará hacia "1"
    beq 1f

    cmp R3, R2  //Comparo si el contador igualó a la longitud maxima de la cadena, y si es asi, salta a "1"
    beq 1f
   
    strb R4,[R1],#1 //Grabo el byte correspondiente en R1 y muevo el "cursor" un byte
    add R3,R3,#1 //Le sumo uno al contador de longitud
    b 0b

1:
    mov R4, #0x00   //Muevo el terminador nulo a R4 y luego lo grabaré en R1 y termina el programa, habiendo copiado la cadena y escrito su respectivo terminador nulo
    strb R4, [R1]
    pop {R3,R4,PC}
    bx lr
endfun copiaCadena







defun mayusculaEnLugar
    // Implementación aquí
    // R0: cadena, R1: longitudMaxima
    push {R1, LR}
    cbz R1, 1f  //Comparo la longitud con 0, y si es asi, salto a "1"
0:
    ldrb  R2,[R0],#1 // Guardo el primer byte de la cadena en R2
    cmp R2, #0x00   // Comparo R2 con el terminador nulo, y si es asi, salta al final del programa 
    beq 1f
    cmp R2, #0x61   //Comparo el byte para ver si es mayuscula o no, y si no es, le restaré el valor hexadecimal "0x20", para cambiar a mayuscula
    blt contador
    cmp R2, #0x7A
    bgt contador

    sub R2, #0x20   //Resta necesaria para cambiar a mayuscula
    sub R0, #1
    strb R2, [R0], #1 //Copio el byte modificado en la cadena

contador:
    subs R1, #1 //Resta para el contador
    beq 1f
    bl 0b


1:
    pop {R1, PC}
    bx lr
endfun mayusculaEnLugar


defun minusculaEnLugar
    // Implementación aquí
    // R0: cadena, R1: longitudMaxima
    push {R1, LR}
    cbz R1, 1f  //Comparo la longitud con 0, y si es asi, salto a "1"
0:
    ldrb  R2,[R0],#1    // Guardo el primer byte de la cadena en R2
    cmp R2, #0x00   // Comparo R2 con el terminador nulo, y si es asi, salta al final del programa
    beq 1f
    cmp R2, #0x41   //Comparo el byte para ver si es minuscula o no, y si no es, le sumaré el valor hexadecimal "0x20", para cambiar a mayuscula
    blt contador2
    cmp R2, #0x5A
    bgt contador2

    add R2, #0x20   //Suma para cambiar a minuscula
    sub R0, #1
    strb R2, [R0], #1 //Copio el byte modificado en la cadena

contador2:
    subs R1, #1 //Resta para el contador
    beq 1f
    bl 0b


1:
    pop {R1, PC}
    bx lr
endfun minusculaEnLugar 


