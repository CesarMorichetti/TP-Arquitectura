addi r1 r1 1
addi r2 r2 2
addi r3 r3 3
addi r4 r4 4
addi r5 r5 5
addi r11 r11 30
lui r6 1
sra r6 r6 16
add r7 r3 r1
sub r8 r4 r7
beq r8 r0 4
nop
nop
nop
nop
sw r6 0(r5)
add r1 r2 r12
add r3 r8 r13
lw r14 0(r5)
