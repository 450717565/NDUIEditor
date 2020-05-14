local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_RaidUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

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
		local button = _G["RaidGroupButton"..i]
		select(4, button:GetRegions()):Hide()
		B.ReskinHighlight(button, button, true)
	end
end
