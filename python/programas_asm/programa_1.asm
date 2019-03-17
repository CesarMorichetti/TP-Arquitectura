addi r1 r0 1
addi r2 r0 2
addi r3 r0 3
addi r4 r0 4
addi r5 r0 5
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
halt
