

p1size  equ     p1end-p1load
p1padd  equ     pagsize-p1size
p1sizeT equ     p1endf-p1load


section code
        org     p1load

        db      'AB'
        dw      Init
        dw      0,0,0,0,0,0,0,0


LoadMazeRJ:
        jp      LoadMazeR
RamSlotPage0J:
        jp      RamSlotPage0
RamSlotPage1J:
        jp      RamSlotPage1
RamSlotPage2J:
        jp      RamSlotPage2


Rg9Sav_:       equ   0ffe8h

Init:
        ld      sp,0f660h

        call    SaveSlotC
        call    searchramnormal
	call 	InitBasePorts
        call    SetIntroPages
        ld    	a,7
	call 	SNSMAT
	and     040h
        ld      a,(Rg9Sav_)
        jr      nz,.60Hz

	and     0fdh
	ld      (Rg9Sav_),a
	out     (99h),a
	ld      a,128+9
	out     (99h),a
        xor     a
	ld      (0FFFCh),a
	jr      .intro

.60Hz:
        or      2
	ld      (Rg9Sav_),a
	out     (99h),a
	ld      a,128+9
	out     (99h),a
	ld      (0FFFCh),a
	jr      .intro



.intro:
        call    StartLogo
        call    ShowIntro
	or      a
	jr      z,.intro

        call    SetBloadPages
        call    LoadFirstBload
        call    SetBloadPages
        call    LoadSecondBload
        ret

        db    "Made by TNI 2012"

%include "sys.asm"
%include "gaunt1.asm"
%include "aamsx.asm"

musicpt3:
	incbin "gauntlet.pt3"


section         code

p1end:  ds      p1padd,0
p1endf:         equ $

%if p1size > pagsize
   %warn "Page 0 boundary broken"
%endif
