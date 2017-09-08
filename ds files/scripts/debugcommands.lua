function d_encodedata(path)
	print("ENCODING",path)
	TheSim:GetPersistentString(path, function(load_success, str)
		if load_success then
			print("LOADED...")
			local success, savedata = RunInSandbox(str)
			local str = DataDumper(savedata, nil, true)
			TheSim:SetPersistentString(path.."_encoded", str, true, function()
				print("SAVED!")
			end)
		else
			print("ERROR LOADING FILE! (wrong path?)")
		end
	end)
end

function d_decodedata(path)
	print("DECODING",path)
	TheSim:GetPersistentString(path, function(load_success, str)
		if load_success then
			print("LOADED...")
			local success, savedata = RunInSandbox(str)
			local str = DataDumper(savedata, nil, false)
			TheSim:SetPersistentString(path.."_decoded", str, false, function()
				print("SAVED!")
			end)
		else
			print("ERROR LOADING FILE! (wrong path?)")
		end
	end)
end

function d_decodealldata(suffix)
	suffix = suffix or ""
	local filenames = {
		"saveindex"..suffix,
		"profile"..suffix,
		"modindex"..suffix,
	}
	for i,type in ipairs({"survival", "shipwrecked", "adventure", "cave", "volcano"}) do
		if type == "cave" then
			for num=1,10 do
				for level=1,2 do
					for slot=1,5 do
						table.insert(filenames, string.format("%s_%d_%d_%d%s", type, num, level, slot, suffix))
					end
				end
			end
		else
			for slot=1,5 do
				table.insert(filenames, string.format("%s_%d%s", type, slot, suffix))
			end
		end
	end

	print("*******************************")
	print("ABOUT TO DECODE")
	for i,file in ipairs(filenames) do
		d_decodedata(file)
	end
	print("Done decoding")
	print("*******************************")
end
