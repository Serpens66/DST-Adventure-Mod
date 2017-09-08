
local RememberStuff = Class(function(self, inst)
	self.inst = inst
	self.stuff1 = {}
	self.stuff2 = {}
	self.stuff3 = {}
	self.stuff4 = {}
	self.stuff5 = {}
	self.stuff6 = {}
	self.stuff7 = {}
	self.stuff8 = {}
	self.stuff9 = {}
	self.stuff10 = {}
end)


function RememberStuff:OnSave() -- thx DarkXero for help how to save/load entities properly!
	local data = {}
	local stuff_references = {}
    local data_stuff = nil
    local self_stuff = nil
	for i = 1, 10 do
		data_stuff = {}
		self_stuff = self["stuff"..i]

		for key, thing in pairs(self_stuff) do
			if type(thing) == "table" and thing.GUID then
				-- we need to pass the GUID references to the game
				table.insert(stuff_references, thing.GUID)
				-- save a table with flag and GUID where entity should be
                data_stuff[key] = { is_GUID = true, GUID = thing.GUID }
			else
                data_stuff[key] = thing
			end
		end

		data["stuff"..i] = data_stuff
	end

	if next(stuff_references) == nil then
		-- if stuff_references is empty, make it nil
		stuff_references = nil
	end
	return data, stuff_references
end

function RememberStuff:OnLoad(data)
	self.stuff1 = data and data.stuff1 or {}
	self.stuff2 = data and data.stuff2 or {}
	self.stuff3 = data and data.stuff3 or {}
	self.stuff4 = data and data.stuff4 or {}
	self.stuff5 = data and data.stuff5 or {}
	self.stuff6 = data and data.stuff6 or {}
	self.stuff7 = data and data.stuff7 or {}
	self.stuff8 = data and data.stuff8 or {}
	self.stuff9 = data and data.stuff9 or {}
	self.stuff10 = data and data.stuff10 or {}
end

function RememberStuff:LoadPostPass(newents, data)
	-- OnLoad runs before LoadPostPass
	-- we saved GUIDs in data
	-- therefore, stuff1 loaded the tables with { is_GUID, GUID } where there should be an entity instead
	-- therefore, we just need to swap
	for i = 1, 10 do
		local self_stuff = self["stuff"..i]

		for key, thing in pairs(self_stuff) do
			if type(thing) == "table" then
				if thing.is_GUID then
					local thingy = newents[thing.GUID]
					if thingy then
						-- swap temp table for entity
						self_stuff[key] = thingy.entity
					end
				end
			end
		end
	end
end

return RememberStuff
