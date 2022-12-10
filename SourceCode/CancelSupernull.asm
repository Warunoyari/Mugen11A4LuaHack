[bits 32]

;; Using ECX >>> ECX is set when returning.
.BackupRegisters:
  mov ecx,[0x5040E8]
  add ecx,0x82C
  mov [ecx],ebx
  mov [ecx+0x04],eax
  mov [ecx+0x08],edx
  mov [ecx+0x0C],esi
  mov [ecx+0x10],edi
  mov [ecx+0x14],ebp
  mov [ecx+0x18],esp
  
.OverwritePath:
  ;; ESI is CharPath
  ;; Mandated Path = "st = xxxxxx.cns"
  ;; Therefore, let's overwrite starting from the 5th byte, and load a dummy file (with null terminator)
  mov ecx,esi
  ;; Auto?
  ;; add ecx,0x04
  ;; DEF<null>
  mov dword [ecx],0x00464544
  
  
  
;; -- 00435AE9 - 0F84 18FCFFFF         - je 00435707
  
.RestoreJumpPoint:
  ;; Revert the jump to this file to original code.
  mov ecx,0x435AE9
  mov byte [ecx+0],0x0F
  mov byte [ecx+1],0x84
  mov byte [ecx+2],0x18
  mov byte [ecx+3],0xFC
  mov byte [ecx+4],0xFF
  mov byte [ecx+5],0xFF  

.ReturnProcedure:
;; Jumping ECX as it is overwritten  
  mov ecx,0x00435AEF
  jmp ecx 