local F, C = unpack(select(2, ...))

tinsert(C.themes["Aurora"], function()
	if AuroraConfig.tooltips then
		for i = 1, 9 do
			select(i, QueueStatusFrame:GetRegions()):Hide()
		end
		F.CreateBD(QueueStatusFrame)
	end

	local function SkinEntry(entry)
		for _, roleButton in next, {entry.HealersFound, entry.TanksFound, entry.DamagersFound} do
			roleButton.Texture:SetTexture(C.media.roleIcons)
			roleButton.Cover:SetTexture(C.media.roleIcons)
			F.CreateBDFrame(roleButton, .5, 4, -3, -4, 5)
		end

		for i = 1, LFD_NUM_ROLES do
			local roleIcon = entry["RoleIcon"..i]
			roleIcon:SetTexture(C.media.roleIcons)

			entry["RoleIconBorders"..i] = {}
			local borders = entry["RoleIconBorders"..i]

			local left = entry:CreateTexture(nil, "OVERLAY")
			left:SetWidth(1.2)
			left:SetTexture(C.media.backdrop)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", roleIcon, 2, -2)
			left:SetPoint("BOTTOMLEFT", roleIcon, 2, 3)
			tinsert(borders, left)

			local right = entry:CreateTexture(nil, "OVERLAY")
			right:SetWidth(1.2)
			right:SetTexture(C.media.backdrop)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", roleIcon, -2, -2)
			right:SetPoint("BOTTOMRIGHT", roleIcon, -2, 3)
			tinsert(borders, right)

			local top = entry:CreateTexture(nil, "OVERLAY")
			top:SetHeight(1.2)
			top:SetTexture(C.media.backdrop)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", roleIcon, 2, -2)
			top:SetPoint("TOPRIGHT", roleIcon, -2, -2)
			tinsert(borders, top)

			local bottom = entry:CreateTexture(nil, "OVERLAY")
			bottom:SetHeight(1.2)
			bottom:SetTexture(C.media.backdrop)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", roleIcon, 2, 3)
			bottom:SetPoint("BOTTOMRIGHT", roleIcon, -2, 3)
			tinsert(borders, bottom)
		end
	end

	hooksecurefunc("QueueStatusEntry_SetMinimalDisplay", function(entry)
		if not entry.styled then
			SkinEntry(entry)
			entry.styled = true
		end

		for i = 1, LFD_NUM_ROLES do
			for _, border in next, entry["RoleIconBorders"..i] do
				border:Hide()
			end
		end
	end)

	hooksecurefunc("QueueStatusEntry_SetFullDisplay", function(entry)
		if not entry.styled then
			SkinEntry(entry)
			entry.styled = true
		end

		for i = 1, LFD_NUM_ROLES do
			local shown = entry["RoleIcon"..i]:IsShown()

			for _, border in next, entry["RoleIconBorders"..i] do
				border:SetShown(shown)
			end
		end
	end)
end)