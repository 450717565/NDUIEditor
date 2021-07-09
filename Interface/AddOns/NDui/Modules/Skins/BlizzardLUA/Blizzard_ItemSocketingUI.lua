local _, ns = ...
local B, C, L, DB = unpack(ns)

local GemTypeInfo = {
	Red = {r=1, g=0, b=0},
	PunchcardRed = {r=1, g=0, b=0},

	Yellow = {r=1, g=1, b=0},
	PunchcardYellow = {r=1, g=1, b=0},

	Blue = {r=0, g=0, b=1},
	PunchcardBlue = {r=0, g=0, b=1},

	Meta = {r=0, g=0, b=0},
	Cogwheel = {r=0, g=0, b=0},
	Hydraulic = {r=0, g=0, b=0},
	Prismatic = {r=0, g=0, b=0},
	Domination = {r=0, g=0, b=0},
}

local function Reskin_ItemSocketingFrame()
	ItemSocketingDescription:SetBackdrop("")

	for i = 1, MAX_NUM_SOCKETS do
		local types = GetSocketTypes(i)
		local color = GemTypeInfo[types]
		local button = _G["ItemSocketingSocket"..i]
		button.icbg:SetBackdropBorderColor(color.r, color.g, color.b)
	end
end

C.OnLoadThemes["Blizzard_ItemSocketingUI"] = function()
	B.ReskinFrame(ItemSocketingFrame)

	B.ReskinButton(ItemSocketingSocketButton)
	B.ReskinScroll(ItemSocketingScrollFrameScrollBar)
	B.CreateBGFrame(ItemSocketingScrollFrame, 0, 2, 0, -4)

	for i = 1, MAX_NUM_SOCKETS do
		local buttons = "ItemSocketingSocket"..i

		local button = _G[buttons]
		B.StripTextures(button)

		local bracket = _G[buttons.."BracketFrame"]
		B.StripTextures(bracket, 0)

		local icbg = B.ReskinIcon(_G[buttons.."IconTexture"])
		B.ReskinHLTex(button, icbg)

		local shine = _G[buttons.."Shine"]
		shine:SetInside(icbg)

		button.icbg = icbg
	end

	hooksecurefunc("ItemSocketingFrame_Update", Reskin_ItemSocketingFrame)
end