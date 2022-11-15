-- Interpretated Custom functions for this character
-- Functions do not actually exist this is just for reference



--[[
-- System functions
function mugen.roundstatetime()
  return mll.ReadInteger(mugen.getbaseaddress() + 0x12760)
end

-- Unused
function mugen.getroundstate() 
  return mll.ReadInteger(mugen.getbaseaddress() + 0x12754)
end

function mugen.setcollision(value)
  mll.WriteInteger(mugen.getbaseaddress() + 0x130DC, value)
end



-- Player functions
function player:sysvarincrement(VarIndex)
  NewValue = mll.ReadInteger(self:getplayeraddress() + 0x10AC + VarIndex * 4) + 1	  
  mll.WriteInteger(self:getplayeraddress() + 0x10AC + VarIndex * 4, NewValue)	  
end

function player:sysvarget(VarIndex)
  return mll.ReadInteger(self:getplayeraddress() + 0x10AC + VarIndex * 4)
end

function player:teamsideget()
  return mll.ReadInteger(self:getplayeraddress() + 0x0C)
end

function player:setacttime(value)
  mll.WriteInteger(self:getplayeraddress() + 0xf08, value)
end

function player:setcontrol(value)
  mll.WriteInteger(self:getplayeraddress() + 0xEE4, value)
end

function player:varadd(index, value)
  mll.ReadInteger(self:getplayeraddress() + 0xF1C + index * 4, value)
end

--]]