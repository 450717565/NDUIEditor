local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")
local wipe = wipe
local pairs = pairs

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local select_tb = {}

local realm_filter_vtb = {}
local realm_f_vtb = {}

LookingForGroup_Options:push("rf",{
	name = FRIENDS_LIST_REALM:match("^(.*)%:") or FRIENDS_LIST_REALM:match("^(.*)%：") or FRIENDS_LIST_REALM,
	type = "group",
	args =
	{
		mode =
		{
			name = MODE,
			order = get_order(),
			type = "toggle",
			get = function(info)
				local mode_rf = LookingForGroup.db.profile.mode_rf
				if mode_rf then
					return true
				elseif mode_rf == false then
					return nil
				else
					return false
				end
			end,
			set = function(info,val)
				if val then
					LookingForGroup.db.profile.mode_rf = true
				elseif val == nil then
					LookingForGroup.db.profile.mode_rf = false
				else
					LookingForGroup.db.profile.mode_rf = nil
				end
			end,
			width = "full",
			tristate = true
		},
		add =
		{
			name = ADD,
			type = "input",
			order = get_order(),
			set = function(_,val)
				LookingForGroup.db.profile.realm_filters[val] = true
			end,
			get = function()end,
			width = "full"
		},
		rmv =
		{
			name = REMOVE,
			type = "execute",
			order = get_order(),
			func = function()
				local rfs = LookingForGroup.db.profile.realm_filters
				local k,v
				for k,v in pairs(select_tb) do
					if v then
						rfs[realm_filter_vtb[k]] = nil
					end
				end
				wipe(select_tb)
			end
		},
		cancel =
		{
			name = CANCEL,
			type = "execute",
			order = get_order(),
			func = function() wipe(select_tb) end
		},
		filters_s =
		{
			name = FILTERS,
			type = "multiselect",
			order = get_order(),
			values = function()
				wipe(realm_filter_vtb)
				local table_insert = table.insert
				local k,v
				for k,v in pairs(LookingForGroup.db.profile.realm_filters) do
					table_insert(realm_filter_vtb,k)
				end
				return realm_filter_vtb
			end,
			set = function(_,key,val)
				if val then
					select_tb[key] = true
				else
					select_tb[key] = nil
				end
			end,
			get = function(_,key)
				return select_tb[key]
			end,
			width = "full",
		},
		filters =
		{
			name = FILTERS,
			type = "input",
			multiline = true,
			order = get_order(),
			width = "full",
			set = function(_,val)
				local gmatch = string.gmatch
				local t = {}
				for k,_ in gmatch(val, "([^\n]+)") do
					t[k] = true
				end
				LookingForGroup.db.profile.realm_filters = t
			end,
			get = function()
				wipe(realm_f_vtb)
				local table_insert = table.insert
				local k,v
				for k,v in pairs(LookingForGroup.db.profile.realm_filters) do
					table_insert(realm_f_vtb,k)
				end
				return table.concat(realm_f_vtb,'\n')
			end,
		}
	}
})
