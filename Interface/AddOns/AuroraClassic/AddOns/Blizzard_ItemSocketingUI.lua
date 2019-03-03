local F, C = unpack(select(2, ...))

C.themes["Blizzard_ItemSocketingUI"] = function()
	F.ReskinFrame(ItemSocketingFrame)

	F.StripTextures(ItemSocketingScrollFrame)
	F.StripTextures(ItemSocketingDescription)

	F.ReskinButton(ItemSocketingSocketButton)
	F.ReskinScroll(ItemSocketingScrollFrameScrollBar)

	local bg = F.CreateBDFrame(ItemSocketingScrollFrame, 0)
	bg:SetPoint("TOPLEFT", 0, 0)
	bg:SetPoint("BOTTOMRIGHT", 0, -3)

	for i = 1, MAX_NUM_SOCKETS do
		local button = "ItemSocketingSocket"..i

		local bu = _G[button]
		F.StripTextures(bu)

		local bf = _G[button.."BracketFrame"]
		bf:SetAlpha(0)

		local bg = _G[button.."Background"]
		bg:SetAlpha(0)

		local ic = _G[button.."IconTexture"]
		local icbg = F.ReskinIcon(ic)
		F.ReskinTexture(bu, icbg, false)

		local shine = _G[button.."Shine"]
		shine:ClearAllPoints()
		shine:SetPoint("TOPLEFT", icbg, C.mult, -C.mult)
		shine:SetPoint("BOTTOMRIGHT", icbg, 0, 0)
	end
end