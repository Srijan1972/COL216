.global test3
test3:
    mov r0,#73
    mov r1,#37
    and r2,r0,r1
    eor r3,r0,r1
    rsb r4,r0,r1
    adc r5,r0,r1
    sbc r6,r0,r1
    rsc r7,r0,r1
    tst r0,r1
    teq r0,r1
    cmn r0,r1
    orr r8,r0,r1
    mvn r9,r0
    bic r10,r0,r1