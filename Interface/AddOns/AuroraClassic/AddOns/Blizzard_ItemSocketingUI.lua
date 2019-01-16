local F, C = unpack(select(2, ...))

C.themes["Blizzard_ItemSocketingUI"] = function()
	F.ReskinPortraitFrame(ItemSocketingFrame, true)

	F.StripTextures(ItemSocketingScrollFrame, true)
	F.Reskin(ItemSocketingSocketButton)
	F.ReskinScroll(ItemSocketingScrollFrameScrollBar)

	local title = select(18, ItemSocketingFrame:GetRegions())
	title:ClearAllPoints()
	title:SetPoint("TOP", 0, -10)

	for i = 1, MAX_NUM_SOCKETS do
		_G["ItemSocketingSocket"..i.."BracketFrame"]:Hide()
		_G["ItemSocketingSocket"..i.."Background"]:SetAlpha(0)

		local bu = _G["ItemSocketingSocket"..i]
		F.StripTextures(bu)
		bu:SetPushedTexture("")

		local ic = F.ReskinIcon(bu.icon, true)
		F.ReskinTexture(bu, ic, false)

		local shine = _G["ItemSocketingSocket"..i.."Shine"]
		shine:ClearAllPoints()
		shine:SetPoint("TOPLEFT", ic, C.mult, -C.mult)
		shine:SetPoint("BOTTOMRIGHT", ic, 0, 0)

		bu.bg = ic
	end

	hooksecurefunc("ItemSocketingFrame_Update", function()
		for i = 1, MAX_NUM_SOCKETS do
			local color = GEM_TYPE_INFO[GetSocketTypes(i)]
			_G["ItemSocketingSocket"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b)
		end

		local num = GetNumSockets()
		if num == 3 then
			ItemSocketingSocket1:SetPoint("BOTTOM", ItemSocketingFrame, "BOTTOM", -80, 38)
		elseif num == 2 then
			ItemSocketingSocket1:SetPoint("BOTTOM", ItemSocketingFrame, "BOTTOM", -40, 38)
		else
			ItemSocketingSocket1:SetPoint("BOTTOM", ItemSocketingFrame, "BOTTOM", 0, 38)
		end
		ItemSocketingDescription:SetBackdrop(nil)
	end)
end