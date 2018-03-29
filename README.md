# antivirus-mbr
Antivirus boot sector for MSDOS (including Linux emulators and VMs). The original DOS boot record was pretty lame and filled with junk that didn't really do anything. I removed that junk and replaced it with code that ensures the mbr is legit, and that a virus hasn't loaded before it got a chance to load.

I wrote this back in 1993. Retro gaming and whatnot is becoming popular under Linux, and especially on Raspberry Pi, which prompted me to ressurrect this code in the likelihood that sooner or later people will start dusting off the old PC virus collections and playing around with them again.

Here is the original README.TXT that explains how it works. It has been modified for markdown language since the original text indentation wreaks havok with legibility on github, but otherwise is exactly as written back then. Note that the email address is no longer, so don't bother writing to it. 

The source code is written in Assembler, and is heavily documented so it should be fairly trivial to figure out how it works.

---

# PC SCAVENGER Anti-Virus Master Boot Record


(c)1993 Karsten Johansson, PC Scavenger   INET: ksaj@pcsav.com



## NOTE:
PC Scavenger is FREEWARE to private users.  IE:  It may NOT be used commercially unless by explicit written permission from the author. PC Scavenger may not be altered in any way.  Do NOT distribute without this text file.



## What is PC Scavenger?

PC Scavenger is a replacement MBR for PC's.  Prior to booting the computer, PC Scavenger runs several diagnostics, looking for signs of a virus in the MBR.  (ie:  viruses like Stoned or Michelangelo).

Because PC Scavenger is FreeWare, you will not be prompted to "Press a key to continue..." or any other annoying reminders for
payment.



## What are the signs PC Scavenger looks for?


1.)  Partition Table validity

Some viruses alter the partition table.  PC Scavenger will warn you of an invalid partition table.

2.)  System memory drop

MBR viruses usually lower the amount of memory available for system use.

3.)  Interrupt 13h location

If a virus was written to act as a TSR, it must "trap" an interrupt so it can be executed later.  Prior to booting, the only interrupt useful for this is Interrupt 13h. (Int 21h is the other common interrupt for viruses to trap, but at boot time, it is non-existant, and therefore not a threat.)

4.)  End of Boot Sector Marker

Most Boot sector viruses will overwrite this marker. If it isn't there, that is a very suspicious thing indeed!  In this case, PC Scavenger will not give you the "Boot Anyway?" prompt...it will just hang the system with an "OS Error". Use the rescue diskette to repair the damage.

If PC Scavenger boots your system without warning you of a potential problem, then chances are you are safe.  At this time, PC Scavenger will detect ALL of the Boot Sector/MBR viruses listed in Patti Hoffman's extensive virus database (VSUM, May 1993).




## Will PC Scavenger interfere with my other software?

No. PC Scavenger is not a TSR. Once it passes control to the system, it is completely removed from memory.



## What do I do if PC Scavenger detects a virus?

When you install PC Scavenger, you should make a bootable rescue diskette with the following files:

          COMMAND.COM   ;automatically added with FORMAT/S 
          SYS.COM       ;from your DOS or MSDOS directory
          FDISK.COM     ;from your DOS or MSDOS directory
          PCSCAV.COM    ;the PC Scavenger install/restore utility
          PCSCAV.BIN    ;the PC Scavenger replacement partition
          PARTN.BIN     ;generated when you install PC Scavenger.  It is
                        ;your original Master Boot Record

This diskette is all you need for ANY boot sector/MBR virus. (Even if PC Scavenger somehow missed it!).  Note that you must have a different emergency diskette for each system being protected. Mark these diskettes carefully!

## NOTE:

Write protect the rescue diskette as soon as PC Scavenger is installed on your system!  Only remove the write protect tab if you have changed your partition, and wish to re-install PC Scavenger.

## What to do:

1.)  Don't panic!  This is easy.
2.)  Boot from the emergency diskette.
3.)  Type "SYS C:" to write a new boot sector
4.)  Type "FDISK/MBR" to write a fresh MBR
5.)  Type "PCSCAV", and choose (I)nstall to re-install
     PC Scavenger on the system

It's as simple as that.  Your system will now be clean again, and safe to reboot.

NOTE:  If your system will not boot after cleaning a virus attack, it is most likely because the virus has destroyed the partition table.  To restore it, boot off the emergency diskette, then run PCSCAV.COM.  Choose the (R)estore option to repair the original partition table.  Run PCSCAV.COM again, and choose the (I)nstall option to set PC Scavenger back up.

If it still does not work, the virus probably has destroyed the file structure in some way (ie: format or delete sectors). In this case, you will need to Restore your backups.  It is very rare that a virus will damage the system the moment it is infected.

## WARNING:  

ONLY use (R)estore if your partition table has been destroyed!  Improper use may cause undue damage to your system.
