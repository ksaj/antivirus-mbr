COMMENT ~=====================================================================
      PC Scavenger Anti-Virus Master Boot Record -- SOURCE CODE
             ------------------------------------------

              (c) 1993 Karsten Johansson, PC Scavenger

The PC Scavenger Anti-Virus Master Boot Record is a fully functional
Master Boot Record.  In addition to the standard diagnostics and
partition duties of the MBR, PC Scavenger will detect virtually ANY
virus infection in the MBR (Such as Stoned, Michelangelo, etc).

If no error is dectected, you can be quite sure an infection has not
taken place.

NOTE:  This program was only written to demonstrate how the MBR can
       be protected. Nothing has been added to keep the Boot Sector
       or executable files from being infected.

Instructions:
       Read PCSCAV.TXT for information

       To Compile:
                        TASM    PCSCAV.ASM
                        TLINK   PCSCAV.OBJ
                        EXE2BIN PCSCAV.EXE

                        DEL     PCSCAV.EXE
                        DEL     PCSCAV.MAP
                        DEL     PCSCAV.OBJ

=======================================================================~

AVPart          segment para stack
                assume  cs:AVPart,ds:AVPart,ss:AVPart

                org     0

KSAJ:
                cli                             ;Disable interrupts
                sub     ax,ax
                mov     ss,ax                   ;Ss at 0
                mov     sp,7C00h                ;Stack at boot
                mov     si,sp
                push    ax ax
                pop     es ds                   ;Es=ds=0
                sti                             ;Enable interupts

                cld
                mov     di,600h                 ;Buffer at 0:600
                mov     cx,100h
                repnz   movsw               ;Move entire MBR into buffer

                db      0EAh                       ;Jmp far
                dw      offset Second_Entry + 600h ; to Second_Entry
                dw      0                          ; at new location

Second_Entry:
                lea     si,(PC_Scav + 600h)     ;Display copyright
                call    Screen_Write
                lea     si,(Partn_Table1 + 600h)
                mov     bl,4                    ;4 possible partitions

Check_Partn:
                cmp     byte ptr [si],80h       ;Is it bootable?
                je      Save_Thing              ;If so, go for it
                cmp     byte ptr [si],0         ;Non-Bootable partition?
                jne     Bad_Partn         ;Not a proper partition entry!
                add     si,10h                  ;Point to next partition
                dec     bl                      ;Lower counter
                je      Bad_Partn               ;Bail out if counter = 0
                jmp     short Check_Partn    ;Otherwise,check next table

Save_Thing:
                mov     dx,word ptr [si]    ;Save Partition Start-Head
                mov     cx,word ptr [si+2]  ;Save Partition Start-Sector
                mov     bp,si

Partn_Byte:
                add     si,10h              ;Go to next partition
                dec     bl                  ;Remember where we are
                je      Check_Boot          ;If all are checked, move on
                cmp     byte ptr [si],0
                je      Partn_Byte

Bad_Partn:
                lea     si,(Bad_PT + 600h)    ;Write Bad Partition error
                call    Screen_Write
                jmp     short $               ;hang computer

Check_Boot:
                mov     di,5                  ;Try reading up to 5 times

Read_Boot:
                mov     bx,7C00h                ;Read in the boot sector
                mov     ax,201h                 ; from active partition
                push    di
                int     13h
                pop     di
                jnb     BS_There                ;Continue if read OK
                xor     ax,ax
                int     13h                     ;Reset disk
                dec     di                      ;Decrease read counter
                jne     Read_Boot           ;Try again if counter allows

Do_Error:
                lea     si,(Error + 600h)
                call    Screen_Write
                jmp     short $

BS_There:
                mov     ax,word ptr ds:413h     ;Get BIOS memory count
                cmp     ax,640d                 ;640K memory?
                lea     si,(MEM_Bad + 600h)
                jb      Fail_Msg                ;Fail if less memory
                db      0C4h,6,4Ch,0            ;LES AX,DWORD 13h * 4
                mov     bx,es                   ;Check if INT 13h moved
                mov     cl,4
                shr     ax,cl                 ;Divide by 16 (Paragraphs)
                add     ax,bx
                jnb     Boot_Disk               ;Everything seems fine!

                lea     si,(Bad_INT13 + 600h)   ;Int 13h moved!

Fail_Msg:
                push    ax
                call    Screen_Write            ;Inform user of fault
                lea     si,(Fail + 600h)
                call    Screen_Write            ;Prompt for boot/hang
                sub     ah,ah
                int     16h                     ;Get reply to prompt
                or      al,20h                  ;Lower case reply
                cmp     al,'y'                  ;Yes?
                jne     $                      ;If not Yes, hang machine
                pop     ax

Boot_Disk:
                mov     di,7DFEh                ;Does end of boot sector
                cmp     word ptr [di],0AA55h    ; contain proper ID?
                jne     Do_Error

                mov     si,bp
                db      0EAh                    ;Jmp far
                dw      7C00h                   ; to boot sector code
                dw      0

Screen_Write:
                lodsb                           ;Get a byte
                cmp     al,0                    ;Is it 0?
                je      Done_Writing            ;Stop writing
                push    si
                mov     bx,7                    ;"7" to avoid being
                                                ;scanned as STONED virus
                mov     ah,0Eh                ;Write character to screen
                int     10h
                pop     si
                jmp     short Screen_Write      ;Get another character

Done_writing:
                ret

;--- Data -------------------------------------------------

PC_Scav         db  'PC SCAVENGER Anti-Virus Master Boot Record',0Dh,0Ah
                db  '(c)1993 Karsten Johansson',0Dh,0Ah,0Ah,0

Bad_PT          db      'Partition Table bad...',0

Error           db      'OS Error',0

MEM_Bad         db      'Memory has shrunk!',0

Bad_INT13       db      'INT 13h Moved!',0

Fail            db      0Dh,0Ah,'Boot anyway?',0Dh,0Ah,0Ah,0

;--- Following reserved for Partition Tables only! --------

                org     1BEh
Partn_Table1:
                db      ?

                org     1CEh
Partn_Table2    db      ?

                org     1DEh
Partn_Table3    db      ?

                org     1EEh
Partn_Table4    db      ?

                org     1FEh
                db      55h,0AAh

AVPart          ends
                end     KSAJ

