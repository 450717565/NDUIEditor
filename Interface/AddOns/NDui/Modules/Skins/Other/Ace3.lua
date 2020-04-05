local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")
local TT = B:GetModule("Tooltip")

function S:Ace3()
	local AceGUI = LibStub("AceGUI-3.0", true)
	if not AceGUI then return end

	local cr, cg, cb = DB.r, DB.g, DB.b

	local function reskinTab(tab)
		B.StripTextures(tab)
		tab.bg = B.CreateBDFrame(tab, 0)
		tab.bg:SetInside(nil, 8, 2)

		B.ReskinHighlight(tab, tab.bg, true)
		hooksecurefunc(tab, "SetSelected", function(self, selected)
			if selected then
				self.bg:SetBackdropColor(cr, cg, cb, .25)
			else
				self.bg:SetBackdropColor(0, 0, 0, .25)
			end
		end)
	end

	if AceGUITooltip then
		AceGUITooltip:HookScript("OnShow", TT.ReskinTooltip)
	end

	if AceConfigDialogTooltip then
		AceConfigDialogTooltip:HookScript("OnShow", TT.ReskinTooltip)
	end

	local oldRegisterAsWidget = AceGUI.RegisterAsWidget
	AceGUI.RegisterAsWidget = function(self, widget)
		local TYPE = widget.type
		if TYPE == "MultiLineEditBox" then
			B.StripTextures(widget.scrollBG)
			local bg = B.CreateBDFrame(widget.scrollBG, 0)
			bg:SetPoint("TOPLEFT", 0, -2)
			bg:SetPoint("BOTTOMRIGHT", -2, 1)
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
			check:SetDesaturated(true)
			check:SetVertexColor(cr, cg, cb)

			local checkbg = widget.checkbg
			B.StripTextures(checkbg)
			checkbg:SetTexture("")
			checkbg.SetTexture = B.Dummy
			local bdTex = B.CreateBDFrame(checkbg, 0, -4)

			local highlight = widget.highlight
			B.StripTextures(highlight)
			B.ReskinHighlight(highlight, bdTex, true)
			highlight.SetTexture = B.Dummy
		elseif TYPE == "Dropdown" then
			local button = widget.button
			B.ReskinArrow(button, "down")
			button:SetSize(20, 20)

			local dropdown = widget.dropdown
			B.StripTextures(dropdown)
			local bg = B.CreateBDFrame(dropdown, 0)
			bg:ClearAllPoints()
			bg:SetPoint("TOPLEFT", dropdown, "TOPLEFT", 18, -1)
			bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -1, 0)

			local text = widget.text
			text:SetJustifyH("CENTER")
			text:ClearAllPoints()
			text:SetPoint("CENTER", bg, 1, 0)

			local label = widget.label
			label:SetJustifyH("LEFT")
			label:ClearAllPoints()
			label:SetPoint("BOTTOMLEFT", bg, "TOPLEFT", 0, 1)

			button:HookScript("PostClick", function(self) TT.ReskinTooltip(self.obj.pullout.frame) end)
			widget.button_cover:HookScript("PostClick", function(self) TT.ReskinTooltip(self.obj.pullout.frame) end)
		elseif TYPE == "LSM30_Font" or TYPE == "LSM30_Sound" or TYPE == "LSM30_Border" or TYPE == "LSM30_Background" or TYPE == "LSM30_Statusbar" then
			local frame = widget.frame
			B.StripTextures(frame)
			local bg = B.CreateBDFrame(frame, 0)
			bg:ClearAllPoints()
			bg:SetPoint("TOPLEFT", 2, -22)
			bg:SetPoint("BOTTOMRIGHT", -22, 2)

			local button = frame.dropButton
			B.ReskinArrow(button, "down")
			button:SetParent(bg)
			button:ClearAllPoints()
			button:SetPoint("LEFT", bg, "RIGHT", 1, 0)
			button:SetSize(20, 20)

			button:HookScript("PostClick", function(this)
				local self = this.obj
				if self.dropdown then
					TT.ReskinTooltip(self.dropdown)
					if self.dropdown.slider then
						B.ReskinSlider(self.dropdown.slider)
					end
				end
			end)

			local text = frame.text
			text:SetParent(bg)
			text:SetJustifyH("CENTER")
			text:ClearAllPoints()
			text:SetPoint("CENTER", bg, 1, 0)

			local label = frame.label
			label:SetJustifyH("LEFT")
			label:ClearAllPoints()
			label:SetPoint("BOTTOMLEFT", bg, "TOPLEFT", 0, 1)

			if TYPE == "LSM30_Sound" then
				widget.soundbutton:SetParent(bg)
				widget.soundbutton:ClearAllPoints()
				widget.soundbutton:SetPoint("RIGHT", bg, "LEFT", -1, 0)
			elseif TYPE == "LSM30_Statusbar" then
				widget.bar:SetParent(bg)
				widget.bar:ClearAllPoints()
				widget.bar:SetPoint("TOPLEFT", bg, "TOPLEFT", 2, -2)
				widget.bar:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -1, 0)
			end
		elseif TYPE == "EditBox" then
			B.ReskinButton(widget.button)
			local bg = B.ReskinInput(widget.editbox)
			bg:SetPoint("TOPLEFT", 0, -2)
			bg:SetPoint("BOTTOMRIGHT", 0, 2)

			hooksecurefunc(widget.editbox, "SetPoint", function(self, a, b, c, d, e)
				if d == 7 then
					self:SetPoint(a, b, c, 0, e)
				end
			end)
		elseif TYPE == "Button" then
			B.ReskinButton(widget.frame)
		elseif TYPE == "Slider" then
			B.ReskinSlider(widget.slider)
			local bg = B.ReskinInput(widget.editbox)
			bg:SetPoint("TOPLEFT", 0, -2)
			bg:SetPoint("BOTTOMRIGHT", 0, 2)

			widget.editbox:ClearAllPoints()
			widget.editbox:SetPoint("TOP", widget.slider, "BOTTOM", 0, -1)
		elseif TYPE == "Keybinding" then
			local button = widget.button
			B.ReskinButton(button)

			local msgframe = widget.msgframe
			B.StripTextures(msgframe)
			B.SetBDFrame(msgframe)
			msgframe.msg:ClearAllPoints()
			msgframe.msg:SetPoint("CENTER")
		elseif TYPE == "Icon" then
			B.StripTextures(widget.frame)
		elseif TYPE == "WeakAurasDisplayButton" then
			B.ReskinExpandOrCollapse(widget.expand)
			widget.expand.SetPushedTexture = B.Dummy
		elseif TYPE == "WeakAurasMultiLineEditBox" then
			B.StripTextures(widget.scrollBG)
			local bg = B.CreateBDFrame(widget.scrollBG, 1)
			bg:SetPoint("TOPLEFT", 0, -2)
			bg:SetPoint("BOTTOMRIGHT", -2, 1)
			B.ReskinButton(widget.button)
			B.ReskinScroll(widget.scrollBar)

			widget.scrollBar:SetPoint("RIGHT", widget.frame, "RIGHT", 0 -4)
			widget.scrollBG:SetPoint("TOPRIGHT", widget.scrollBar, "TOPLEFT", -2, 19)
			widget.scrollBG:SetPoint("BOTTOMLEFT", widget.button, "TOPLEFT")
			widget.scrollFrame:SetPoint("BOTTOMRIGHT", widget.scrollBG, "BOTTOMRIGHT", -4, 8)

			widget.frame:HookScript("OnShow", function()
				if widget.extraButtons and not widget.frame.styled then
					for _, button in next, widget.extraButtons do
						B.ReskinButton(button)
					end
					widget.frame.styled = true
				end
			end)
		elseif TYPE == "WeakAurasLoadedHeaderButton" then
			B.ReskinExpandOrCollapse(widget.expand)
			widget.expand.SetPushedTexture = B.Dummy
		end

		return oldRegisterAsWidget(self, widget)
	end

	local oldRegisterAsContainer = AceGUI.RegisterAsContainer
	AceGUI.RegisterAsContainer = function(self, widget)
		local TYPE = widget.type

		if TYPE == "ScrollFrame" then
			B.ReskinScroll(widget.scrollbar)
		elseif TYPE == "InlineGroup" or TYPE == "TreeGroup" or TYPE == "TabGroup" or TYPE == "Frame" or TYPE == "DropdownGroup" or TYPE =="Window" then
			local frame = widget.content:GetParent()
			B.StripTextures(frame)
			if TYPE == "Frame" then
				for i = 1, frame:GetNumChildren() do
					local child = select(i, frame:GetChildren())
					if child:GetObjectType() == "Button" and child:GetText() then
						B.ReskinButton(child)
					else
						B.StripTextures(child)
					end
				end
				B.SetBDFrame(frame)
			else
				local bg = B.CreateBDFrame(frame, 0)
				bg:SetInside(nil, 2, 2)
			end

			if TYPE == "Window" then
				B.ReskinClose(frame.obj.closebutton)
			end

			if widget.treeframe then
				local bg = B.CreateBDFrame(widget.treeframe, 0)
				bg:SetInside(nil, 2, 2)

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
							B.ReskinExpandOrCollapse(toggle)
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
					reskinTab(tab)

					return tab
				end
			end

			if widget.scrollbar then
				B.ReskinScroll(widget.scrollbar)
			end
		end

		return oldRegisterAsContainer(self, widget)
	end
end