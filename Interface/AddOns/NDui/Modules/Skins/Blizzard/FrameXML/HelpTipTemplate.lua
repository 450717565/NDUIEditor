local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.defaultThemes, function()
	if not NDuiDB["Skins"]["BlizzardSkins"] then return end

	local function reskinAlertFrame(self)
		if not self.styled then
			if self.OkayButton then B.ReskinButton(self.OkayButton) end
			if self.CloseButton then B.ReskinClose(self.CloseButton) end

			self.styled = true
		end
	end

	local microButtons = {
		CharacterMicroButtonAlert,
		CollectionsMicroButtonAlert,
		EJMicroButtonAlert,
		GuildMicroButtonAlert,
		LFDMicroButtonAlert,
		StoreMicroButtonAlert,
		TalentMicroButtonAlert,
		ZoneAbilityButtonAlert,
	}

	for _, frame in pairs(microButtons) do
		reskinAlertFrame(frame)
	end

	hooksecurefunc(HelpTip, "Show", function(self)
		for frame in self.framePool:EnumerateActive() do
			reskinAlertFrame(frame)
		end
	end)
end)