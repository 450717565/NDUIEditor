local B, C, L, DB = unpack(select(2, ...))

local C_MountJournal_GetMountIDs = C_MountJournal.GetMountIDs
local C_MountJournal_GetMountInfo = C_MountJournal.GetMountInfoByID
local C_MountJournal_GetMountInfoExtra = C_MountJournal.GetMountInfoExtraByID

local function MountInfo(self, unit, index, filter)
	if self:IsForbidden() then return end

	local _, _, _, _, _, _, caster, _, _, id = UnitAura(unit, index, filter)
	local showIt = false

	if id then
		for i, mid in ipairs(C_MountJournal_GetMountIDs()) do
			local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = C_MountJournal_GetMountInfo(mid)
			if spellID == id then
				local creatureDisplayID, descriptionText, sourceText, isSelfMount = C_MountJournal_GetMountInfoExtra(mid)
				self:AddLine(" ")
				if isCollected then
					self:AddDoubleLine(L["MountSource"], ALREADY_LEARNED, nil,nil,nil, 0,1,0)
				else
					self:AddLine(L["MountSource"], nil, nil, nil)
					self:AddLine(sourceText, 1, 1, 1)
				end
				break
			end
		end
		showIt = true
	end

	if showIt then self:Show() end
end

hooksecurefunc(GameTooltip, "SetUnitAura", MountInfo)