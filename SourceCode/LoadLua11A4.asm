[bits 32]

;; Using ECX instead of eax this time as ECX is set when returning.
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
  
.StoreInfoPointer:
  ;; ESP + 0x14 Info Pointer >> [5040E8]+A78 
  mov eax,[0x5040E8]
  add eax,0xA78
  ;; ESP+0x14 to EBX
  mov ebx,esp
  add ebx,0x14
  mov ebx,[ebx]
  ;;  
  mov [eax],ebx

;; mugen.exe+358CA - 80 7C 24 30 00        - cmp byte ptr [esp+30],00
;; >>> mugen.exe+358CF - 0F84 32FEFFFF         - je mugen.exe+35707
;; <<< mugen.exe+358D5 - 8B CE                 - mov ecx,esi
;; mugen.exe+358D7 - 51                    - push ecx
;; mugen.exe+358D8 - 68 806A4F00           - push mugen.exe+F6A80
  
.RestoreJumpPoint:
  ;; Revert the jump to this file to original code.
  mov ecx,0x4358CF
  mov byte [ecx+0],0x0F
  mov byte [ecx+1],0x84
  mov byte [ecx+2],0x32
  mov byte [ecx+3],0xFE
  mov byte [ecx+4],0xFF
  mov byte [ecx+5],0xFF  

.FindNullTerminator:
  ;; Path Start
  mov ebx,[0x5040E8]
  add ebx,0x00000848
  ;; Value
.FindNullTerminator_Loop:
  mov ecx,[ebx]
  and ecx,0x000000FF
  ;; Increase address (auto)
  inc ebx
  cmp ecx,0x00
  jne .FindNullTerminator_Loop
  ;; Finished - Write 2 to end of file
  mov byte [ebx-1],0x32
 
.CallLuaFile:
;;Push ESI ESP+0x0C?
  mov esi,esp
  add esi,0x0C
;;StreamElua2 File Pointer
  mov eax,[0x5040E8]
  add eax,0x00000848
;;Call (1040FC handled by function)
;;Calling ECX as ECX is overwritten anyway.
  mov ecx,0x42DEA0
  call ecx
  
;; This is after StreamElua2 processing.  
  
.RestoreRegisters:
  mov ecx,[0x5040E8]
  add ecx,0x0000082C
  mov ebx,[ecx]
  ;; ECX >> EAX Swap
  mov eax,[ecx+0x04]
  mov edx,[ecx+0x08]
  mov esi,[ecx+0x0C]
  mov edi,[ecx+0x10]
  mov ebp,[ecx+0x14]  
;; Jumping ECX as it is overwritten  
  mov ecx,0x004358D5
  jmp ecx
  
;; mugen.exe+358CA - 80 7C 24 30 00        - cmp byte ptr [esp+30],00
;; >>> mugen.exe+358CF - 0F84 32FEFFFF         - je mugen.exe+35707
;; <<< mugen.exe+358D5 - 8B CE                 - mov ecx,esi
;; mugen.exe+358D7 - 51                    - push ecx
;; mugen.exe+358D8 - 68 806A4F00           - push mugen.exe+F6A80
