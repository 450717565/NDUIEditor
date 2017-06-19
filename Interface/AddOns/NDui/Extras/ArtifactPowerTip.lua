local B, C, L, DB = unpack(select(2, ...))

GameTooltip:HookScript('OnTooltipSetItem', function(self)
	local _, link = self:GetItem()
	if type(link) == 'string' then
		if IsArtifactPowerItem(link) then
			local artifactID, _, artifactName = C_ArtifactUI.GetEquippedArtifactInfo()
			if artifactName then
				local spec = GetSpecialization()
				local _, specName = GetSpecializationInfo(spec)
				if artifactName then
					self:AddLine(" ")
					self:AddDoubleLine(format(DB.MyColor.."<%s>", specName), format("|cffe6cc80[%s]", artifactName))
					self:Show()
				end
			end
		end
	end
end)