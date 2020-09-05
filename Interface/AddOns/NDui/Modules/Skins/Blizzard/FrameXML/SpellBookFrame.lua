local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	-- Spell
	B.ReskinFrame(SpellBookFrame)
	B.ReskinArrow(SpellBookPrevPageButton, "left")
	B.ReskinArrow(SpellBookNextPageButton, "right")
	B.ReskinFrameTab(SpellBookFrame, 3, "TabButton")

	SpellBookPageText:SetTextColor(.8, .8, .8)
	SpellBookSkillLineTab1:ClearAllPoints()
	SpellBookSkillLineTab1:SetPoint("TOPLEFT", SpellBookFrame, "TOPRIGHT", 3, -25)
	SpellBookFrameTutorialButton.Ring:Hide()
	SpellBookFrameTutorialButton:ClearAllPoints()
	SpellBookFrameTutorialButton:SetPoint("TOPLEFT", SpellBookFrame, "TOPLEFT", -12, 12)

	for i = 1, SPELLS_PER_PAGE do
		local bu = _G["SpellButton"..i]
		B.StripTextures(bu)

		local ic = _G["SpellButton"..i.."IconTexture"]
		local icbg = B.ReskinIcon(ic)

		ic.icbg = icbg
	end

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		if SpellBookFrame.bookType ~= BOOKTYPE_PROFESSION then
			local frame = self:GetDebugName()

			local hl = _G[frame.."Highlight"]
			hl:SetColorTexture(1, 1, 1, .25)

			local ic = _G[frame.."IconTexture"]
			ic.icbg:SetShown(ic:IsShown())

			local name = _G[frame.."SpellName"]
			name:ClearAllPoints()
			name:SetPoint("TOPLEFT", ic.icbg, "TOPRIGHT", 4, -5)

			local subName = _G[frame.."SubSpellName"]
			subName:SetTextColor(1, 1, 1)
			subName:ClearAllPoints()
			subName:SetPoint("BOTTOMLEFT", ic.icbg, "BOTTOMRIGHT", 4, 5)

			local lvlName = _G[frame.."RequiredLevelString"]
			lvlName:SetJustifyH("CENTER")
			lvlName:SetTextColor(1, 1, 1)
			lvlName:ClearAllPoints()
			lvlName:SetPoint("CENTER", ic.icbg, "CENTER", 1, 0)

			local shine = self.shine
			if shine then
				shine:SetInside(icbg)
			end

			local glyph = self.GlyphIcon
			if glyph then
				glyph:SetAtlas("GlyphIcon-Spellbook")
				glyph:ClearAllPoints()
				glyph:SetPoint("TOPRIGHT", ic.icbg, 2, 2)
			end

			local highlight = self.SpellHighlightTexture
			if highlight and highlight:IsShown() then
				ic.icbg:SetBackdropBorderColor(cr, cg, cb)
			else
				ic.icbg:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end)

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
		if SpellBookFrame.bookType == BOOKTYPE_SPELL then
			for i = 1, GetNumSpellTabs() do
				local tab = _G["SpellBookSkillLineTab"..i]
				local icon = tab:GetNormalTexture()

				if tab and not tab.styled then
					tab:SetSize(32, 32)
					tab:GetRegions():Hide()

					tab.styled = true
				end

				if icon and not icon.styled then
					local icbg = B.ReskinIcon(icon, 1)
					B.ReskinHighlight(tab, icbg)
					B.ReskinChecked(tab, icbg)

					icon.styled = true
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
		B.StripTextures(bu)

		local bubg = B.CreateBDFrame(bu, 0)

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
		B.ReskinStatusBar(bar)

		if index <= 2 then
			bubg:SetPoint("TOPLEFT", -2, -2)
			bubg:SetPoint("BOTTOMRIGHT", 2, -2)

			bu.icon:SetAlpha(1)
			bu.icon:SetDesaturated(false)
			bu.icon:SetDrawLayer("OVERLAY")

			local icbg = B.ReskinIcon(bu.icon)

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
		B.StripTextures(bu)

		local icon = _G[button.."IconTexture"]
		if index <= 4 then
			icon:SetInside(nil, 4, 4)
		end

		local icbg = B.ReskinIcon(icon)
		B.ReskinChecked(bu, icbg)
		B.ReskinHighlight(bu.highlightTexture, icbg)

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