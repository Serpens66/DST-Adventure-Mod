
local function GiveStuff(inst,fn,self,name,...)
    -- print("HIER startstuff comp, GiveStuff, for "..tostring(self.inst).." : "..tostring(self.done[name]))
    if fn~=nil and not self.done[name] then -- put the done thing here, cause without the DoTask dealy (can also be 0), this might be called before OnLoad
        self.done[name] = true -- should be before the function is run, to make it possible to set done to false in this function
        fn(inst,...)
    else
        self.done[name] = true
    end
end

local StartStuff = Class(function(self, inst)
	self.inst = inst
	self.done = {} -- self.done["thisthat"] == false/true
    -- print("component startstuff for "..tostring(self.inst).." created")
end)

function StartStuff:GiveStartStuffIn(x,fn,name,...) -- to run a function only once per inst
    self.inst:DoTaskInTime(x, GiveStuff, fn, self,name,...)
end

function StartStuff:OnSave()
	return { done = self.done }
end

function StartStuff:OnLoad(data)
	self.done = data and data.done or {}
end


return StartStuff
