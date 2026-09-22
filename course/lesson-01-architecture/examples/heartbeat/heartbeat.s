#include "../../../common/msp430g2553-defs.s"

;==============================================================================
; heartbeat.s — Lesson 01 example (second worked example)
;
; Same toolbox as ../blink.s, no new instructions or concepts: LED1 gives
; two quick pulses then a longer pause, like a heartbeat, repeating forever.
; The point of a second example here isn't a new idea — it's seeing the same
; four setup instructions and the same delay routine reused to compose a
; multi-segment pattern instead of one on/off pair.
;==============================================================================

.equ    DELAY_MS_ITERS, 333     ; inner-loop iterations ≈ 1 ms at 1 MHz (see tutorial-01)
.equ    PULSE_ON_MS,    100     ; each quick pulse: 100 ms on
.equ    PULSE_OFF_MS,   100     ; gap between the two pulses
.equ    PAUSE_MS,       600     ; pause before the next heartbeat

    .text
    .global _start

_start:
    mov.w   #0x0400, SP                 ; init stack pointer (top of RAM)
    mov.w   #(WDTPW|WDTHOLD), &WDTCTL  ; disable watchdog — always second
    clr.b   &DCOCTL
    mov.b   &CALBC1_1MHZ, &BCSCTL1     ; calibrate DCO to 1 MHz
    mov.b   &CALDCO_1MHZ, &DCOCTL

    bis.b   #LED1, &P1DIR                ; P1.0 = output
    bic.b   #LED1, &P1OUT                ; start with LED1 off

;==============================================================================
; main_loop
; How it works: pulse LED1 twice quickly, then pause, then repeat.
;==============================================================================
main_loop:
    bis.b   #LED1, &P1OUT               ; pulse 1 on
    mov.w   #PULSE_ON_MS, R12
    call    #.Ldelay_ms
    bic.b   #LED1, &P1OUT               ; pulse 1 off
    mov.w   #PULSE_OFF_MS, R12
    call    #.Ldelay_ms

    bis.b   #LED1, &P1OUT               ; pulse 2 on
    mov.w   #PULSE_ON_MS, R12
    call    #.Ldelay_ms
    bic.b   #LED1, &P1OUT               ; pulse 2 off

    mov.w   #PAUSE_MS, R12              ; pause before next heartbeat
    call    #.Ldelay_ms
    jmp     main_loop

;==============================================================================
; .Ldelay_ms
; How it works: busy-wait for approximately R12 milliseconds at 1 MHz.
;   Input:    R12 = number of milliseconds to wait
;   Clobbers: R12, R13
;==============================================================================
.Ldelay_ms:
    mov.w   #DELAY_MS_ITERS, R13    ; reload inner-loop counter
.Ltms_loop:
    dec.w   R13                     ; one cycle
    jnz     .Ltms_loop              ; two cycles
    dec.w   R12                     ; one ms elapsed
    jnz     .Ldelay_ms              ; more ms to wait? loop again
    ret                             ; done — return to caller

    .section ".vectors","ax",@progbits
    .word   0,0,0,0, 0,0,0,0           ; 0xFFE0–0xFFEF  unused
    .word   0,0,0,0, 0,0,0             ; 0xFFF0–0xFFFC  unused
    .word   _start                      ; 0xFFFE  Reset
    .end
