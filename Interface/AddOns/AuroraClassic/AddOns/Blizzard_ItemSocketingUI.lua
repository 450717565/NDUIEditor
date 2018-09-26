local F, C = unpack(select(2, ...))

C.themes["Blizzard_ItemSocketingUI"] = function()
	F.ReskinPortraitFrame(ItemSocketingFrame, true)

	F.StripTextures(ItemSocketingScrollFrame, true)
	F.CreateBDFrame(ItemSocketingScrollFrame, .25)
	F.Reskin(ItemSocketingSocketButton)
	F.ReskinScroll(ItemSocketingScrollFrameScrollBar)

	local title = select(18, ItemSocketingFrame:GetRegions())
	title:ClearAllPoints()
	title:SetPoint("TOP", 0, -10)

	for i = 1, MAX_NUM_SOCKETS do
		local bu = _G["ItemSocketingSocket"..i]
		local shine = _G["ItemSocketingSocket"..i.."Shine"]

		F.StripTextures(bu)

		_G["ItemSocketingSocket"..i.."BracketFrame"]:Hide()
		_G["ItemSocketingSocket"..i.."Background"]:SetAlpha(0)
		select(2, bu:GetRegions()):Hide()

		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu.icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(bu.icon, .25)

		shine:ClearAllPoints()
		shine:SetPoint("TOPLEFT")
		shine:SetPoint("BOTTOMRIGHT", 1, -1)

		bu.bg = F.CreateBDFrame(bu, .25)
	end

	hooksecurefunc("ItemSocketingFrame_Update", function()
		for i = 1, MAX_NUM_SOCKETS do
			local color = GEM_TYPE_INFO[GetSocketTypes(i)]
			_G["ItemSocketingSocket"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b)
			_G["ItemSocketingSocket"..i].bg.Shadow:SetBackdropBorderColor(color.r, color.g, color.b)
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