.text
    mov r0,#2
    mov r1,#4
    bl gcd
    swi 0x06

gcd:
    cmp r0,r1
    moveq pc,lr
    blt sublt
subgt:
    sub r0,r0,r1
    b gcd
sublt:
    sub r1,r1,r0
    b gcd
.end