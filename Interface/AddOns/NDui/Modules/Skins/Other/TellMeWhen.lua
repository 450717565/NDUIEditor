local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

function SKIN:TellMeWhen()
	if not C.db["Skins"]["TellMeWhen"] or not IsAddOnLoaded("TellMeWhen") then return end

	TMW.Classes.IconModule_Texture:PostHookMethod("OnNewInstance", function(self)
		if not self.styled then
			B.ReskinIcon(self.texture)

			self.styled = true
		end
	end)
end