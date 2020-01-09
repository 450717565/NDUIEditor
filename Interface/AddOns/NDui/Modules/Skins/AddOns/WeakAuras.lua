local _, ns = ...
local B, C, L, DB, F = unpack(ns)
local S = B:GetModule("Skins")
local pairs = pairs

local function ReskinWA()
	local function Skin_WeakAuras(self, type)
		if type == "icon" then
			if self.icon and not self.icon.styled then
				F.ReskinIcon(self.icon)
				self.icon.SetTexCoord = B.Dummy

				self.icon.styled = true
			end
		elseif type == "aurabar" then
			if self.bar and not self.bar.styled then
				F.CreateBDFrame(self.bar)
				F.ReskinIcon(self.icon)
				self.icon.SetTexCoord = B.Dummy

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
end

S:LoadWithAddOn("WeakAuras", "WeakAuras", ReskinWA)