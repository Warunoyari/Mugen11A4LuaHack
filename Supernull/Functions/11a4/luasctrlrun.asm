;; EAX=sctrl ID, EDI=sctrl content
;; 1.1a4: entry point = 0x0044BBAD
[bits 32]

;; Area References
  dd .AddressData
  dd .StringData

;; preserve the sctrl ID
push eax
;; put our character's ID into a Lua global variable
mov ecx,dword [ebp+4]
push ecx
mov ecx, dword [0x005040FC]
push ecx
mov ecx,0x004C4FD0 ;; lua_pushinteger(L, ID)
call ecx 
add esp,0x08
.CharID_RewriteString:
  push charid
push -10002
mov ecx, dword [0x005040FC]
push ecx
mov ecx, 0x004C5460 ;; lua_setfield(L, LUA_GLOBALSINDEX, "charID")
call ecx
add esp,0x0C

;; restore the sctrl ID
pop eax

;; handle custom elems
cmp eax,0x161
je .lua_asstring
cmp eax,0x162
je .lua_asfile

;; invalid elem
push 0x004F8790
mov eax,0x0044BBB2
jmp eax

.lua_asstring:
;; get the string to be executed
mov eax,dword [edi + 0x60]
lea eax,dword [eax + 0x38]
;; call the string loading function
push eax
mov ecx,dword [0x005040FC]
push ecx
.LuaLoadString_WriteLoc:
  mov ecx, 0x004C64A0 ;; luaL_loadstring -- label for consistency in files
call ecx
add esp,0x08
test eax,eax
jnz .error

;; call the execution function
mov ecx,dword [0x005040FC]
push 0
push 0
push 0
push ecx
mov ecx, 0x004C5740 ;; lua_pcall
call ecx
;; cleanup+test for errors
add esp,0x10
test eax,eax
jnz .error

jmp .done

.lua_asfile:
;; get the path to be executed
mov eax,dword [edi + 0x60]
lea eax,dword [eax + 0x38]

;; check if the player has been custom stated
;; read the stateowner index, which will be -1 if not custom stated
mov ecx, dword [ebp + 0xCB8]
cmp ecx, -1
je .not_custom_stated
;; read the info pointer of the state owner
mov edx, dword [0x5040E8]
;; Custom State Fix
mov ecx, dword [ebp + 0x08]
lea edx, dword [edx + 0x12274 + ecx * 0x04]
mov edx, dword [edx]
mov ecx, dword [edx]
push ecx
jmp .read_folder

.not_custom_stated:
push dword [ebp]
mov ecx, dword [ebp]

.read_folder:
;; fetch the character folder string
mov ecx, dword [ecx+0xB0]
xor esi,esi
;; copy the input string to the character folder string
.loopfindend:
cmp byte [ecx], 0x00
je .loopfindenddone
inc ecx
inc esi
jmp .loopfindend

.loopfindenddone:
;; eax points at the file to be loaded
.loopcopy:
mov dl, byte [eax]
mov byte [ecx], dl
inc eax
inc ecx
cmp byte [eax], 0x00
je .loopcopydone
jmp .loopcopy

.loopcopydone:
mov byte [ecx], 0x00
;; call the file loading function
pop ecx
mov ecx, dword [ecx+0xB0]
push ecx
mov ecx,dword [0x005040FC]
push ecx
mov ecx, 0x004C6250 ;; luaL_loadfile
call ecx
;; cleanup+test for errors
lea ecx,[esp+0x04]
mov ecx, dword [ecx]
add ecx, esi
mov byte [ecx], 0x00
add esp,0x08
test eax,eax
jnz .error

;; call the execution function
mov ecx,dword [0x005040FC]
push 0
push 0
push 0
push ecx
mov ecx, 0x004C5740 ;; lua_pcall
call ecx
;; cleanup+test for errors
add esp,0x10
test eax,eax
jnz .error

jmp .done

.error:
push 0x00
push -1
mov ecx,dword [0x005040FC]
push ecx
mov ecx, 0x004C4DC0 ;; lua_tolstring
call ecx
add esp,0x0C
push eax
mov eax,dword [edi + 0x60]
lea eax,[eax + 0x38]
push eax
.ErrorExecute_RewriteString:
  push errmsg
mov ecx, 0x0040C710 ;; mugen error handler (clipboard print)
call ecx
add esp,0x0C

.done:
mov eax,0x0044B7DA
jmp eax

;; Areas for Writing
.AddressData: 
  dd .CharID_RewriteString
  dd .ErrorExecute_RewriteString
  dd .LuaLoadString_WriteLoc

;; Strings for Loading
.StringData:
  dd .CurrCharacterIDString
  dd .ErrorExecuteString
  dd .LuaLoadString

.CurrCharacterIDString:
  db "CurrCharacterID", 0x00
.ErrorExecuteString:
  db "Error while executing Lua from %s: %s.", 0x0D, 0x0A, 0x00
.LuaLoadString:
  db "DONOTREMOVE"

charid db "CurrCharacterID", 0x00  
errmsg db "Error while executing Lua from %s: %s.", 0x0D, 0x0A, 0x00