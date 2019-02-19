local F, C = unpack(select(2, ...))

C.themes["Blizzard_TalentUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinFrame(PlayerTalentFrame)
	F.StripTextures(PlayerTalentFrameTalents, true)
	F.StripTextures(PlayerTalentFrameLockInfo)
	F.ReskinButton(PlayerTalentFrameSpecializationLearnButton)
	F.ReskinButton(PlayerTalentFrameActivateButton)
	F.ReskinButton(PlayerTalentFramePetSpecializationLearnButton)

	hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
		for i = 1, NUM_TALENT_FRAME_TABS do
			local tab = _G["PlayerTalentFrameTab"..i]
			local a1, p, a2, x = tab:GetPoint()

			tab:ClearAllPoints()
			tab:SetPoint(a1, p, a2, x, 2)
		end
	end)

	for i = 1, NUM_TALENT_FRAME_TABS do
		F.ReskinTab(_G["PlayerTalentFrameTab"..i])
	end

	for _, frame in next, {PlayerTalentFrameSpecialization, PlayerTalentFramePetSpecialization} do
		F.StripTextures(frame)
		select(7, frame:GetChildren()):DisableDrawLayer("OVERLAY")

		local scrollChild = frame.spellsScroll.child
		scrollChild.gradient:Hide()
		scrollChild.ring:Hide()
		scrollChild.Seperator:Hide()

		for i = 1, 5 do
			select(i, scrollChild:GetRegions()):Hide()
		end

		F.ReskinIcon(scrollChild.specIcon)

		local roleIcon = scrollChild.roleIcon
		roleIcon:SetTexture(C.media.roleTex)
		F.CreateBDFrame(roleIcon)
	end

	hooksecurefunc("PlayerTalentFrame_UpdateSpecFrame", function(self, spec)
		local playerTalentSpec = GetSpecialization(nil, self.isPet, 1)
		local shownSpec = spec or playerTalentSpec or 1
		local numSpecs = GetNumSpecializations(nil, self.isPet)
		local sex = self.isPet and UnitSex("pet") or UnitSex("player")
		local id, _, _, icon = GetSpecializationInfo(shownSpec, nil, self.isPet, nil, sex)
		if not id then return end
		local scrollChild = self.spellsScroll.child
		scrollChild.specIcon:SetTexture(icon)

		local role1 = GetSpecializationRole(shownSpec, nil, self.isPet)
		if role1 then
			scrollChild.roleIcon:SetTexCoord(F.GetRoleTexCoord(role1))
		end

		local index = 1
		local bonuses
		local bonusesIncrement = 1
		if self.isPet then
			bonuses = {GetSpecializationSpells(shownSpec, nil, self.isPet, true)}
			bonusesIncrement = 2
		else
			bonuses = C_SpecializationInfo.GetSpellsDisplay(id)
		end

		if bonuses then
			for i = 1, #bonuses, bonusesIncrement do
				local frame = scrollChild["abilityButton"..index]
				local _, icon = GetSpellTexture(bonuses[i])
				frame.icon:SetTexture(icon)
				frame.subText:SetTextColor(.75, .75, .75)

				if not frame.styled then
					frame.ring:Hide()
					F.ReskinIcon(frame.icon)

					frame.styled = true
				end
				index = index + 1
			end
		end

		for i = 1, numSpecs do
			local bu = self["specButton"..i]

			if bu.disabled then
				bu.roleName:SetTextColor(.5, .5, .5)
			else
				bu.roleName:SetTextColor(1, 1, 1)
			end
		end
	end)

	for i = 1, GetNumSpecializations(false, nil) do
		local _, _, _, icon = GetSpecializationInfo(i, false, nil)
		PlayerTalentFrameSpecialization["specButton"..i].specIcon:SetTexture(icon)
	end

	for i = 1, GetNumSpecializations(false, true) do
		local icon = select(4, GetSpecializationInfo(i, false, true))
		PlayerTalentFramePetSpecialization["specButton"..i].specIcon:SetTexture(icon)
	end

	local buttons = {"PlayerTalentFrameSpecializationSpecButton", "PlayerTalentFramePetSpecializationSpecButton"}
	for _, name in pairs(buttons) do
		for i = 1, 4 do
			local bu = _G[name..i]
			bu.bg:Hide()
			bu.ring:Hide()
			bu.learnedTex:SetTexture("")
			_G[name..i.."Glow"]:SetTexture("")
			F.ReskinButton(bu)
			F.ReskinTexture(bu.selectedTex, bu, true)

			local ic = bu.specIcon
			ic:SetPoint("LEFT", bu, "LEFT")
			F.ReskinIcon(ic)

			local roleIcon = bu.roleIcon
			roleIcon:SetTexture(C.media.roleTex)
			F.CreateBDFrame(roleIcon, 0)
			local role = GetSpecializationRole(i, false, bu.isPet)
			if role then
				roleIcon:SetTexCoord(F.GetRoleTexCoord(role))
			end
		end
	end

	for i = 1, MAX_TALENT_TIERS do
		local row = _G["PlayerTalentFrameTalentsTalentRow"..i]
		_G["PlayerTalentFrameTalentsTalentRow"..i.."Bg"]:Hide()
		row:DisableDrawLayer("BORDER")

		row.TopLine:SetDesaturated(true)
		row.TopLine:SetVertexColor(r, g, b)
		row.BottomLine:SetDesaturated(true)
		row.BottomLine:SetVertexColor(r, g, b)

		for j = 1, NUM_TALENT_COLUMNS do
			local bu = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]
			F.StripTextures(bu)
			bu.knownSelection:SetAlpha(0)

			local ic = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j.."IconTexture"]
			F.ReskinIcon(ic)

			bu.bg = F.CreateBDFrame(bu, 0)
			bu.bg:SetPoint("TOPLEFT", 10, 0)
			bu.bg:SetPoint("BOTTOMRIGHT")

			F.ReskinTexture(bu.highlight, bu.bg, true)
		end
	end

	hooksecurefunc("TalentFrame_Update", function()
		for i = 1, MAX_TALENT_TIERS do
			for j = 1, NUM_TALENT_COLUMNS do
				local _, _, _, selected, _, _, _, _, _, _, known = GetTalentInfo(i, j, 1)
				local bu = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]
				if known then
					bu.bg:SetBackdropBorderColor(r, g, b)
				elseif selected then
					bu.bg:SetBackdropColor(r, g, b, .25)
				else
					bu.bg:SetBackdropColor(0, 0, 0, 0)
				end
			end
		end
	end)

	PlayerTalentFrameTalentsTutorialButton.Ring:Hide()
	PlayerTalentFrameTalentsTutorialButton:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPLEFT", -12, 12)
	PlayerTalentFrameSpecializationTutorialButton.Ring:Hide()
	PlayerTalentFrameSpecializationTutorialButton:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPLEFT", -12, 12)
	PlayerTalentFramePetSpecializationTutorialButton.Ring:Hide()
	PlayerTalentFramePetSpecializationTutorialButton:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPLEFT", -12, 12)

	-- PVP Talents

	F.ReskinButton(PlayerTalentFrameTalentsPvpTalentButton)
	PlayerTalentFrameTalentsPvpTalentButton:SetSize(20, 20)

	local talentList = PlayerTalentFrameTalentsPvpTalentFrameTalentList
	talentList:ClearAllPoints()
	talentList:SetPoint("LEFT", PlayerTalentFrame, "RIGHT", 2, 0)
	F.ReskinFrame(talentList)

	F.StripTextures(PlayerTalentFrameTalentsPvpTalentFrame)
	F.StripTextures(PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollChild)
	F.ReskinScroll(PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBar)

	local function updatePVPTalent(self)
		if not self.styled then
			self:GetRegions():SetAlpha(0)
			self.SelectedOtherOverlay:SetAlpha(0)

			self.Icon:SetScale(.75)
			self.Icon:SetPoint("LEFT", 9, 1)
			F.ReskinIcon(self.Icon)

			local bg = F.CreateBDFrame(self, 0)
			bg:SetPoint("TOPLEFT", 2, -1)
			bg:SetPoint("BOTTOMRIGHT", 0, 3)

			F.ReskinTexture(self, bg, true)
			F.ReskinTexture(self.Selected, bg, true)

			self.styled = true
		end
	end

	for i = 1, 10 do
		local bu = _G["PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameButton"..i]
		hooksecurefunc(bu, "Update", updatePVPTalent)
	end

	local bu = select(4, PlayerTalentFrameTalentsPvpTalentFrameTalentList:GetChildren())
	F.ReskinButton(bu)
end