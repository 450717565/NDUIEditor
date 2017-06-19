ArtifactTab = LibStub("AceAddon-3.0"):NewAddon("NDui", "AceEvent-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function ArtifactTab:OnInitialize()
	ArtifactTab:RegisterEvent("PLAYER_LOGIN")
end

function ArtifactTab:GetArtifactPoisition()
	local artifactTable = {}
	for bagID = 0, NUM_BAG_SLOTS do
		if GetContainerNumSlots(bagID) > 0 then
			for slotID = 0, GetContainerNumSlots(bagID) do
				local itemLink = GetContainerItemLink(bagID, slotID)
				if itemLink and type(itemLink) == 'string' then
					local itemID = GetItemInfoInstant(itemLink)
					local itemName, _, itemRarity, _, _, _, itemSubType, _, _, _, _, itemClassID = GetItemInfo(itemLink)
					if itemRarity == 6 and itemClassID == 2 and itemID ~= 133755 then
						artifactTable[itemID] = {
							['name'] = itemName,
							['bagID'] = bagID,
							['slotID'] = slotID
						}
					end
				end
			end
		end
	end

	local itemID = GetInventoryItemID("player", 16)
	local itemName, _, itemRarity = GetItemInfo(itemID)
	if itemRarity == 6 and itemID ~= 133755 then
		artifactTable[itemID] = {
			['name'] = itemName,
			['bagID'] = -1,
			['slotID'] = 16
		}
	end

	return artifactTable
end

function ArtifactTab:PLAYER_LOGIN()
	ArtifactTab.currentTab = '';
	if IsAddOnLoaded("Blizzard_ArtifactUI") then
		ArtifactTab:ArtifactLoaded()
	end
	if IsAddOnLoaded("Blizzard_TalentUI") then
		ArtifactTab:TalentLoaded()
	end
	ArtifactTab:RegisterEvent("ADDON_LOADED")
end

function ArtifactTab:CreateTab(name, parent, text, id, template)
	local button = CreateFrame("Button", name, parent, template)
	button:SetText(text)
	button:SetPoint("LEFT", parent, "RIGHT", -15, 0)

	button:SetScript("OnClick", function()
		ArtifactTab.currentTab = id
		ArtifactTab:ArtifactClick(id)
	end)

	return button
end

function ArtifactTab:TalentLoaded()
	local parent = _G["PlayerTalentFrameTab"..NUM_TALENT_FRAME_TABS]
	local artifactTable = ArtifactTab:GetArtifactPoisition()
	for k, v in pairs(artifactTable) do
		parent = ArtifactTab:CreateTab('ArtifactTabTalentTab'..k, parent, v['name'], k, "PlayerTalentTabTemplate")
		-- Aurora Reskin
		if IsAddOnLoaded("Aurora") then
			local F = unpack(Aurora)
			F.ReskinTab(_G["ArtifactTabTalentTab"..k])
		end
	end
end

function ArtifactTab:ArtifactLoaded()
	local parent = ArtifactFrameTab1
	local artifactTable = ArtifactTab:GetArtifactPoisition()
	for k, v in pairs(artifactTable) do
		parent = ArtifactTab:CreateTab('ArtifactTabArtifactTab'..k, parent, v['name'], k, "ArtifactFrameTabButtonTemplate")
		-- Aurora Reskin
		if IsAddOnLoaded("Aurora") then
			local F = unpack(Aurora)
			F.ReskinTab(_G["ArtifactTabArtifactTab"..k])
		end
		ArtifactFrameTab2:HookScript("OnShow", function(self)
			ArtifactFrameTab2:ClearAllPoints()
			ArtifactFrameTab2:SetPoint("LEFT", _G["ArtifactTabArtifactTab"..k], "RIGHT", -15, 0)
		end)
	end
end

function ArtifactTab:ADDON_LOADED(_, addon)
	if addon == 'Blizzard_TalentUI' then
		ArtifactTab:TalentLoaded()
	elseif addon == 'Blizzard_ArtifactUI' then
		ArtifactTab:ArtifactLoaded()
	end
end

function ArtifactTab:ArtifactClick(id)
	local artifactTable = ArtifactTab:GetArtifactPoisition()
	if artifactTable[id] ~= nil then
		if artifactTable[id]['bagID'] == -1 then
			SocketInventoryItem(artifactTable[id]['slotID'])
		else
			SocketContainerItem(artifactTable[id]['bagID'], artifactTable[id]['slotID'])
		end
	else
		print('没有找到神器');
	end
end