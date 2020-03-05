local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local function ReskinTMW()
	TMW.Classes.IconModule_Texture:PostHookMethod("OnNewInstance", function(self)
		if not self.styled then
			B.ReskinIcon(self.texture)

			self.styled = true
		end
	end)
end

S.LoadWithAddOn("TellMeWhen", "TellMeWhen", ReskinTMW)