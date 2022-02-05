.global comp
@ r0 contains address of 1st character of 1st string
@ r1 contains address of 2nd character of 2nd string
@ r2 contains result- (1 if 1>2 0 if 1=2 and -1 if 1<2)
@ r2 stores case sensitivity- (1 if insensitive, 0 if sensitive)
@ r3 used as 32 for case conversion
@ r4,r5 used to iterate over chars of string
comp:
    stmfd sp!,{r2}
    mov r3,r2,lsl#5 @ Stores 32 for case conversion
    ldrb r4,[r0]
    cmp r4,#65
    addge r4,r4,r3
    cmp r4,#122
    subgt r4,r4,r3
    ldrb r5,[r1]
    cmp r5,#65
    addge r5,r5,r3
    cmp r5,#122
    subgt r5,r5,r3
    add r2,r4,r5 @ Checking if both strings have ended
    cmp r2,#0
    moveq r2,#0
    moveq pc,lr
    cmp r4,r5
    movlt r2,#0xFFFFFFFF
    movlt pc,lr
    movgt r2,#1
    movgt pc,lr
    add r0,r0,#1
    add r1,r1,#1
    ldmfd sp!,{r2}
    b comp
