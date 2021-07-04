local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:RegisterModule("Skins")

local pairs, wipe = pairs, wipe
local IsAddOnLoaded = IsAddOnLoaded

C.OnLoginThemes = {}
C.OnLoadThemes = {}

function SKIN:OnLogin()
	if IsAddOnLoaded("AuroraClassic") or IsAddOnLoaded("Aurora") then return end

	if C.db["Skins"]["BlizzardSkins"] then
		-- OnLogin Themes
		for name, func in pairs(C.OnLoginThemes) do
			if name and type(func) == "function" then
				func()
			end
		end

		-- OnLoad Themes
		for name, func in pairs(C.OnLoadThemes) do
			if name and type(func) == "function" then
				B.LoadWithAddOn(name, func)
			end
		end
	end

	-- Add Skins
	self:BigWigs()
	self:DeadlyBossMods()
	self:Details()
	self:Skada()
	self:TellMeWhen()
	self:WeakAuras()

	-- Register skin
	local media = LibStub and LibStub("LibSharedMedia-3.0", true)
	if media then
		media:Register("statusbar", "normTex", DB.normTex)
	end
end