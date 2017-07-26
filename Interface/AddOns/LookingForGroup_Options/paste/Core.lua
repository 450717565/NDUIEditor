local LookingForGroup_Options = LibStub("AceAddon-3.0"):GetAddon("LookingForGroup_Options")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local paste_text

local back =
{
	name = BACK,
	type = "execute",
	order = get_order(),
}

local paste_cfg =
{
	name = CALENDAR_PASTE_EVENT,
	type = "group",
	order = -1,
	args =
	{
		paste =
		{
			name = LOCALE_TEXT_LABEL,
			type = "input",
			multiline = true,
			order = get_order(),
			width = "full",
			set = function()end,
			get = function() return paste_text; end,
		},
		back = back
	}
}
function LookingForGroup_Options.Paste(text,backfunc)
	back.func = function()
		LookingForGroup_Options.option_table.args.paste = nil
		paste_text = nil
		backfunc()
	end
	paste_text = text
	LookingForGroup_Options.option_table.args.paste = paste_cfg
	AceConfigDialog:SelectGroup("LookingForGroup","paste")
end
