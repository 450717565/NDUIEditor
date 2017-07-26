local defaults = C_LFGList.GetDefaultLanguageSearchFilter()

local function disable_language_module()
	local languages = C_LFGList.GetAvailableLanguageSearchFilter()
	local i
	for i=1,#languages do
		if not defaults[ languages[i] ] then
			return false
		end
	end
	return true
end

if disable_language_module() then
	return
end

local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local LookingForGroup = AceAddon:GetAddon("LookingForGroup")
local LookingForGroup_Options = AceAddon:GetAddon("LookingForGroup_Options")

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local avlsf

local function get_available_language_search_filter()
	avlsf = C_LFGList.GetAvailableLanguageSearchFilter()
	return avlsf
end

LookingForGroup_Options:push("languages",{
	name = LANGUAGES_LABEL,
	type = "group",
	args =
	{
		filters =
		{
			name = FILTERS,
			type = "multiselect",
			order = get_order(),
			values = get_available_language_search_filter,
			set = function(_,key,val)
				local v = avlsf[key]
				if defaults[v] then
					return
				end
				local enabled = C_LFGList.GetLanguageSearchFilter()
				enabled[v] = val
				C_LFGList.SaveLanguageSearchFilter(enabled)
			end,
			get = function(_,key)
				local v = avlsf[key]
				if defaults[v] then
					return
				end
				local enabled = C_LFGList.GetLanguageSearchFilter()
				if enabled[v] then
					return true
				else
					return false
				end
			end,
			width = "full",
			tristate = true,
		},
	}
})
