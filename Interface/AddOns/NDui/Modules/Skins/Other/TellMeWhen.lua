local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local function Reskin_TellMeWhen()
	if not C.db["Skins"]["TellMeWhen"] then return end

	TMW.Classes.IconModule_Texture:PostHookMethod("OnNewInstance", function(self)
		if not self.styled then
			B.ReskinIcon(self.texture)

			self.styled = true
		end
	end)
end

Skins.LoadWithAddOn("TellMeWhen", Reskin_TellMeWhen)