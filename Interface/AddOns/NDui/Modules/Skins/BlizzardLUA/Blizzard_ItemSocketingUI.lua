local _, ns = ...
local B, C, L, DB = unpack(ns)

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

local function Reskin_ItemSocketingFrame()
	ItemSocketingDescription:SetBackdrop(nil)

	for i = 1, MAX_NUM_SOCKETS do
		local types = GetSocketTypes(i)
		local color = GemTypeInfo[types]
		local button = _G["ItemSocketingSocket"..i]
		button.icbg:SetBackdropBorderColor(color.r, color.g, color.b)
	end
end

C.LUAThemes["Blizzard_ItemSocketingUI"] = function()
	B.ReskinFrame(ItemSocketingFrame)

	B.ReskinButton(ItemSocketingSocketButton)
	B.ReskinScroll(ItemSocketingScrollFrameScrollBar)
	B.CreateBGFrame(ItemSocketingScrollFrame, 0, 2, 0, -4)

	for i = 1, MAX_NUM_SOCKETS do
		local buttons = "ItemSocketingSocket"..i

		local button = _G[buttons]
		B.StripTextures(button)

		local bf = _G[buttons.."BracketFrame"]
		bf:SetAlpha(0)

		local bg = _G[buttons.."Background"]
		bg:SetAlpha(0)

		local icon = _G[buttons.."IconTexture"]
		local icbg = B.ReskinIcon(icon)
		B.ReskinHLTex(button, icbg)

		local shine = _G[buttons.."Shine"]
		shine:SetInside(icbg)

		button.icbg = icbg
	end

	hooksecurefunc("ItemSocketingFrame_Update", Reskin_ItemSocketingFrame)
end