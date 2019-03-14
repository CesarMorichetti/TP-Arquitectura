addi r1 r0 1
addi r2 r0 2
addi r3 r0 3
addi r4 r0 10
sub r5 r3 r4
sb r5 0(r2)
or r6 r2 r1
and r7 r2 r1
slt r8 r7 r6
beq r1 r8 4 
add r12 r10 r1
add r12 r10 r1
add r12 r10 r1
add r12 r10 r1
lw r10 0(r2)
add r13 r10 r1
halt
