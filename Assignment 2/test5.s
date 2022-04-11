.global test5
test5:
    mov r0,#0xFFFFFFF6
    mov r1,#20
    mov r2,#3
    mul r5,r0,r1
    mla r6,r0,r1,r2
    umull r7,r8,r0,r1
    umlal r9,r10,r0,r1
    smull r11,r12,r0,r1
    smlal r13,r14,r0,r1