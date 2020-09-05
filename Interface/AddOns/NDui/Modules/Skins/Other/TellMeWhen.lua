local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

local function ReskinTellMeWhen()
	TMW.Classes.IconModule_Texture:PostHookMethod("OnNewInstance", function(self)
		if not self.styled then
			B.ReskinIcon(self.texture)

			self.styled = true
		end
	end)
end

S.LoadWithAddOn("TellMeWhen", "TellMeWhen", ReskinTellMeWhen)