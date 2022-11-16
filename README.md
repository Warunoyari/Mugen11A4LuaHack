# Mugen11A4LuaHack

A custom exe hack for Mugen 1.1A4 to achieve higher stability for the LUA ROP  
It no longer depends on any DLLs.  

### Usage 
Import StreamElua, StreamElua2, and LoadLua11A4.bin in your character folder  
Copy/Paste or Merge Supernull with existing Supernull folders (This uses my edits with Label Pointers for ASM file editing)  
**The original elua file with pointers is included for reference**  
*LoadLua11A4.asm and LuaDoFile are for source code thus not required.*  
*You are not required to load any files from the character def*  

### Warnings
**Must be same location as Def file (No guarantees if you place DEF file in weird location.)**  
*It is strongly encouraged not to load supernull.st from old ROP while using this EXE*  

### Details  
StreamElua sets up the code to run StreamElua2  
This file is for setting up the character path from the info pointer required to use LuaFile  
It is also the recommended place to put custom code  
You are free to put custom code in the first file as well, though not recommended  
It is significantly easier to reference PalNo in File 2 context, for reference.
