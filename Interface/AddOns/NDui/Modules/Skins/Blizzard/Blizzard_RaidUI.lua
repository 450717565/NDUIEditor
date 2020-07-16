local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_RaidUI"] = function()
	for i = 1, NUM_RAID_GROUPS do
		local frame = "RaidGroup"..i

		local group = _G[frame]
		B.StripTextures(group)

		for j = 1, MEMBERS_PER_RAID_GROUP do
			local slot = _G[frame.."Slot"..j]
			slot:GetRegions():Hide()

			B.CreateBDFrame(slot, 0, 0)
			B.ReskinHighlight(slot, slot, true)
		end
	end

	for i = 1, MAX_RAID_MEMBERS do
		local frame = "RaidGroupButton"..i

		local button = _G[frame]
		select(4, button:GetRegions()):SetAlpha(0)
		B.ReskinHighlight(button, button, true)

		local class = _G[frame.."Class"]
		class:Hide()

		local level = _G[frame.."Level"]
		level:SetWidth(30)
		level:SetJustifyH("RIGHT")
		level:ClearAllPoints()
		level:SetPoint("RIGHT", button, "RIGHT", -2, 0)

		local name = _G[frame.."Name"]
		name:SetWidth(100)
		name:SetJustifyH("LEFT")
		name:ClearAllPoints()
		name:SetPoint("RIGHT", level, "LEFT", -2, 0)
	end
end
