.global test1
test1:
    mov r2,#100
    mov r3,#80
    ldr r6, [r2, #0]
    ldr r7, [r3, #0]
    str r7, [r2, #0]
    str r6, [r3, #0]