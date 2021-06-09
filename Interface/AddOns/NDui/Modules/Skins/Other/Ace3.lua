local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")
local TT = B:GetModule("Tooltip")

----------------------------
-- Credit: ElvUI
-- 修改：雨夜独行客
----------------------------

local _G = getfenv(0)
local select, pairs, type = select, pairs, type
local cr, cg, cb = DB.cr, DB.cg, DB.cb
local tL, tR, tT, tB = unpack(DB.TexCoord)
local EarlyAceWidgets = {}

function Skins:Ace3()
	local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
	if not AceGUI then return end

	if AceGUITooltip then
		AceGUITooltip:HookScript("OnShow", TT.ReskinTooltip)
	end
	if AceConfigDialogTooltip then
		AceConfigDialogTooltip:HookScript("OnShow", TT.ReskinTooltip)
	end

	for _, n in pairs(EarlyAceWidgets) do
		if n.SetLayout then
			Skins:Ace3_RegisterAsContainer(n)
		else
			Skins:Ace3_RegisterAsWidget(n)
		end
	end
end

function Skins:Ace3_SkinDropdown()
	if self and self.obj then
		if self.obj.pullout and self.obj.pullout.frame then
			TT.ReskinTooltip(self.obj.pullout.frame)
			self.obj.pullout.frame.SetBackdrop = B.Dummy
		elseif self.obj.dropdown then
			TT.ReskinTooltip(self.obj.dropdown)
			self.obj.dropdown.SetBackdrop = B.Dummy
			if self.obj.dropdown.slider then
				B.ReskinSlider(self.obj.dropdown.slider)
			end
		end
	end
end

function Skins:Ace3_SkinTab(tab)
	B.StripTextures(tab)
	tab.bg = B.CreateBGFrame(tab, 8, -2, -8, 2)

	B.ReskinHLTex(tab, tab.bg, true)
	hooksecurefunc(tab, "SetSelected", function(self, selected)
		if selected then
			self.bg:SetBackdropColor(cr, cg, cb, .5)
		else
			self.bg:SetBackdropColor(0, 0, 0, 0)
		end
	end)
end

local WeakAuras_RegionType = {
	["icon"] = true,
	["group"] = true,
	["dynamicgroup"] = true,
}

function Skins:WeakAuras_SkinIcon(icon)
	if type(icon) ~= "table" or not icon.icon then return end

	if WeakAuras_RegionType[self.data.regionType] then
		icon.icon:SetTexCoord(tL, tR, tT, tB)
	end
end

function Skins:WeakAuras_UpdateIcon()
	if not self.thumbnail or not self.thumbnail.icon then return end

	if WeakAuras_RegionType[self.data.regionType] then
		self.thumbnail.icon:SetTexCoord(tL, tR, tT, tB)
	end
end

function Skins:Ace3_RegisterAsWidget(widget)
	local TYPE = widget.type
	if TYPE == "MultiLineEditBox" then
		B.StripTextures(widget.scrollBG)
		B.CreateBGFrame(widget.scrollBG, 0, -2, -2, 1)
		B.ReskinButton(widget.button)
		B.ReskinScroll(widget.scrollBar)

		widget.scrollBar:SetPoint("RIGHT", widget.frame, "RIGHT", 0 -4)
		widget.scrollBG:SetPoint("TOPRIGHT", widget.scrollBar, "TOPLEFT", -2, 19)
		widget.scrollBG:SetPoint("BOTTOMLEFT", widget.button, "TOPLEFT")
		widget.scrollFrame:SetPoint("BOTTOMRIGHT", widget.scrollBG, "BOTTOMRIGHT", -4, 8)
	elseif TYPE == "CheckBox" then
		local check = widget.check
		B.StripTextures(check)
		check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
		check:SetTexCoord(0, 1, 0, 1)
		check:SetVertexColor(cr, cg, cb)
		check:SetDesaturated(true)
		check.SetDesaturated = B.Dummy

		local checkbg = widget.checkbg
		B.StripTextures(checkbg)
		checkbg:SetTexture("")
		checkbg.SetTexture = B.Dummy
		local bg = B.CreateBDFrame(checkbg, 0, 4)

		local highlight = widget.highlight
		B.StripTextures(highlight)
		B.ReskinHLTex(highlight, bg, true)
		highlight.SetTexture = B.Dummy

		hooksecurefunc(widget, "SetDisabled", function(self, disabled)
			local check = self.check
			if disabled then
				check:SetVertexColor(.8, .8, .8)
			else
				check:SetVertexColor(cr, cg, cb)
			end
		end)

		hooksecurefunc(widget, "SetType", function(self, type)
			if type == "radio" then
				self.check:SetTexture(DB.bgTex)
				self.check:SetInside(self.checkbg, 4, 4)
			else
				self.check:SetAllPoints(self.checkbg)
			end
		end)
	elseif TYPE == "Dropdown" or TYPE == "LQDropdown" then
		local button_cover = widget.button_cover
		button_cover:HookScript("OnClick", Skins.Ace3_SkinDropdown)

		local button = widget.button
		B.ReskinArrow(button, "down", 20)
		button:ClearAllPoints()
		button:SetPoint("RIGHT", -18, 2)
		button:HookScript("OnClick", Skins.Ace3_SkinDropdown)

		local dropdown = widget.dropdown
		B.StripTextures(dropdown)

		local bg = B.CreateBDFrame(dropdown)
		bg:ClearAllPoints()
		bg:SetPoint("LEFT", dropdown, "LEFT", 16, 0)
		bg:SetPoint("TOP", button, "TOP", 0, 0)
		bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -2, 0)

		local text = widget.text
		text:SetJustifyH("CENTER")
		text:ClearAllPoints()
		text:SetPoint("CENTER", bg, 1, 0)

		local label = widget.label
		label:SetJustifyH("LEFT")
		label:ClearAllPoints()
		label:SetPoint("BOTTOMLEFT", bg, "TOPLEFT", 0, 1)
	elseif TYPE == "LSM30_Font" or TYPE == "LSM30_Sound" or TYPE == "LSM30_Border" or TYPE == "LSM30_Background" or TYPE == "LSM30_Statusbar" then
		local frame = widget.frame
		B.StripTextures(frame)

		local bg = B.CreateBDFrame(frame)
		bg:ClearAllPoints()
		bg:SetPoint("LEFT", frame, "LEFT", 16, 0)
		bg:SetPoint("TOP", frame.dropButton, "TOP", 0, 0)
		bg:SetPoint("BOTTOMRIGHT", frame.dropButton, "BOTTOMLEFT", -2, 0)

		local button = frame.dropButton
		B.ReskinArrow(button, "down", 20)
		button:ClearAllPoints()
		button:SetPoint("RIGHT", -18, 2)
		button:HookScript("OnClick", Skins.Ace3_SkinDropdown)
		button:SetParent(bg)

		local text = frame.text
		text:SetJustifyH("CENTER")
		text:ClearAllPoints()
		text:SetPoint("CENTER", bg, 1, 0)
		text:SetParent(bg)

		local label = frame.label
		label:SetJustifyH("LEFT")
		label:ClearAllPoints()
		label:SetPoint("BOTTOMLEFT", bg, "TOPLEFT", 0, 1)

		if TYPE == "LSM30_Sound" then
			widget.soundbutton:ClearAllPoints()
			widget.soundbutton:SetPoint("RIGHT", bg, "LEFT", -1, 0)
			widget.soundbutton:SetParent(bg)
		elseif TYPE == "LSM30_Statusbar" then
			widget.bar:ClearAllPoints()
			widget.bar:SetPoint("TOPLEFT", bg, "TOPLEFT", 2, -2)
			widget.bar:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -1, 0)
			widget.bar:SetParent(bg)
		elseif TYPE == "LSM30_Border" or TYPE == "LSM30_Background" then
			bg:SetPoint("TOPLEFT", 45, -22)
		end
	elseif TYPE == "EditBox" then
		B.ReskinButton(widget.button)
		local bg = B.ReskinInput(widget.editbox)
		bg:SetInside(nil, 0, 2)

		hooksecurefunc(widget.editbox, "SetPoint", function(self, a, b, c, d, e)
			if d == 7 then
				self:SetPoint(a, b, c, 0, e)
			end
		end)
	elseif TYPE == "Button" or TYPE == "MacroButton" then
		B.ReskinButton(widget.frame)
	elseif TYPE == "Slider" then
		B.ReskinSlider(widget.slider)
		B.ReskinInput(widget.editbox)

		widget.editbox:ClearAllPoints()
		widget.editbox:SetPoint("TOP", widget.slider, "BOTTOM", 0, -1)
	elseif TYPE == "Keybinding" then
		local button = widget.button
		B.ReskinButton(button)

		local msgframe = widget.msgframe
		B.ReskinFrame(msgframe)
		msgframe.msg:ClearAllPoints()
		msgframe.msg:SetPoint("CENTER")
	elseif TYPE == "Icon" then
		B.StripTextures(widget.frame)
	elseif TYPE == "WeakAurasDisplayButton" then
		B.ReskinInput(widget.renamebox)

		local expand = widget.expand
		B.ReskinCollapse(expand)
		expand:SetPushedTexture("")
		expand.SetPushedTexture = B.Dummy

		local button = widget.frame
		button.group.texture:SetTexture(DB.rotationRigh)

		local icon = widget.icon
		icon:ClearAllPoints()
		icon:SetPoint("LEFT", button, "LEFT", 1, 0)

		local icbg = B.ReskinIcon(icon)
		B.ReskinHLTex(button.highlight, icbg)

		hooksecurefunc(widget, "SetIcon", Skins.WeakAuras_SkinIcon)
		hooksecurefunc(widget, "UpdateThumbnail", Skins.WeakAuras_UpdateIcon)
	elseif TYPE == "WeakAurasNewButton" then
		local icon = widget.icon
		icon:SetPoint("LEFT", widget.frame, "LEFT", 1, 0)

		local icbg = B.ReskinIcon(icon)
		B.ReskinHLTex(widget.frame.highlight, icbg)
	elseif TYPE == "WeakAurasMultiLineEditBox" then
		B.StripTextures(widget.scrollBG)
		B.CreateBGFrame(widget.scrollBG, 0, -2, -2, 1)
		B.ReskinButton(widget.button)
		B.ReskinScroll(widget.scrollBar)

		widget.scrollBar:SetPoint("RIGHT", widget.frame, "RIGHT", 0 -4)
		widget.scrollBG:SetPoint("TOPRIGHT", widget.scrollBar, "TOPLEFT", -2, 19)
		widget.scrollBG:SetPoint("BOTTOMLEFT", widget.button, "TOPLEFT")
		widget.scrollFrame:SetPoint("BOTTOMRIGHT", widget.scrollBG, "BOTTOMRIGHT", -4, 8)

		widget.frame:HookScript("OnShow", function()
			if widget.extraButtons then
				for _, button in pairs(widget.extraButtons) do
					if button and not button.styled then
						B.ReskinButton(button)

						button.styled = true
					end
				end
			end
		end)
	elseif TYPE == "WeakAurasLoadedHeaderButton" then
		B.ReskinCollapse(widget.expand)
		widget.expand:SetPushedTexture("")
		widget.expand.SetPushedTexture = B.Dummy
	elseif TYPE == "WeakAurasIconButton" then
		B.ReskinIcon(widget.texture)
		B.ReskinHLTex(widget.frame)
	elseif TYPE == "WeakAurasTextureButton" then
		local button = widget.frame
		local bg = B.CreateBDFrame(button)
		B.ReskinHLTex(button, bg)
	end
end

function Skins:Ace3_RegisterAsContainer(widget)
	local TYPE = widget.type
	if TYPE == "ScrollFrame" then
		B.ReskinScroll(widget.scrollbar)
	elseif TYPE == "InlineGroup" or TYPE == "TreeGroup" or TYPE == "TabGroup" or TYPE == "Frame" or TYPE == "DropdownGroup" or TYPE =="Window" then
		local frame = widget.content:GetParent()
		B.StripTextures(frame)
		if TYPE == "Frame" then
			local children = {frame:GetChildren()}
			for _, child in pairs(children) do
				if child:IsObjectType("Button") and child:GetText() then
					B.ReskinButton(child)
				else
					B.StripTextures(child)
				end
			end
			B.CreateBG(frame)
		else
			B.CreateBDFrame(frame, 0, 2)
		end

		if TYPE == "Window" then
			B.ReskinClose(frame.obj.closebutton)
		end

		if widget.treeframe then
			B.CreateBDFrame(widget.treeframe, 0, 2)

			local oldRefreshTree = widget.RefreshTree
			widget.RefreshTree = function(self, scrollToSelection)
				oldRefreshTree(self, scrollToSelection)
				if not self.tree then return end
				local status = self.status or self.localstatus
				local lines = self.lines
				local buttons = self.buttons
				local offset = status.scrollvalue

				for i = offset + 1, #lines do
					local button = buttons[i - offset]
					if button and not button.styled then
						local toggle = button.toggle
						B.ReskinCollapse(toggle)
						toggle.SetPushedTexture = B.Dummy

						button.styled = true
					end
				end
			end
		end

		if TYPE == "TabGroup" then
			local oldCreateTab = widget.CreateTab
			widget.CreateTab = function(self, id)
				local tab = oldCreateTab(self, id)
				Skins:Ace3_SkinTab(tab)

				return tab
			end
		end

		if widget.scrollbar then
			B.ReskinScroll(widget.scrollbar)
			widget.scrollbar:DisableDrawLayer("BACKGROUND")
		end

		if TYPE == "WeakAurasTreeGroup" then
			local treeframe = widget.treeframe
			local treeframeBG = treeframe:GetChildren()
			treeframeBG:SetAlpha(0)
		end
	end
end

function Skins:Ace3_MetaTable(lib)
	local t = getmetatable(lib)
	if t then
		t.__newindex = Skins.Ace3_MetaIndex
	else
		setmetatable(lib, {__newindex = Skins.Ace3_MetaIndex})
	end
end

function Skins:Ace3_MetaIndex(k, v)
	if k == "RegisterAsContainer" then
		rawset(self, k, function(s, w, ...)
			if C.db["Skins"]["BlizzardSkins"] then
				Skins.Ace3_RegisterAsContainer(s, w, ...)
			end

			return v(s, w, ...)
		end)
	elseif k == "RegisterAsWidget" then
		rawset(self, k, function(...)
			if C.db["Skins"]["BlizzardSkins"] then
				Skins.Ace3_RegisterAsWidget(...)
			end

			return v(...)
		end)
	else
		rawset(self, k, v)
	end
end

-- versions of AceGUI and AceConfigDialog.
local minorGUI, minorConfigDialog = 36, 76
local lastMinor = 0
function Skins:HookAce3(lib, minor, earlyLoad) -- lib: AceGUI
	if not lib or (not minor or minor < minorGUI) then return end

	local earlyContainer, earlyWidget
	local oldMinor = lastMinor
	if lastMinor < minor then
		lastMinor = minor
	end
	if earlyLoad then
		earlyContainer = lib.RegisterAsContainer
		earlyWidget = lib.RegisterAsWidget
	end
	if earlyLoad or oldMinor ~= minor then
		lib.RegisterAsContainer = nil
		lib.RegisterAsWidget = nil
	end

	if not lib.RegisterAsWidget then
		Skins:Ace3_MetaTable(lib)
	end

	if earlyContainer then lib.RegisterAsContainer = earlyContainer end
	if earlyWidget then lib.RegisterAsWidget = earlyWidget end
end


do -- Early Skin Loading
	local Libraries = {
		["AceGUI"] = true,
	}

	local LibStub = _G.LibStub
	if not LibStub then return end

	local numEnding = "%-[%d%.]+$"
	function Skins:LibStub_NewLib(major, minor)
		local earlyLoad = major == "ElvUI"
		if earlyLoad then major = minor end

		local n = gsub(major, numEnding, "")
		if Libraries[n] then
			if n == "AceGUI" then
				Skins:HookAce3(LibStub.libs[major], LibStub.minors[major], earlyLoad)
			end
		end
	end

	local findWidget
	local function earlyWidget(y)
		if y.children then findWidget(y.children) end
		if y.frame and (y.base and y.base.Release) then
			tinsert(EarlyAceWidgets, y)
		end
	end

	findWidget = function(x)
		for _, y in pairs(x) do
			earlyWidget(y)
		end
	end

	for n in pairs(LibStub.libs) do
		if n == "AceGUI-3.0" then
			local children = {_G.UIParent:GetChildren()}
			for _, x in pairs(children) do
				if x and x.obj then earlyWidget(x.obj) end
			end
		end
		if Libraries[gsub(n, numEnding, "")] then
			Skins:LibStub_NewLib("ElvUI", n)
		end
	end

	hooksecurefunc(LibStub, "NewLibrary", Skins.LibStub_NewLib)
end