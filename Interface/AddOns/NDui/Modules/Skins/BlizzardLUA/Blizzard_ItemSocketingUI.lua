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

	for i, socket in ipairs(ItemSocketingFrame.Sockets) do
		if not socket:IsShown() then break end

		local types = GetSocketTypes(i)
		local color = GemTypeInfo[types] or GemTypeInfo.Cogwheel
		socket.icbg:SetBackdropBorderColor(color.r, color.g, color.b)
	end
end

C.OnLoadThemes["Blizzard_ItemSocketingUI"] = function()
	B.ReskinFrame(ItemSocketingFrame)

	B.ReskinButton(ItemSocketingSocketButton)
	B.ReskinScroll(ItemSocketingScrollFrameScrollBar)
	B.CreateBGFrame(ItemSocketingScrollFrame, 0, 2, 0, -4)

	for i = 1, MAX_NUM_SOCKETS do
		local sockets = "ItemSocketingSocket"..i

		local socket = _G[sockets]
		B.StripTextures(socket)

		local bracket = _G[sockets.."BracketFrame"]
		B.StripTextures(bracket, 0)

		local icbg = B.ReskinIcon(_G[sockets.."IconTexture"])
		B.ReskinHLTex(socket, icbg)

		local shine = _G[sockets.."Shine"]
		shine:SetInside(icbg)

		socket.icbg = icbg
	end

	hooksecurefunc("ItemSocketingFrame_Update", Reskin_ItemSocketingFrame)
end