# Mugen11A4LuaHack

A custom exe hack for Mugen 1.1A4 to achieve higher stability for the LUA ROP  
It no longer depends on any DLLs.  

How to Import:  
Put StreamElua, StreamElua2, and LoadLua11A4.bin in your character folder  
Copy/Paste or Merge Supernull with existing Supernull folders (This uses my edits with Label Pointers for ASM file editing)  
**Must be same location as Def file (No guarantees if you place DEF file in weird location.)**  
*LoadLua11A4.asm and LuaDoFile are for source code thus not required.*  
*The original elua file with pointers is included for reference*  
*You are not required to load any files from the character def*
*It is strongly encouraged not to load supernull.st from old ROP*


StreamElua sets up the code to run StreamElua2  
This file is for setting up the info pointer required to use LuaFile and also for custom code  
You are free to put custom code in the first file as well but it is not recommended.  
It is significantly easier to reference PalNo in File 2 context, for reference.
