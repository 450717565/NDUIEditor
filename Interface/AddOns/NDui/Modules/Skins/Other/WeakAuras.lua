local B, C, L, DB = unpack(select(2, ...))
local Skins = B:GetModule("Skins")

local pairs, unpack = pairs, unpack

local function UpdateIconTexCoord(icon)
	if icon.isCutting then return end
	icon.isCutting = true

	local width, height = icon:GetSize()
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
		icon:SetTexCoord(left, right, top, bottom)
	end

	icon.isCutting = nil
end

local function Skin_WeakAuras(self, fType)
	if fType == "icon" then
		if not self.icon.styled then
			UpdateIconTexCoord(self.icon)
			hooksecurefunc(self.icon, "SetTexCoord", UpdateIconTexCoord)

			local icbg = B.ReskinIcon(self.icon)
			icbg:SetFrameLevel(0)
			icbg:SetFrameStrata("BACKGROUND")

			self.icon.SetTexCoord = B.Dummy

			self.icon.styled = true
		end
	elseif fType == "aurabar" then
		if not self.bar.styled then
			UpdateIconTexCoord(self.icon)
			hooksecurefunc(self.icon, "SetTexCoord", UpdateIconTexCoord)

			local icbg = B.ReskinIcon(self.icon)
			icbg:SetFrameLevel(0)
			icbg:SetFrameStrata("BACKGROUND")

			self.icon.SetTexCoord = B.Dummy

			local bg = B.CreateBDFrame(self.bar, 0, C.mult, true)
			bg:SetFrameLevel(0)
			bg:SetFrameStrata("BACKGROUND")

			self.bar.styled = true
		end
	end
end

local function reskinChildButton(self)
	for i = 1, self:GetNumChildren() do
		local child = select(i, self:GetChildren())
		if child:GetObjectType() == 'Button' and child.Text then
			B.ReskinButton(child)
		end
	end
end

local function removeBorder(self)
	for _, region in pairs {self:GetRegions()} do
		local texture = region.GetTexture and region:GetTexture()
		if texture and texture ~= "" and type(texture) == "string" and texture:find("Quickslot2") then
			region:SetTexture("")
		end
	end
end

local function ReskinWAOptions()
	local frame = _G.WeakAurasOptions
	if not frame or frame.styled then return end

	B.ReskinFrame(frame)
	B.ReskinEditBox(frame.filterInput, 18)
	B.ReskinButton(_G.WASettingsButton)

	-- Minimize, Close Button
	for i = 1, frame:GetNumChildren() do
		local child = select(i, frame:GetChildren())
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
			reskinChildButton(group.frame)
		end
	end

	-- IconPicker
	local iconPicker = frame.iconPicker.frame
	if iconPicker then
		for i = 1, iconPicker:GetNumChildren() do
			local child = select(i, iconPicker:GetChildren())
			if child:GetObjectType() == 'EditBox' then
				B.ReskinEditBox(child, 20)
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
	reskinChildButton(snippets)

	-- WeakAurasTemplates
	hooksecurefunc(WeakAuras, "OpenTriggerTemplate", function()
		if frame.newView and not frame.newView.styled then
			reskinChildButton(frame.newView.frame)
			frame.newView.styled = true
		end
	end)

	-- MoverSizer
	local moversizer = frame.moversizer
	B.CreateBDFrame(moversizer)

	local index = 1
	for i = 1, moversizer:GetNumChildren() do
		local child = select(i, moversizer:GetChildren())
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
	for i = 1, frame:GetNumChildren() do
		local child = select(i, frame:GetChildren())
		if child:GetFrameStrata() == "FULLSCREEN" and child.PixelSnapDisabled and child.backdropInfo then
			B.ReskinFrame(child)

			for j = 1, child:GetNumChildren() do
				local child2 = select(j, child:GetChildren())
				if child2:GetObjectType() == "EditBox" then
					B.ReskinEditBox(child2, 18)
				end
			end
			break
		end
	end

	frame.styled = true
end

local function ReskinWA()
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

	local WeakAuras = _G.WeakAuras
	if not WeakAuras then return end

	-- WeakAurasTooltip
	local tooltipAnchor = _G.WeakAurasTooltipImportButton:GetParent()
	reskinChildButton(tooltipAnchor)
	B.ReskinRadio(WeakAurasTooltipRadioButtonCopy)
	B.ReskinRadio(WeakAurasTooltipRadioButtonUpdate)

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
					removeBorder(f)
					return f
				end
			end

			if type(createThumbnail) == "function" then
				local OldCreateThumbnail = createThumbnail
				createThumbnail = function()
					local f = OldCreateThumbnail()
					removeBorder(f)
					return f
				end
			end

			return origRegisterRegionOptions(name, createFunction, icon, displayName, createThumbnail, ...)
		end
	end

	-- WeakAurasOptions
	local function loadFunc(event, addon)
		if addon == "WeakAurasOptions" then
			hooksecurefunc(WeakAuras, "ShowOptions", ReskinWAOptions)
			B:UnregisterEvent(event, loadFunc)
		end
	end
	B:RegisterEvent("ADDON_LOADED", loadFunc)
end

Skins.LoadWithAddOn("WeakAuras", "WeakAuras", ReskinWA)