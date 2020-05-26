local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")
local pairs = pairs

local function ReskinWA()
	local function Skin_WeakAuras(self, type)
		if type == "icon" then
			if self.icon and not self.icon.styled then
				B.ReskinIcon(self.icon)
				self.icon.SetTexCoord = B.Dummy

				self.icon.styled = true
			end
		elseif type == "aurabar" then
			if self.bar and not self.bar.styled then
				B.ReskinIcon(self.icon)
				self.icon.SetTexCoord = B.Dummy

				local bg = B.CreateBDFrame(self.bar, 0, nil, true)
				bg:SetFrameLevel(0)

				if bg.Tex then bg.Tex:Hide() end

				self.bar.styled = true
			end
		end
	end

	local regionTypes = WeakAuras.regionTypes
	local Create_Icon, Modify_Icon = regionTypes.icon.create, regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = regionTypes.aurabar.create, regionTypes.aurabar.modify

	regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		Skin_WeakAuras(region, "icon")
		return region
	end

	regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		Skin_WeakAuras(region, "aurabar")
		return region
	end

	regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		Skin_WeakAuras(region, "icon")
	end

	regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		Skin_WeakAuras(region, "aurabar")
	end

	for weakAura in pairs(WeakAuras.regions) do
		local regions = WeakAuras.regions[weakAura]
		if regions.regionType == "icon" or regions.regionType == "aurabar" then
			Skin_WeakAuras(regions.region, regions.regionType)
		end
	end

	local function ReskinWAOptions()
		local frame = _G["WeakAurasOptions"]
		if not frame then return end

		B.ReskinFrame(frame)
		B.ReskinInput(frame.filterInput)
		B.ReskinButton(WASettingsButton)

		local closeBG = select(1, frame:GetChildren())
		B.StripTextures(closeBG)

		local close = closeBG:GetChildren()
		close:ClearAllPoints()
		close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")

		local minimizeBG = select(5, frame:GetChildren())
		B.StripTextures(minimizeBG)

		local minimize = minimizeBG:GetChildren()
		minimize:ClearAllPoints()
		minimize:SetPoint("RIGHT", close, "LEFT")

		for i = 1, frame.texteditor.frame:GetNumChildren() do
			local child = select(i, frame.texteditor.frame:GetChildren())
			if child:GetObjectType() == "Button" and child:GetText() then
				B.ReskinButton(child)
			end
		end
	end

	local function loadFunc(event, addon)
		if addon == "WeakAurasOptions" then
			hooksecurefunc(WeakAuras, "CreateFrame", ReskinWAOptions)
			B:UnregisterEvent(event, loadFunc)
		end
	end
	B:RegisterEvent("ADDON_LOADED", loadFunc)
end

S.LoadWithAddOn("WeakAuras", "WeakAuras", ReskinWA)