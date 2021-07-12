local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

function SKIN:WoWLua()
	if not IsAddOnLoaded("WowLua") then return end

	B.ReskinFrame(WowLuaFrame)
	B.ReskinClose(WowLuaButton_Close, WowLuaFrame)

	B.StripTextures(WowLuaFrameResizeBar)
	B.StripTextures(WowLuaFrameCommand)
	B.ReskinScroll(WowLuaFrameEditScrollFrameScrollBar)

	local title = WowLuaFrameTitle
	title:SetJustifyH("CENTER")
	title:ClearAllPoints()
	title:SetPoint("TOP", WowLuaFrame, "TOP", 0, -5)

	local numFrame = WowLuaFrameLineNumScrollFrame
	B.StripTextures(numFrame)
	B.CreateBDFrame(numFrame)

	local outFrame = WowLuaFrameOutput
	B.StripTextures(outFrame)
	B.CreateBDFrame(outFrame)

	local newButton = WowLuaButton_New
	newButton:ClearAllPoints()
	newButton:SetPoint("BOTTOMLEFT", numFrame, "TOPRIGHT", 10, 10)

	local Buttons = {
		WowLuaButton_New,
		WowLuaButton_Open,
		WowLuaButton_Save,
		WowLuaButton_Undo,
		WowLuaButton_Redo,
		WowLuaButton_Delete,
		WowLuaButton_Lock,
		WowLuaButton_Unlock,
		WowLuaButton_Config,
		WowLuaButton_Previous,
		WowLuaButton_Next,
		WowLuaButton_Run,
	}

	for _, object in pairs(Buttons) do
		local bg = B.CreateBDFrame(object)
		B.ReskinHLTex(object, bg)

		local icon = object:GetNormalTexture()
		icon:SetTexCoord(.15, .85, .15, .85)
		icon:SetInside(bg)

		local disa = object:GetDisabledTexture()
		if disa then
			disa:SetTexCoord(.15, .85, .15, .85)
			disa:SetInside(bg)
		end
	end
end

C.OnLoginThemes["WoWLua"] = SKIN.WoWLua