local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_UpdateButton(self)
	if SpellBookFrame.bookType == BOOKTYPE_SPELL then
		local frame = self:GetDebugName()

		local hl = _G[frame.."Highlight"]
		hl:SetColorTexture(1, 1, 1, .25)

		local icon = _G[frame.."IconTexture"]
		self.icbg:SetShown(icon:IsShown())

		local name = _G[frame.."SpellName"]
		name:SetWordWrap(false)
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", self.icbg, "TOPRIGHT", 4, -5)

		local subName = _G[frame.."SubSpellName"]
		B.ReskinText(subName, 1, 1, 1)
		subName:ClearAllPoints()
		subName:SetPoint("BOTTOMLEFT", self.icbg, "BOTTOMRIGHT", 4, 5)

		local lvlName = _G[frame.."RequiredLevelString"]
		B.ReskinText(lvlName, 1, 1, 1)
		lvlName:SetJustifyH("CENTER")
		lvlName:ClearAllPoints()
		lvlName:SetPoint("CENTER", self.icbg, "CENTER", 1, 0)

		local shine = self.shine
		if shine then
			shine:SetInside(self.icbg)
		end

		local glyph = self.GlyphIcon
		if glyph then
			glyph:SetAtlas("GlyphIcon-Spellbook")
			glyph:ClearAllPoints()
			glyph:SetPoint("TOPRIGHT", self.icbg, 2, 2)
		end

		local highlight = self.SpellHighlightTexture
		if highlight and highlight:IsShown() then
			B.ReskinText(name, cr, cg, cb)
		else
			B.ReskinText(name, 1, .8, 0)
		end
	end
end

local function Reskin_UpdateSkillLineTabs()
	if SpellBookFrame.bookType == BOOKTYPE_SPELL then
		SpellBookSkillLineTab1:SetNormalTexture("Interface\\Icons\\INV_Misc_Book_09")

		for i = 1, GetNumSpellTabs() do
			local tab = _G["SpellBookSkillLineTab"..i]
			if tab and not tab.styled then
				B.ReskinSideTab(tab)

				tab.styled = true
			end
		end
	end
end

local function Update_FormatProfession(frame, index)
	if SpellBookFrame.bookType == BOOKTYPE_PROFESSION then
		if index then
			local _, texture = GetProfessionInfo(index)

			if frame.icon and texture then
				frame.icon:SetTexture(texture)
			end
		end
	end
end

local function Update_UpdateProfessionButton(self)
	if SpellBookFrame.bookType == BOOKTYPE_PROFESSION then
		B.ReskinText(self.spellString, 1, 1, 1)
		B.ReskinText(self.subSpellString, 1, 1, 1)

		self.highlightTexture:SetColorTexture(1, 1, 1, .25)
	end
end

tinsert(C.XMLThemes, function()
	B.ReskinFrame(SpellBookFrame)
	B.ReskinFrameTab(SpellBookFrame, 3, "TabButton")
	S.ReskinTutorialButton(SpellBookFrameTutorialButton, SpellBookFrame)

	-- Spell
	B.ReskinText(SpellBookPageText, 1, 1, 1)
	B.ReskinArrow(SpellBookPrevPageButton, "left")
	B.ReskinArrow(SpellBookNextPageButton, "right")

	SpellBookSkillLineTab1:ClearAllPoints()
	SpellBookSkillLineTab1:SetPoint("TOPLEFT", SpellBookFrame, "TOPRIGHT", 2, -25)

	for i = 1, SPELLS_PER_PAGE do
		local button = _G["SpellButton"..i]
		B.StripTextures(button)

		local icon = _G["SpellButton"..i.."IconTexture"]
		local icbg = B.ReskinIcon(icon)
		B.ReskinCPTex(button, icbg)

		button.icbg = icbg
	end

	hooksecurefunc("SpellButton_UpdateButton", Reskin_UpdateButton)
	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", Reskin_UpdateSkillLineTabs)

	-- PrimaryProfession
	local primaryProfession = {
		PrimaryProfession1,
		PrimaryProfession2,
		SecondaryProfession1,
		SecondaryProfession2,
		SecondaryProfession3,
	}
	for index, button in pairs(primaryProfession) do
		B.StripTextures(button)
		B.ReskinText(button.missingText, 1, 1, 1)
		B.ReskinText(button.missingHeader, 1, 1, 1)

		local bubg = B.CreateBDFrame(button)

		local name = button.professionName
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", bubg, "TOPLEFT", 4, -5)

		local rank = button.rank
		rank:ClearAllPoints()
		rank:SetPoint("BOTTOMLEFT", bubg, "BOTTOMLEFT", 4, 5)

		local bar = button.statusBar
		bar:SetSize(80, 14)
		bar:ClearAllPoints()
		bar:SetPoint("LEFT", name, "RIGHT", 4, -1)
		B.ReskinStatusBar(bar)

		if index <= 2 then
			bubg:SetPoint("TOPLEFT", -2, -2)
			bubg:SetPoint("BOTTOMRIGHT", 2, -2)

			button.icon:SetAlpha(1)
			button.icon:SetDesaturated(false)
			button.icon:SetDrawLayer("OVERLAY")

			local icbg = B.ReskinIcon(button.icon)

			local unlearn = button.unlearn
			unlearn:ClearAllPoints()
			unlearn:SetPoint("LEFT", icbg, "RIGHT", 4, 0)

			name:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 4, -5)
			rank:SetPoint("BOTTOMLEFT", icbg, "BOTTOMRIGHT", 4, 5)
		end
	end

	hooksecurefunc("FormatProfession", Update_FormatProfession)

	-- SecondaryProfession
	local secondaryProfession = {
		"PrimaryProfession1SpellButtonTop",
		"PrimaryProfession1SpellButtonBottom",
		"PrimaryProfession2SpellButtonTop",
		"PrimaryProfession2SpellButtonBottom",
		"SecondaryProfession1SpellButtonLeft",
		"SecondaryProfession1SpellButtonRight",
		"SecondaryProfession2SpellButtonLeft",
		"SecondaryProfession2SpellButtonRight",
		"SecondaryProfession3SpellButtonLeft",
		"SecondaryProfession3SpellButtonRight",
	}
	for index, buttons in pairs(secondaryProfession) do
		local button = _G[buttons]
		B.StripTextures(button)

		local icon = _G[buttons.."IconTexture"]
		if index <= 4 then
			icon:SetInside(nil, 4, 4)
		end

		local icbg = B.ReskinIcon(icon)
		B.ReskinCPTex(button, icbg)
		B.ReskinHLTex(button.highlightTexture, icbg)

		local name = _G[buttons.."SpellName"]
		name:ClearAllPoints()
		name:SetPoint("LEFT", icbg, "RIGHT", 4, 0)
	end

	hooksecurefunc("UpdateProfessionButton", Update_UpdateProfessionButton)
end)