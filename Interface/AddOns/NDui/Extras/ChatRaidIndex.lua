local _, ns = ...
local B, C, L, DB = unpack(ns)
local EX = B:GetModule("Extras")
------------------------
-- Credit: BasicChatMods
-- 修改：雨夜独行客
------------------------
local GroupNames = {}

function EX:UpdateGroupNames()
	wipe(GroupNames)

	if not IsInRaid() then return end

	for i = 1, GetNumGroupMembers() do
		local name, _, subgroup = GetRaidRosterInfo(i)
		if name and subgroup then
			GroupNames[name] = tostring(subgroup)
		end
	end
end

local function addRaidIndex(fullName, nameString, nameText)
	local name = Ambiguate(fullName, "none")
	local group = name and GroupNames[name]

	if group then
		nameText = nameText.."："..group
	end

	return "|Hplayer:"..fullName..nameString.."["..nameText.."]|h"
end

function EX:UpdateRaidIndex(text, ...)
	if IsInRaid() then
		text = text:gsub("|Hplayer:([^:|]+)([^%[]+)%[([^%]]+)%]|h", addRaidIndex)
	end

	return self.origAddMsg(self, text, ...)
end

function EX:ChatRaidIndex()
	local eventList = {
		"GROUP_ROSTER_UPDATE",
		"PLAYER_ENTERING_WORLD",
	}

	for _, event in next, eventList do
		B:RegisterEvent(event, EX.UpdateGroupNames)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		if i ~= 2 then
			local chatFrame = _G["ChatFrame"..i]
			chatFrame.origAddMsg = chatFrame.AddMessage
			chatFrame.AddMessage = EX.UpdateRaidIndex
		end
	end
end