
local tool_wear = core.settings:get_bool("tool_wear", true)
local weapon_wear = core.settings:get_bool("weapon_wear", true)

core.register_on_mods_loaded(function()
	-- hook into ItemStack meta table method
	if not weapon_wear then
		local mt = getmetatable(ItemStack(""))
		local add_wear_old = mt.add_wear
		mt.add_wear = function(self, ...)
			local i_type = core.registered_items[self:get_name()].type
			if i_type and i_type == "tool" then
				return true
			end

			return add_wear_old(self, ...)
		end
	end

	for tname, tdef in pairs(core.registered_tools) do
		local new_def = table.copy(tdef)
		local override = false

		if new_def.tool_capabilities then
			if not weapon_wear then
				new_def.tool_capabilities.punch_attack_uses = nil
			end

			if new_def.tool_capabilities.groupcaps then
				for k, v in pairs(new_def.tool_capabilities.groupcaps) do
					-- FIXME: should "fleshy" only be modified for weapon wear?
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
