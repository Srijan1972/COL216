.extern comp
.global merge
@ r0 has address of start of 1st string of 1st list
@ r1 has address of start of 1st string of 2nd list
@ r2 contains case sensitivity
@ r4,r5 have sizes of both lists
@ r6 contains duplicate removal option (1 to remove, 0 to not remove)
@ r9 contains start of string pointer list

@ returns:
@ r0 contains start of pointer list
@ r4 contains merged list size
merge:
    stmfd sp!,{lr}
    stmfd sp!,{r0}
    stmfd sp!,{r9}
    stmfd sp!,{r4}
    stmfd sp!,{r5}
    add r7,r0,r4,lsl #2
    add r8,r1,r5,lsl #2
    mov r10,#0

mergeloop:
    cmp r0,r7
    beq rloop
    cmp r1,r8
    beq lloop
    stmfd sp!,{r0}
    stmfd sp!,{r1}
    ldr r0,[r0]
    ldr r1,[r1]
    bl comp
    ldmfd sp!,{r5}
    ldmfd sp!,{r1}
    ldmfd sp!,{r0}
    cmp r2,#0
    ldrlt r11,[r0]
    strlt r11,[r9]
    addlt r0,r0,#4
    ldrgt r11,[r1]
    strgt r11,[r9]
    addgt r1,r1,#4
    bleq dupcheck
    add r9,r9,#4
    mov r2,r5
    b mergeloop

dupcheck:
    cmp r6,#0
    addeq r1,r1,#4
    addeq r10,r10,#1
    ldr r11,[r0]
    str r11,[r9]
    add r0,r0,#4
    mov pc,lr

rloop:
    cmp r1,r8
    beq write_start
    ldr r11,[r1]
    str r11,[r9]
    add r1,r1,#4
    add r9,r9,#4
    b rloop

lloop:
    cmp r0,r7
    beq write_start
    ldr r11,[r0]
    str r11,[r9]
    add r0,r0,#4
    add r9,r9,#4
    b lloop

write_start:
    ldmfd sp!,{r5}
    ldmfd sp!,{r4}
    ldmfd sp!,{r9}
    ldmfd sp!,{r0}
    ldmfd sp!,{lr}
    add r4,r4,r5
    sub r4,r4,r10
    mov r5,#0
    stmfd sp!,{r9}

write_loop:
    cmp r5,r4
    beq end
    ldr r7,[r9]
    str r7,[r0]
    add r0,r0,#4
    add r9,r9,#4
    add r5,r5,#1
    b write_loop

end:
    sub r0,r0,r4,lsl #2
    ldmfd sp!,{r9}
    mov pc,lr


@ Compare strings in list. Push 'smaller' one into stack and move on. Once both lists have been iterated over, pop elements from the stack back into the list space
@ => A separate pointer list will have to be maintained for this. Also the size of the list will be needed to be remembered at all steps.
