local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local function restyleGarrisonFollowerTooltipTemplate(frame)
		for i = 1, 9 do
			select(i, frame:GetRegions()):Hide()
		end

		if AuroraConfig.tooltips then
			F.ReskinTooltip(frame)
		end

		if frame.CloseButton then
			F.ReskinClose(frame.CloseButton)
		end
	end

	local function restyleGarrisonFollowerAbilityTooltipTemplate(frame)
		for i = 1, 9 do
			select(i, frame:GetRegions()):Hide()
		end
		F.ReskinIcon(frame.Icon)

		if AuroraConfig.tooltips then
			F.ReskinTooltip(frame)
		end
	end

	restyleGarrisonFollowerTooltipTemplate(FloatingGarrisonMissionTooltip)
	restyleGarrisonFollowerTooltipTemplate(GarrisonFollowerTooltip)
	restyleGarrisonFollowerAbilityTooltipTemplate(GarrisonFollowerAbilityTooltip)
	restyleGarrisonFollowerTooltipTemplate(FloatingGarrisonFollowerTooltip)
	restyleGarrisonFollowerAbilityTooltipTemplate(FloatingGarrisonFollowerAbilityTooltip)
	restyleGarrisonFollowerTooltipTemplate(GarrisonShipyardFollowerTooltip)
	restyleGarrisonFollowerTooltipTemplate(FloatingGarrisonShipyardFollowerTooltip)

	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", function(tooltipFrame)
		-- Abilities
		if tooltipFrame.numAbilitiesStyled == nil then
			tooltipFrame.numAbilitiesStyled = 1
		end

		local numAbilitiesStyled = tooltipFrame.numAbilitiesStyled
		local abilities = tooltipFrame.Abilities
		local ability = abilities[numAbilitiesStyled]
		while ability do
			local icon = ability.Icon

			icon:SetTexCoord(.08, .92, .08, .92)
			F.CreateBDFrame(icon)

			numAbilitiesStyled = numAbilitiesStyled + 1
			ability = abilities[numAbilitiesStyled]
		end

		tooltipFrame.numAbilitiesStyled = numAbilitiesStyled

		-- Traits
		if tooltipFrame.numTraitsStyled == nil then
			tooltipFrame.numTraitsStyled = 1
		end

		local numTraitsStyled = tooltipFrame.numTraitsStyled
		local traits = tooltipFrame.Traits
		local trait = traits[numTraitsStyled]
		while trait do
			local icon = trait.Icon

			icon:SetTexCoord(.08, .92, .08, .92)
			F.CreateBDFrame(icon)

			numTraitsStyled = numTraitsStyled + 1
			trait = traits[numTraitsStyled]
		end

		tooltipFrame.numTraitsStyled = numTraitsStyled
	end)
end)