local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	SpellBookFrame:DisableDrawLayer("BACKGROUND")
	SpellBookFrame:DisableDrawLayer("BORDER")
	SpellBookFrame:DisableDrawLayer("OVERLAY")
	SpellBookFrameInset:DisableDrawLayer("BORDER")

	F.SetBD(SpellBookFrame)
	F.ReskinClose(SpellBookFrameCloseButton)

	SpellBookFrameTabButton1:ClearAllPoints()
	SpellBookFrameTabButton1:SetPoint("TOPLEFT", SpellBookFrame, "BOTTOMLEFT", 0, 2)

	for i = 1, 5 do
		F.ReskinTab(_G["SpellBookFrameTabButton"..i])
	end

	for i = 1, SPELLS_PER_PAGE do
		local bu = _G["SpellButton"..i]
		local ic = _G["SpellButton"..i.."IconTexture"]

		_G["SpellButton"..i.."SlotFrame"]:SetAlpha(0)
		_G["SpellButton"..i.."Highlight"]:SetAlpha(0)

		bu.EmptySlot:SetAlpha(0)
		bu.TextBackground:Hide()
		bu.TextBackground2:Hide()
		bu.UnlearnedFrame:SetAlpha(0)

		bu:SetCheckedTexture("")
		bu:SetPushedTexture("")

		ic:SetTexCoord(.08, .92, .08, .92)

		ic.bg = F.CreateBDFrame(ic)
	end

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		if SpellBookFrame.bookType == BOOKTYPE_PROFESSION then return end

		local slot, slotType = SpellBook_GetSpellBookSlot(self);
		local name = self:GetName();
		local subSpellString = _G[name.."SubSpellName"]

		local isOffSpec = self.offSpecID ~= 0 and SpellBookFrame.bookType == BOOKTYPE_SPELL

		subSpellString:SetTextColor(1, 1, 1)

		if slotType == "FUTURESPELL" then
			local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
			if level and level > UnitLevel("player") then
				self.SpellName:SetTextColor(.7, .7, .7)
				subSpellString:SetTextColor(.7, .7, .7)
			end
		else
			if slotType == "SPELL" and isOffSpec then
				subSpellString:SetTextColor(.7, .7, .7)
			end
		end

		self.RequiredLevelString:SetTextColor(.7, .7, .7)

		local ic = _G[name.."IconTexture"]
		if not ic.bg then return end
		if ic:IsShown() then
			ic.bg:Show()
		else
			ic.bg:Hide()
		end
	end)

	SpellBookSkillLineTab1:SetPoint("TOPLEFT", SpellBookSideTabsFrame, "TOPRIGHT", 2, -36)

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
		for i = 1, GetNumSpellTabs() do
			local tab = _G["SpellBookSkillLineTab"..i]
			local nt = tab:GetNormalTexture()
			if nt then
				nt:SetTexCoord(.08, .92, .08, .92)
			end

			if not tab.styled then
				tab:GetRegions():Hide()
				tab:SetCheckedTexture(C.media.checked)
				F.CreateBDFrame(tab)

				tab.styled = true
			end
		end
	end)

	SpellBookFrameTutorialButton.Ring:Hide()
	SpellBookFrameTutorialButton:SetPoint("TOPLEFT", SpellBookFrame, "TOPLEFT", -12, 12)

	-- Professions

	local professions = {"PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3"}

	for _, button in pairs(professions) do
		local bu = _G[button]
		bu.professionName:SetTextColor(1, 1, 1)
		bu.missingHeader:SetTextColor(1, 1, 1)
		bu.missingText:SetTextColor(1, 1, 1)

		bu.statusBar:SetHeight(13)
		bu.statusBar.rankText:SetPoint("CENTER")

		local _, p = bu.statusBar:GetPoint()
		bu.statusBar:SetPoint("TOPLEFT", p, "BOTTOMLEFT", 0, -1)

		F.ReskinStatusBar(bu.statusBar, true, true)
	end

	local professionbuttons = {"PrimaryProfession1SpellButtonTop", "PrimaryProfession1SpellButtonBottom", "PrimaryProfession2SpellButtonTop", "PrimaryProfession2SpellButtonBottom", "SecondaryProfession1SpellButtonLeft", "SecondaryProfession1SpellButtonRight", "SecondaryProfession2SpellButtonLeft", "SecondaryProfession2SpellButtonRight", "SecondaryProfession3SpellButtonLeft", "SecondaryProfession3SpellButtonRight"}

	for _, button in pairs(professionbuttons) do
		local icon = _G[button.."IconTexture"]
		local bu = _G[button]
		_G[button.."NameFrame"]:SetAlpha(0)

		bu:SetPushedTexture("")
		bu:SetCheckedTexture(C.media.checked)
		bu:GetHighlightTexture():Hide()

		if icon then
			icon:SetTexCoord(.08, .92, .08, .92)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 2, -2)
			icon:SetPoint("BOTTOMRIGHT", -2, 2)
			F.CreateBDFrame(icon)
		end
	end

	for i = 1, 2 do
		local bu = _G["PrimaryProfession"..i]
		local ub = _G["PrimaryProfession"..i.."UnlearnButton"]

		_G["PrimaryProfession"..i.."IconBorder"]:Hide()

		bu.professionName:ClearAllPoints()
		bu.professionName:SetPoint("TOPLEFT", 100, -4)

		bu.icon:SetAlpha(1)
		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon:SetDesaturated(false)
		F.CreateBDFrame(bu.icon)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, -4)
		bg:SetFrameLevel(0)
		F.CreateBD(bg, .25)
		F.CreateSD(bg)

		ub:ClearAllPoints()
		ub:SetPoint("LEFT", bu.icon, "RIGHT", 7, 0)
	end

	hooksecurefunc("FormatProfession", function(frame, index)
		if index then
			local _, texture = GetProfessionInfo(index)

			if frame.icon and texture then
				frame.icon:SetTexture(texture)
			end
		end
	end)

	local frames = {SecondaryProfession1, SecondaryProfession2, SecondaryProfession3}
	for _, frame in next, frames do
		F.CreateBD(frame, .25)
		F.CreateSD(frame)
	end
	F.ReskinArrow(SpellBookPrevPageButton, "left")
	F.ReskinArrow(SpellBookNextPageButton, "right")
	SpellBookPageText:SetTextColor(.8, .8, .8)

	hooksecurefunc("UpdateProfessionButton", function(self)
		self.spellString:SetTextColor(1, 1, 1);
		self.subSpellString:SetTextColor(1, 1, 1)
	end)
end)