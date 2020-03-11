local B, C, L, DB = unpack(select(2, ...))
local Extras = B:GetModule("Extras")

local C_MountJournal_GetMountIDs = C_MountJournal.GetMountIDs
local C_MountJournal_GetMountInfoByID = C_MountJournal.GetMountInfoByID
local C_MountJournal_GetMountInfoExtraByID = C_MountJournal.GetMountInfoExtraByID

function Extras:MS_MountInfo(unit, index, filter)
	if self:IsForbidden() then return end

	local auraID = select(10, UnitAura(unit, index, filter))
	local showIt = false

	if auraID then
		for _, mountID in ipairs(C_MountJournal_GetMountIDs()) do
			local spellID = select(2, C_MountJournal_GetMountInfoByID(mountID))
			local collected = select(11, C_MountJournal_GetMountInfoByID(mountID))
			if spellID == auraID then
				self:AddLine(" ")

				if collected then self:AddLine(COLLECTED, 0, 1, 0) end

				local sourceText = select(3, C_MountJournal_GetMountInfoExtraByID(mountID))
				self:AddLine(sourceText, 1, 1, 1)

				break
			end
		end

		showIt = true
	end

	if showIt then self:Show() end
end

function Extras:MountSource()
	hooksecurefunc(GameTooltip, "SetUnitAura", self.MS_MountInfo)
end