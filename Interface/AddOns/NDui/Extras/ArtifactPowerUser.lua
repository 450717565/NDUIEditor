local B, C, L, DB = unpack(select(2, ...))

local itemLink, bag, slot
local Cache = {}

local APU = CreateFrame("Button", "ArtifactPowerUserButton", UIParent, "ActionButtonTemplate, SecureActionButtonTemplate")
B.CreateMF(APU)
APU:SetPoint("CENTER", 0, -200)
APU:SetSize(48, 48)
APU:SetClampedToScreen(true)
APU:EnableMouse(true)
APU:SetUserPlaced(true)
APU:SetClampedToScreen(true)

APU:SetScript("OnHide", function(self)
	self:SetAttribute("type", nil)
	self:SetAttribute("item", nil)
end)

APU:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetHyperlink(itemLink)
end)

APU:SetScript("OnLeave", function(self)
	GameTooltip_Hide()
end)

APU.icon = APU:CreateTexture(nil, "ARTWORK")
APU.icon:SetTexCoord(.08, .92, .08, .92)
APU.icon:SetAllPoints()
APU.icon:SetPoint("TOPLEFT", APU, "TOPLEFT", 1, -1)
APU.icon:SetPoint("BOTTOMRIGHT", APU, "BOTTOMRIGHT", -1, 1)

local function ScanBags()
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag, slot)
			if itemLink and itemLink:match("item:%d") then
				if Cache[itemLink] then
					return itemLink, bag, slot
				else
					if IsArtifactPowerItem(itemLink) then
						return itemLink, bag, slot
					end
				end
			end
		end
	end
	return nil
end

local function UpdateItem(self)
	if not InCombatLockdown() then
		itemLink, bag, slot = ScanBags()
		if itemLink then
			self:SetAttribute("type", "item")
			self:SetAttribute("item", bag.." "..slot)
			local itemTexture = GetItemIcon(itemLink)
			self.icon:SetTexture(itemTexture)
			local start, duration, enable = GetContainerItemCooldown(bag, slot)
			if duration > 0 then
				self.cooldown:SetCooldown(start, duration)
				self.cooldown:SetAllPoints(self.icon)
			end
			self:Show()
			if self:IsMouseOver() then	--update tooltip
				GameTooltip:SetHyperlink(itemLink)
			end
			GameTooltip:Show()
		else
			self:Hide()
			GameTooltip_Hide()
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("BAG_UPDATE_DELAYED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:SetScript("OnEvent", function(self, event, ...)
	self:UnregisterEvent("ADDON_LOADED")
	if  event == "BAG_UPDATE_DELAYED" then
		UpdateItem(APU)
	elseif event == "PLAYER_REGEN_DISABLED" then
		self:UnregisterEvent("BAG_UPDATE_DELAYED")
		APU:Hide()
		GameTooltip_Hide()
	elseif event == "PLAYER_REGEN_ENABLED" then
		UpdateItem(APU)
		self:RegisterEvent("BAG_UPDATE_DELAYED")
	end
end)

-- Aurora Reskin
if IsAddOnLoaded("Aurora") then
	local F = unpack(Aurora)
	APU:SetNormalTexture("")
	F.CreateBD(APU)
	F.CreateSD(APU)
end