; This assembly file executes every RISC240 instruction.
; Conditional branches execute in a taken and a not-taken version
; Intended as a smoke test harness for any changes to sim240

; Compile with as240 test_all_commands.asm
; Simulate with: sim240 -t test_all_commands.trans test_all_commands.list
; Then PC=100
; Then r 7 (to see all the starting register values)
; Then r   (run until the stop)
; Then m[200:20B]?  (to see the data memory)
; Then Q  (Quit)
; Compare the transcript to test_all_commands_Compare.trans


  .ORG $100
START   LI   r1, $0001
        LI   r2, $0002
        LI   r3, $FFFF
        LW   r4, r0, DATA
        LW   r5, r2, DATA
        LW   r6, r4, DATA4
        LW   r7, r0, DATA4
        
        ; Register values should be 0: 1, 2, -1, -2, $FF00, $19, $87
        
        BRC  DATA  ; Should not be taken
        BRV  DATA  ; Should not be taken
        BRN  DATA  ; Should not be taken
        BRZ  DATA  ; Should not be taken
        BRNZ DATA  ; Should not be taken
        
        ADD  r1, r2, r5
        ADDI r4, r5, $1987
        AND  r2, r5, r4
        MV   r3, r2
        NOT  r5, r6
        SLLI r6, r6, $08
        OR   r6, r7, r6
        SLL  r7, r1, r1
        SLT  r2, r6, r2
        SLTI r3, r5, $07
        SRA  r4, r4, r4
        SRAI r5, r5, $01
        SRL  r6, r4, r4
        SRLI r7, r1, $06
        SUB  r6, r5, r4
        SW   r0, r7, DEST
        XOR  r6, r1, r6

        BRA  TGT1
        STOP               ; Never executed
TGT1    LI   r1, $FFFF
        BRN  TGT2          ; Always taken
        STOP               ; Never executed
TGT2    ADDI r0, r1, $03
        BRC  TGT3          ; Always taken
        STOP               ; Never executed
TGT3    ADD  r0, r0, r0
        BRNZ TGT4          ; Always taken (zero)
        STOP               ; Never executed
TGT4    LI   r1, $FFFF
        BRNZ TGT5          ; Always taken (negative)
        STOP               ; Never executed
TGT5    LI   r1, $7FFF     ; large positive
        ADDI r1, r1, $0003 ; Causes overflow
        BRV  TGT6          ; Always taken
        STOP               ; Never executed
TGT6    ADD  r0, r0, r0
        BRZ  TGT7          ; Always taken
        STOP               ; Never executed
     
TGT7    SW   r0, r0, DEST2
        STOP
     
        .ORG $200
DATA    .DW  $FFFE
        .DW  $FF00
        .DW  $19
DATA4   .DW  $87
DEST    .DW  $00   ; Will be overwritten
DEST2   .DW  $FFFF ; Will be overwritten be a zero