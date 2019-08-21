local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	-- Spell
	F.ReskinFrame(SpellBookFrame)
	F.ReskinArrow(SpellBookPrevPageButton, "left")
	F.ReskinArrow(SpellBookNextPageButton, "right")
	F.SetupTabStyle(SpellBookFrame, 3, "TabButton")

	SpellBookPageText:SetTextColor(.8, .8, .8)
	SpellBookSkillLineTab1:ClearAllPoints()
	SpellBookSkillLineTab1:SetPoint("TOPLEFT", SpellBookFrame, "TOPRIGHT", 4, -25)
	SpellBookFrameTutorialButton.Ring:Hide()
	SpellBookFrameTutorialButton:ClearAllPoints()
	SpellBookFrameTutorialButton:SetPoint("TOPLEFT", SpellBookFrame, "TOPLEFT", -12, 12)

	for i = 1, SPELLS_PER_PAGE do
		local bu = _G["SpellButton"..i]
		F.StripTextures(bu)

		local ic = _G["SpellButton"..i.."IconTexture"]
		local icbg = F.ReskinIcon(ic)

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

			local glyph = self.GlyphIcon
			if glyph then
				glyph:SetAtlas("GlyphIcon-Spellbook")
			end
		end
	end)

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
		if SpellBookFrame.bookType == BOOKTYPE_SPELL then
			for i = 1, GetNumSpellTabs() do
				local tab = _G["SpellBookSkillLineTab"..i]
				local icon = tab:GetNormalTexture()

				if tab and not tab.styled then
					tab:SetSize(34, 34)
					tab:GetRegions():Hide()
					tab:SetCheckedTexture(C.media.checked)

					if icon and not icon.styled then
						local icbg = F.ReskinIcon(icon, false, 1)
						F.ReskinTexture(tab, icbg)

						icon.styled = true
					end

					tab.styled = true
				end
			end
		end
	end)

	-- PrimaryProfession
	local primaryProfession = {"PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3"}
	for index, button in pairs(primaryProfession) do
		local bu = _G[button]
		bu.missingHeader:SetTextColor(1, 1, 1)
		bu.missingText:SetTextColor(1, 1, 1)
		F.StripTextures(bu)

		local bubg = F.CreateBDFrame(bu, 0)

		local name = bu.professionName
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", bubg, "TOPLEFT", 4, -5)

		local rank = bu.rank
		rank:ClearAllPoints()
		rank:SetPoint("BOTTOMLEFT", bubg, "BOTTOMLEFT", 4, 5)

		local bar = bu.statusBar
		bar:SetSize(80, 14)
		bar:ClearAllPoints()
		bar:SetPoint("LEFT", name, "RIGHT", 4, -1)
		F.ReskinStatusBar(bar)

		if index <= 2 then
			bubg:SetPoint("TOPLEFT", -2, -2)
			bubg:SetPoint("BOTTOMRIGHT", 2, -2)

			bu.icon:SetAlpha(1)
			bu.icon:SetDesaturated(false)
			bu.icon:SetDrawLayer("OVERLAY")

			local icbg = F.ReskinIcon(bu.icon, false, 1)

			local unlearn = bu.unlearn
			unlearn:ClearAllPoints()
			unlearn:SetPoint("LEFT", icbg, "RIGHT", 4, 0)

			name:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 4, -5)
			rank:SetPoint("BOTTOMLEFT", icbg, "BOTTOMRIGHT", 4, 5)
		end
	end

	hooksecurefunc("FormatProfession", function(frame, index)
		if SpellBookFrame.bookType ~= BOOKTYPE_PROFESSION then return end

		if index then
			local _, texture = GetProfessionInfo(index)

			if frame.icon and texture then
				frame.icon:SetTexture(texture)
			end
		end
	end)

	-- SecondaryProfession
	local secondaryProfession = {"PrimaryProfession1SpellButtonTop", "PrimaryProfession1SpellButtonBottom", "PrimaryProfession2SpellButtonTop", "PrimaryProfession2SpellButtonBottom", "SecondaryProfession1SpellButtonLeft", "SecondaryProfession1SpellButtonRight", "SecondaryProfession2SpellButtonLeft", "SecondaryProfession2SpellButtonRight", "SecondaryProfession3SpellButtonLeft", "SecondaryProfession3SpellButtonRight"}
	for index, button in pairs(secondaryProfession) do
		local bu = _G[button]
		F.StripTextures(bu)

		local icon = _G[button.."IconTexture"]
		if index <= 4 then
			icon:SetPoint("TOPLEFT", 4, -4)
			icon:SetPoint("BOTTOMRIGHT", -4, 4)
		end

		local icbg = F.ReskinIcon(icon)
		F.ReskinTexed(bu, icbg)
		F.ReskinTexture(bu.highlightTexture, icbg)

		local name = _G[button.."SpellName"]
		name:ClearAllPoints()
		name:SetPoint("LEFT", icbg, "RIGHT", 4, 0)
	end

	hooksecurefunc("UpdateProfessionButton", function(self)
		if SpellBookFrame.bookType ~= BOOKTYPE_PROFESSION then return end

		self.highlightTexture:SetColorTexture(1, 1, 1, .25)
		self.spellString:SetTextColor(1, 1, 1)
		self.subSpellString:SetTextColor(1, 1, 1)
	end)
end)