local B, C, L, DB = unpack(select(2, ...))

local C_MountJournal_GetMountIDs = C_MountJournal.GetMountIDs
local C_MountJournal_GetMountInfo = C_MountJournal.GetMountInfoByID
local C_MountJournal_GetMountInfoExtra = C_MountJournal.GetMountInfoExtraByID

local function MountInfo(self, unit, index, filter)
	if self:IsForbidden() then return end

	local auraID = select(10, UnitAura(unit, index, filter))
	local showIt = false

	if auraID then
		for _, mountID in ipairs(C_MountJournal_GetMountIDs()) do
			local spellID = select(2, C_MountJournal_GetMountInfo(mountID))
			if spellID == auraID then
				local sourceText = select(3, C_MountJournal_GetMountInfoExtra(mountID))
				self:AddLine(" ")
				self:AddLine(sourceText, 1, 1, 1)

				break
			end
		end

		showIt = true
	end

	if showIt then self:Show() end
end

hooksecurefunc(GameTooltip, "SetUnitAura", MountInfo)