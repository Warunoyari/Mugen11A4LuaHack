# Mugen11A4LuaHack

A custom exe hack for Mugen 1.1A4 to achieve higher stability for the LUA ROP  
It no longer depends on any DLLs.  

### Usage 
Import StreamElua, StreamElua2, and LoadLua11A4.bin in your character folder  
**Must be same location as Def file (No guarantees if you place DEF file in weird location.)**  
Copy/Paste or Merge Supernull with existing Supernull folders (This uses my edits with Label Pointers for ASM file editing)  
**The original elua file with pointers is included for reference**  
*LoadLua11A4.asm and LuaDoFile are for source code thus not required.*  
*You are not required to load any files from the character def*

### New
Added a mechanism to load a dummy file (DEF<null>) when using custom exe  
This means you can now load St = supernull.st by default for maximum compatibility.  
Please keep in mind that you should keep the code in the normal Elua file and your StreamElua/2 file as similar as possible.

### Details  
StreamElua sets up the code to run StreamElua2  
This file is for setting up the character path from the info pointer required to use LuaFile  
It is also the recommended place to put custom code  
You are free to put custom code in the first file as well, though not recommended
