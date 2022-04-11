.global test2
test2:
    mov r1,#0
    mov r0,#0
    mov r2,#5
loop:
    add r1,r1,#1
    add r0,r0,r1
    cmp r1,r2
    blt loop