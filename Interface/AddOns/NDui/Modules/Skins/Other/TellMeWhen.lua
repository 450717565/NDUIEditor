local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local function ReskinTellMeWhen()
	TMW.Classes.IconModule_Texture:PostHookMethod("OnNewInstance", function(self)
		if not self.styled then
			B.ReskinIcon(self.texture)

			self.styled = true
		end
	end)
end

Skins.LoadWithAddOn("TellMeWhen", "TellMeWhen", ReskinTellMeWhen)