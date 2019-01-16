local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	-- Spell
	F.ReskinPortraitFrame(SpellBookFrame, true)
	F.ReskinArrow(SpellBookPrevPageButton, "left")
	F.ReskinArrow(SpellBookNextPageButton, "right")

	SpellBookPageText:SetTextColor(.8, .8, .8)

	SpellBookFrameTabButton1:ClearAllPoints()
	SpellBookFrameTabButton1:SetPoint("TOPLEFT", SpellBookFrame, "BOTTOMLEFT", 0, 2)
	SpellBookSkillLineTab1:SetPoint("TOPLEFT", SpellBookSideTabsFrame, "TOPRIGHT", 2, -36)
	SpellBookFrameTutorialButton.Ring:Hide()
	SpellBookFrameTutorialButton:SetPoint("TOPLEFT", SpellBookFrame, "TOPLEFT", -12, 12)

	for i = 1, 3 do
		F.ReskinTab(_G["SpellBookFrameTabButton"..i])
	end

	for i = 1, SPELLS_PER_PAGE do
		local bu = _G["SpellButton"..i]
		F.StripTextures(bu)

		local ic = _G["SpellButton"..i.."IconTexture"]
		local icbg = F.ReskinIcon(ic, true)

		ic.bg = icbg
	end

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		if SpellBookFrame.bookType ~= BOOKTYPE_PROFESSION then
			local frame = self:GetName()

			local hl = _G[frame.."Highlight"]
			hl:SetColorTexture(1, 1, 1, .25)

			local ic = _G[frame.."IconTexture"]
			ic.bg:SetShown(ic:IsShown())

			local name = _G[frame.."SpellName"]
			name:ClearAllPoints()
			name:SetPoint("TOPLEFT", ic.bg, "TOPRIGHT", 4, -5)

			local subName = _G[frame.."SubSpellName"]
			subName:SetTextColor(1, 1, 1)
			subName:ClearAllPoints()
			subName:SetPoint("BOTTOMLEFT", ic.bg, "BOTTOMRIGHT", 4, 5)

			local lvlName = _G[frame.."RequiredLevelString"]
			lvlName:SetJustifyH("CENTER")
			lvlName:SetTextColor(1, 1, 1)
			lvlName:ClearAllPoints()
			lvlName:SetPoint("CENTER", ic.bg, "CENTER", 1, 0)

			local shine = self.shine
			if shine then
				shine:ClearAllPoints()
				shine:SetPoint("TOPLEFT", ic.bg, 0, 0)
				shine:SetPoint("BOTTOMRIGHT", ic.bg, 0, 0)
			end
		end
	end)

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
		for i = 1, GetNumSpellTabs() do
			local tab = _G["SpellBookSkillLineTab"..i]
			if not tab.styled then
				tab:GetRegions():Hide()
				tab:SetCheckedTexture(C.media.checked)

				local ic = F.ReskinIcon(tab:GetNormalTexture(), true)
				F.ReskinTexture(tab, ic, false)

				tab.styled = true
			end
		end
	end)

	-- Professions
	local professions = {"PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3"}
	for index, button in pairs(professions) do
		local bu = _G[button]
		bu.missingHeader:SetTextColor(1, 1, 1)
		bu.missingText:SetTextColor(1, 1, 1)
		F.StripTextures(bu)

		local bg = F.CreateBDFrame(bu, .25)

		local name = bu.professionName
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", bg, "TOPLEFT", 4, -5)

		local rank = bu.rank
		rank:ClearAllPoints()
		rank:SetPoint("BOTTOMLEFT", bg, "BOTTOMLEFT", 4, 5)

		local bar = bu.statusBar
		bar:SetSize(80, 14)
		bar:ClearAllPoints()
		bar:SetPoint("LEFT", name, "RIGHT", 4, -1)
		bar.rankText:SetPoint("CENTER")
		F.ReskinStatusBar(bar, true, true)

		if index == 1 or index == 2 then
			bg:SetPoint("TOPLEFT", -2, -2)
			bg:SetPoint("BOTTOMRIGHT", 2, -2)

			bu.icon:SetAlpha(1)
			bu.icon:SetDesaturated(false)

			local ic = F.ReskinIcon(bu.icon, true)

			local ub = bu.unlearn
			ub:ClearAllPoints()
			ub:SetPoint("LEFT", ic, "RIGHT", 4, 0)

			bar:SetPoint("LEFT", ub, "RIGHT", 4, 0)
			name:SetPoint("TOPLEFT", ic, "TOPRIGHT", 4, -5)
			rank:SetPoint("BOTTOMLEFT", ic, "BOTTOMRIGHT", 4, 5)
		end
	end

	local professionbuttons = {"PrimaryProfession1SpellButtonTop", "PrimaryProfession1SpellButtonBottom", "PrimaryProfession2SpellButtonTop", "PrimaryProfession2SpellButtonBottom", "SecondaryProfession1SpellButtonLeft", "SecondaryProfession1SpellButtonRight", "SecondaryProfession2SpellButtonLeft", "SecondaryProfession2SpellButtonRight", "SecondaryProfession3SpellButtonLeft", "SecondaryProfession3SpellButtonRight"}

	for index, button in pairs(professionbuttons) do
		local bu = _G[button]
		F.StripTextures(bu)
		bu:SetCheckedTexture(C.media.checked)

		local icon = _G[button.."IconTexture"]
		if index == 1 or index == 2 or index == 3 or index == 4 then
			icon:SetPoint("TOPLEFT", 4, -4)
			icon:SetPoint("BOTTOMRIGHT", -4, 4)
		end

		local ic = F.ReskinIcon(icon, true)
		F.ReskinTexture(bu.highlightTexture, ic, false)

		local nm = _G[button.."SpellName"]
		nm:ClearAllPoints()
		nm:SetPoint("LEFT", ic, "RIGHT", 4, 0)
	end

	hooksecurefunc("FormatProfession", function(frame, index)
		if index then
			local _, texture = GetProfessionInfo(index)

			if frame.icon and texture then
				frame.icon:SetTexture(texture)
			end
		end
	end)

	hooksecurefunc("UpdateProfessionButton", function(self)
		self.highlightTexture:SetColorTexture(1, 1, 1, .25)
		self.spellString:SetTextColor(1, 1, 1);
		self.subSpellString:SetTextColor(1, 1, 1)
	end)
end)