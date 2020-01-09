local _, ns = ...
local B, C, L, DB, F = unpack(ns)
local S = B:GetModule("Skins")

local function ReskinTMW()
	TMW.Classes.IconModule_Texture:PostHookMethod("OnNewInstance", function(self)
		if not self.styled then
			F.ReskinIcon(self.texture)

			self.styled = true
		end
	end)
end

S:LoadWithAddOn("TellMeWhen", "TMW", ReskinTMW)