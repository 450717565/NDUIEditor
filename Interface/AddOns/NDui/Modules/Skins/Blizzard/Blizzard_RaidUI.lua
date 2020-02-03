local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_RaidUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	for i = 1, NUM_RAID_GROUPS do
		local frame = "RaidGroup"..i

		local group = _G[frame]
		group:GetRegions():SetAlpha(0)
		for j = 1, MEMBERS_PER_RAID_GROUP do
			local slot = _G[frame.."Slot"..j]
			select(1, slot:GetRegions()):SetAlpha(0)
			select(2, slot:GetRegions()):SetColorTexture(cr, cg, cb, .25)
			B.CreateBDFrame(slot, 0)
		end
	end

	for i = 1, MAX_RAID_MEMBERS do
		local bu = _G["RaidGroupButton"..i]
		select(4, bu:GetRegions()):SetAlpha(0)
		select(5, bu:GetRegions()):SetColorTexture(cr, cg, cb, .25)
	end
end
