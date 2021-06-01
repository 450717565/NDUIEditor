local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local pairs, unpack = pairs, unpack

local function Update_IconTexCoord(self)
	if self.isCutting then return end
	self.isCutting = true

	local width, height = self:GetSize()
	if width ~= 0 and height ~= 0 then
		local left, right, top, bottom = unpack(DB.TexCoord) -- normal icon
		local ratio = width/height
		if ratio > 1 then -- fat icon
			local offset = (1 - 1/ratio) / 2
			top = top + offset
			bottom = bottom - offset
		elseif ratio < 1 then -- thin icon
			local offset = (1 - ratio) / 2
			left = left + offset
			bottom = bottom - offset
		end
		self:SetTexCoord(left, right, top, bottom)
	end

	self.isCutting = nil
end

local function Reskin_Region(self, fType)
	if fType == "icon" then
		if not self.icon.styled then
			Update_IconTexCoord(self.icon)
			hooksecurefunc(self.icon, "SetTexCoord", Update_IconTexCoord)

			local icbg = B.CreateBDFrame(self.icon, 0, -C.mult, true)
			icbg:SetFrameLevel(0)

			self.icon.styled = true
		end
	elseif fType == "aurabar" then
		if not self.bar.styled then
			Update_IconTexCoord(self.icon)
			hooksecurefunc(self.icon, "SetTexCoord", Update_IconTexCoord)

			local icbg = B.CreateBDFrame(self.icon, 0, -C.mult, true)
			icbg:SetFrameLevel(0)

			local barbg = B.CreateBDFrame(self.bar, 0, -C.mult, true)
			barbg:SetFrameLevel(0)

			self.bar.styled = true
		end
	end
end

local function Reskin_ChildButton(self)
	if not self then return end

	local children = {self:GetChildren()}
	for _, child in pairs(children) do
		if child:IsObjectType("Button") and child.Text then
			B.ReskinButton(child)
		end
	end
end

local function Remove_Border(self)
	local regions = {self:GetRegions()}
	for _, region in pairs(regions) do
		local texture = region.GetTexture and region:GetTexture()
		if texture and texture ~= "" and type(texture) == "string" and texture:find("Quickslot2") then
			region:SetTexture("")
		end
	end
end

local function Reskin_WAOptions()
	local frame = _G.WeakAurasOptions
	if not frame or frame.styled then return end

	B.ReskinFrame(frame)
	B.ReskinInput(frame.filterInput, 18)
	B.ReskinButton(_G.WASettingsButton)

	-- Minimize, Close Button
	local children = {frame:GetChildren()}
	for _, child in pairs(children) do
		local numRegions = child:GetNumRegions()
		local numChildren = child:GetNumChildren()

		if numRegions == 3 and numChildren == 1 and child.PixelSnapDisabled then
			B.StripTextures(child)

			local button = child:GetChildren()
			local texturePath = button.GetNormalTexture and button:GetNormalTexture():GetTexture()
			if texturePath and type(texturePath) == "string" and texturePath:find("CollapseButton") then
				B.ReskinArrow(button, "max")
				button.SetNormalTexture = B.Dummy
				button.SetPushedTexture = B.Dummy
				button:ClearAllPoints()
				button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, -6)

				button:HookScript("OnClick",function(self)
					if frame.minimized then
						button.arrowTex:SetTexture(DB.arrowTex.."max")
					else
						button.arrowTex:SetTexture(DB.arrowTex.."min")
					end
				end)
			else
				B.ReskinClose(button, frame)
				button:SetSize(18, 18)
			end
		end
	end

	-- Child Groups
	local childGroups = {
		"texturePicker",
		"iconPicker",
		"modelPicker",
		"importexport",
		"texteditor",
		"codereview",
	}

	for _, key in pairs(childGroups) do
		local group = frame[key]
		if group then
			Reskin_ChildButton(group.frame)
		end
	end

	-- IconPicker
	local iconPicker = frame.iconPicker.frame
	if iconPicker then
		local children = {iconPicker:GetChildren()}
		for _, child in pairs(children) do
			if child:IsObjectType("EditBox") then
				B.ReskinInput(child, 20)
			end
		end
	end

	-- Right Side Container
	local container = frame.container.content:GetParent()
	if container and container.bg then
		container.bg:Hide()
	end

	-- WeakAurasSnippets
	local snippets = _G.WeakAurasSnippets
	B.ReskinFrame(snippets)
	Reskin_ChildButton(snippets)

	-- MoverSizer
	local moversizer = frame.moversizer
	B.CreateBDFrame(moversizer)

	local index = 1
	local children = {moversizer:GetChildren()}
	for _, child in pairs(children) do
		local numChildren = child:GetNumChildren()

		if numChildren == 2 and child:IsClampedToScreen() then
			local button1, button2 = child:GetChildren()
			if index == 1 then
				B.ReskinArrow(button1, "up")
				B.ReskinArrow(button2, "down")
			else
				B.ReskinArrow(button1, "left")
				B.ReskinArrow(button2, "right")
			end

			index = index + 1
		end
	end

	-- TipPopup
	local children = {frame:GetChildren()}
	for _, child in pairs(children) do
		if child:GetFrameStrata() == "FULLSCREEN" and child.PixelSnapDisabled and child.backdropInfo then
			B.ReskinFrame(child)

			local subChildren = {child:GetChildren()}
			for _, subChild in pairs(subChildren) do
				if subChild:IsObjectType("EditBox") then
					B.ReskinInput(subChild, 18)
				end
			end

			break
		end
	end

	frame.styled = true
end

local function Reskin_WeakAuras()
	local regionTypes = WeakAuras.regionTypes
	local Create_Icon, Modify_Icon = regionTypes.icon.create, regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = regionTypes.aurabar.create, regionTypes.aurabar.modify

	regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		Reskin_Region(region, "icon")
		return region
	end

	regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		Reskin_Region(region, "aurabar")
		return region
	end

	regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		Reskin_Region(region, "icon")
	end

	regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		Reskin_Region(region, "aurabar")
	end

	for weakAura in pairs(WeakAuras.regions) do
		local regions = WeakAuras.regions[weakAura]
		if regions.regionType == "icon" or regions.regionType == "aurabar" then
			Reskin_Region(regions.region, regions.regionType)
		end
	end

	local WeakAuras = _G.WeakAuras
	if not WeakAuras then return end

	-- WeakAurasTooltip
	Reskin_ChildButton(_G.WeakAurasTooltipImportButton:GetParent())
	B.ReskinRadio(_G.WeakAurasTooltipRadioButtonCopy)
	B.ReskinRadio(_G.WeakAurasTooltipRadioButtonUpdate)

	local index = 1
	local check = _G["WeakAurasTooltipCheckButton"..index]
	while check do
		B.ReskinCheck(check)
		index = index + 1
		check = _G["WeakAurasTooltipCheckButton"..index]
	end

	-- Remove Aura Border (Credit: ElvUI_WindTools)
	if WeakAuras.RegisterRegionOptions then
		local origRegisterRegionOptions = WeakAuras.RegisterRegionOptions

		WeakAuras.RegisterRegionOptions = function(name, createFunction, icon, displayName, createThumbnail, ...)
			if type(icon) == "function" then
				local OldIcon = icon
				icon = function()
					local f = OldIcon()
					Remove_Border(f)
					return f
				end
			end

			if type(createThumbnail) == "function" then
				local OldCreateThumbnail = createThumbnail
				createThumbnail = function()
					local f = OldCreateThumbnail()
					Remove_Border(f)
					return f
				end
			end

			return origRegisterRegionOptions(name, createFunction, icon, displayName, createThumbnail, ...)
		end
	end

	-- WeakAurasOptions
	local count = 0
	local function loadFunc(event, addon)
		if addon == "WeakAurasOptions" then
			hooksecurefunc(WeakAuras, "ShowOptions", Reskin_WAOptions)
			count = count + 1
		end

		if addon == "WeakAurasTemplates" then
			if WeakAuras.CreateTemplateView then
				local origCreateTemplateView = WeakAuras.CreateTemplateView
				WeakAuras.CreateTemplateView = function(...)
					local group = origCreateTemplateView(...)
					Reskin_ChildButton(group.frame)

					return group
				end
			end
			count = count + 1
		end

		if count >= 2 then
			B:UnregisterEvent(event, loadFunc)
		end
	end
	B:RegisterEvent("ADDON_LOADED", loadFunc)
end

Skins.LoadWithAddOn("WeakAuras", "WeakAuras", Reskin_WeakAuras)