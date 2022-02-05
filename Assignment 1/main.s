.extern sort
.global main
main:
    mov r0,#1
    ldr r1,=sensitivity
    swi 0x69
    mov r0,#0
    swi 0x6c
    stmfd sp!,{r0}
    mov r0,#1
    ldr r1,=duplicates
    swi 0x69
    mov r0,#0
    swi 0x6c
    stmfd sp!,{r0}
    mov r0,#1
    ldr r1,=size_prompt
    swi 0x69
    mov r0,#0
    swi 0x6c
    mov r4,r0
    mov r0,#1
    ldr r1,=list_prompt
    swi 0x69
    mov r0,#0
    ldr r1,=string_space
    mov r2,#104
    ldr r3,=pointer_list_space
    mov r5,#0
    bl enter_list
    ldmfd sp!,{r6}
    ldmfd sp!,{r2}
    ldr r0,=pointer_list_space
    ldr r9,=auxillary_space
    bl sort
    mov r0,#1
    ldr r1,=final_size
    swi 0x69
    mov r0,#1
    mov r1,r4
    swi 0x6b
    mov r0,#0
    ldr r1,=final_list
    swi 0x69
    mov r5,#0
    mov r0,#1
    ldr r3,=pointer_list_space
    ldr r1,[r3]
    bl print_list
    swi 0x11

enter_list:
    cmp r4,r5
    moveq pc,lr
    swi 0x6a
    mov r0,#0
    str r1,[r3]
    add r1,r1,#104
    add r3,r3,#4
    add r5,r5,#1
    b enter_list

print_list:
    cmp r5,r4
    moveq pc,lr
    swi 0x69
    mov r0,#1
    ldr r1,=new_line
    swi 0x69
    add r3,r3,#4
    ldr r1,[r3]
    add r5,r5,#1
    b print_list

.data
    sensitivity:
        .asciz "Enter 0 for case sensitivity and 1 for case insensitivity: "
    duplicates:
        .asciz "Enter 0 to remove duplicates and 1 to keep duplicates: "
    size_prompt:
        .asciz "Enter the size of the list (Max size 100): "
    list_prompt:
        .asciz "Enter the strings in the list: (Each string should have a maximum length of 100)\n"
    final_size:
        .asciz "The final size of the list is: "
    final_list:
        .asciz "\nThe final sorted list is:\n"
    new_line:
        .asciz "\n"
        .align 2
    string_space:
        .space 10400
        .align 2
    pointer_list_space:
        .space 400
        .align 2
    auxillary_space:
        .space 400
    