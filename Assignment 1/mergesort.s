.extern merge
.global sort
@ r0 contains start of pointer list
@ r9 containse start of auxillary list
@ r2 contains case sensitivity
@ r4 contains size of the list
@ r6 contains duplicate removal option
sort:
    cmp r4,#1
    movle pc,lr
    stmfd sp!,{lr}
    mov r5,r4,lsr #1
    stmfd sp!,{r5}
    sub r4,r4,r5
    add r8,r0,r4,lsl #2
    stmfd sp!,{r8}
    bl sort @ 1st half of list:- Need to set parameters correctly
    ldmfd sp!,{r8}
    ldmfd sp!,{r5}
    stmfd sp!,{r0,r4}
    mov r0,r8
    mov r4,r5
    bl sort @ 2nd half of list:- Need to set parameters correctly
    stmfd sp!,{r0,r4}
    ldmfd sp!,{r1}
    ldmfd sp!,{r5}
    ldmfd sp!,{r0}
    ldmfd sp!,{r4}
    bl merge @ merge back:- Need to set parameters correctly
    ldmfd sp!,{lr}
    mov pc,lr