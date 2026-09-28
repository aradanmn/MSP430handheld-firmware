#include "../../../common/msp430g2553-defs.s"

;==============================================================================
; forgot_wdthold.s — Lesson 01 example
;
; Illustrates tutorial-01's "Worked Scenario: What Happens If You Forget
; WDTHOLD?" directly on hardware, instead of only reading about it.
;
; This file is identical to blink.s's setup except for one missing
; instruction: the WDTHOLD write. Every other example in this course holds
; the watchdog as its very first real action — this one deliberately
; doesn't, so you can watch the symptom the tutorial describes: the chip
; never reaches a stable state. LED1 will look dim, flickering, or
; erratic — never a clean, steady-on light — because the unheld watchdog
; keeps resetting the chip (back to _start) on its own short default
; interval, before your code ever finishes settling into main_loop. See
; SLAU144 Ch. 3 for the WDT+ module's exact default configuration at
; power-up.
;
; DO NOT copy this omission into real code. Flash this once to see the
; effect, then move on — every other _start in this course begins with
; WDTHOLD for exactly this reason.
;==============================================================================

    .text
    .global _start

_start:
    mov.w   #0x0400, SP                 ; init stack pointer (top of RAM)
    ; --- WDTHOLD intentionally omitted here ---
    ; mov.w #(WDTPW|WDTHOLD), &WDTCTL   <- every other example has this line
    clr.b   &DCOCTL
    mov.b   &CALBC1_1MHZ, &BCSCTL1     ; calibrate DCO to 1 MHz
    mov.b   &CALDCO_1MHZ, &DCOCTL

    bis.b   #LED1, &P1DIR                ; P1.0 = output
    bis.b   #LED1, &P1OUT                ; try to turn LED1 on...

.Lspin:
    jmp     .Lspin                       ; ...and just sit here. You won't
                                          ; stay here long — the unheld
                                          ; watchdog resets the chip back
                                          ; to _start before this loop ever
                                          ; "matters."

    .section ".vectors","ax",@progbits
    .word   0,0,0,0, 0,0,0,0           ; 0xFFE0–0xFFEF  unused
    .word   0,0,0,0, 0,0,0             ; 0xFFF0–0xFFFC  unused
    .word   _start                      ; 0xFFFE  Reset
    .end
