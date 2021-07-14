
local tool_wear = core.settings:get_bool("tool_wear", true)

core.register_on_mods_loaded(function()
	for tname, tdef in pairs(core.registered_tools) do
		local new_def = table.copy(tdef)
		local override = false

		if new_def.tool_capabilities then
			if new_def.tool_capabilities.groupcaps then
				for k, v in pairs(new_def.tool_capabilities.groupcaps) do
					if not tool_wear then
						new_def.tool_capabilities.groupcaps[k].uses = 0
						override = true
					end
				end
			end
		end

		if override then
			core.unregister_item(tname)
			core.register_tool(":" .. tname, new_def)
		end
	end
end)
