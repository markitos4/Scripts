
local last_call = 0
local function CallDecompile(konstantType, scriptPath)
	local success, bytecode = pcall(getscriptbytecode, scriptPath)
	print(bytecode)
	if (not success) then
		print("Not")
		return nil, "Couldn't get the scriptbytecode of the Script"
	end
  
	local time_elapsed = os.clock() - last_call
	if time_elapsed <= .5 then
		task.wait(.5 - time_elapsed)
	end
	local httpResult = request({
		Url = "http://api.plusgiant5.com" .. konstantType,
		Body = bytecode,
		Method = "POST",
		Headers = {
			["Content-Type"] = "text/plain"
		},
	})
	last_call = os.clock()

	if (httpResult.StatusCode ~= 200) then
		return nil, "Couldn't send the request"
	else
		local lines = {}
        for line in httpResult.Body:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end
        
        local result = "-- Decompiled with Arctic executor, powered by konstant!\n\n" .. table.concat(lines, "\n", 6)
        return result
	end
end

getgenv().Decompile = function(script_instance)
	assert(typeof(script_instance) == "Instance", "#1 argument in Decompile must be an Instance", 2)
	assert(script_instance.ClassName == "LocalScript" or script_instance.ClassName == "ModuleScript", "#1 argument instance classname of Decompile must be a LocalScript or a ModuleScript", 2)
	return tostring(CallDecompile("/konstant/decompile", script_instance)):gsub("\t", "    ")
end
decompile = Decompile

getgenv().__Disassemble = function(script_instance)
assert(typeof(script_instance) == "Instance", "#1 argument in __Disassemble must be an Instance", 2)
	assert(script_instance.ClassName == "LocalScript" or script_instance.ClassName == "ModuleScript", "#1 argument instance classname of __Disassemble must be a LocalScript or a ModuleScript", 2)
	return tostring(CallDecompile("/konstant/disassemble", script_instance)):gsub("\t", "    ")
end
getgenv().__disassemble = __Disassemble
getgenv().Disassemble = __Disassemble
getgenv().disassemble = __Disassemble

local _saveinstance
getgenv().saveinstance = function(options)
	options = options or {}
  _saveinstance = _saveinstance or loadstring(HttpGet("https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/refs/heads/main/saveinstance.luau", true), "saveinstance")() --https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau
	return _saveinstance(options)
end

getgenv().savegame = saveinstance
getgenv().save_place = saveinstance
