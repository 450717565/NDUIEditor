local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_ItemSocketingUI"] = function()
	B.ReskinFrame(ItemSocketingFrame)

	B.ReskinButton(ItemSocketingSocketButton)
	B.ReskinScroll(ItemSocketingScrollFrameScrollBar)
	B.CreateBGFrame(ItemSocketingScrollFrame, 0, 0, 0, -3)

	for i = 1, MAX_NUM_SOCKETS do
		local button = "ItemSocketingSocket"..i

		local bu = _G[button]
		B.StripTextures(bu)

		local bf = _G[button.."BracketFrame"]
		bf:SetAlpha(0)

		local bg = _G[button.."Background"]
		bg:SetAlpha(0)

		local ic = _G[button.."IconTexture"]
		local icbg = B.ReskinIcon(ic)
		B.ReskinHighlight(bu, icbg)

		local shine = _G[button.."Shine"]
		shine:SetInside(icbg)

		bu.icbg = icbg
	end

	local GemTypeInfo = {
		Blue = {r=.1, g=.1, b=1},
		Red = {r=1, g=.1, b=.1},
		Yellow = {r=1, g=1, b=.1},
		Cogwheel = {r=0, g=0, b=0},
		Hydraulic = {r=0, g=0, b=0},
		Meta = {r=0, g=0, b=0},
		Prismatic = {r=0, g=0, b=0},
		PunchcardBlue = {r=.1, g=.1, b=1},
		PunchcardRed = {r=1, g=.1, b=.1},
		PunchcardYellow = {r=1, g=1, b=.1},
	}

	hooksecurefunc("ItemSocketingFrame_Update", function()
		ItemSocketingDescription:SetBackdrop(nil)

		for i = 1, MAX_NUM_SOCKETS do
			local color = GemTypeInfo[GetSocketTypes(i)]
			_G["ItemSocketingSocket"..i].icbg:SetBackdropBorderColor(color.r, color.g, color.b)
		end
	end)
end