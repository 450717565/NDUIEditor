local F, C = unpack(select(2, ...))

C.themes["Blizzard_TalentUI"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	F.ReskinFrame(PlayerTalentFrame)
	F.ReskinButton(PlayerTalentFrameSpecializationLearnButton)
	F.ReskinButton(PlayerTalentFrameActivateButton)
	F.ReskinButton(PlayerTalentFramePetSpecializationLearnButton)

	local tutorials = {"PlayerTalentFrameSpecialization", "PlayerTalentFrameTalents", "PlayerTalentFramePetSpecialization"}
	for _, name in pairs(tutorials) do
		local bu = _G[name.."TutorialButton"]
		bu.Ring:Hide()
		bu:ClearAllPoints()
		bu:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPLEFT", -12, 12)
	end

	hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
		F.SetupTabStyle(PlayerTalentFrame, NUM_TALENT_FRAME_TABS)
	end)

	-- Talent
	F.StripTextures(PlayerTalentFrameTalents)

	for i = 1, MAX_TALENT_TIERS do
		local button = "PlayerTalentFrameTalentsTalentRow"..i

		local row = _G[button]
		F.StripTextures(row)

		for j = 1, NUM_TALENT_COLUMNS do
			local bu = _G[button.."Talent"..j]
			F.StripTextures(bu)
			bu.knownSelection:SetAlpha(0)

			local bg = F.CreateBDFrame(bu, 0)
			bg:SetPoint("TOPLEFT", 10, 0)
			bg:SetPoint("BOTTOMRIGHT")
			F.ReskinTexture(bu, bg, true)

			local ic = _G[button.."Talent"..j.."IconTexture"]
			F.ReskinIcon(ic)

			bu.bg = bg
		end
	end

	hooksecurefunc("TalentFrame_Update", function()
		for i = 1, MAX_TALENT_TIERS do
			for j = 1, NUM_TALENT_COLUMNS do
				local selected = select(4, GetTalentInfo(i, j, 1))
				local known = select(11, GetTalentInfo(i, j, 1))
				local bu = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]

				if known then
					bu.bg:SetBackdropBorderColor(cr, cg, cb)
				elseif selected then
					bu.bg:SetBackdropColor(cr, cg, cb, .25)
				else
					bu.bg:SetBackdropColor(0, 0, 0, 0)
				end
			end
		end
	end)

	-- Player and Pet
	local buttons = {"PlayerTalentFrameSpecializationSpecButton", "PlayerTalentFramePetSpecializationSpecButton"}
	for _, name in pairs(buttons) do
		for i = 1, 4 do
			local bu = _G[name..i]
			F.StripTextures(bu)

			F.ReskinButton(bu)
			F.ReskinTexture(bu.selectedTex, bu, true)

			local specIcon = bu.specIcon
			specIcon:ClearAllPoints()
			specIcon:SetPoint("LEFT", bu, "LEFT")
			F.ReskinIcon(specIcon)

			if name == "PlayerTalentFrameSpecializationSpecButton" then
				local icon = select(4, GetSpecializationInfo(i, false, false))
				if icon then specIcon:SetTexture(icon) end
			else
				local petic = select(4, GetSpecializationInfo(i, false, true))
				if petic then specIcon:SetTexture(petic) end
			end

			local roleIcon = bu.roleIcon
			F.ReskinRoleIcon(roleIcon)

			local role = GetSpecializationRole(i, false, bu.isPet)
			if role then
				roleIcon:SetTexCoord(F.GetRoleTexCoord(role))
			end
		end
	end

	for _, frame in pairs({PlayerTalentFrameSpecialization, PlayerTalentFramePetSpecialization}) do
		F.StripTextures(frame)
		select(7, frame:GetChildren()):Hide()

		local scrollChild = frame.spellsScroll.child
		F.StripTextures(scrollChild)
		scrollChild.gradient:Hide()
		scrollChild.Seperator:Hide()

		F.ReskinIcon(scrollChild.specIcon)
		F.ReskinRoleIcon(scrollChild.roleIcon)
	end

	hooksecurefunc("PlayerTalentFrame_UpdateSpecFrame", function(self, spec)
		local playerTalentSpec = GetSpecialization(nil, self.isPet, 1)
		local shownSpec = spec or playerTalentSpec or 1
		local numSpecs = GetNumSpecializations(nil, self.isPet)
		local sex = self.isPet and UnitSex("pet") or UnitSex("player")
		local specID, _, _, icon = GetSpecializationInfo(shownSpec, nil, self.isPet, nil, sex)

		if not specID then return end

		local scrollChild = self.spellsScroll.child
		scrollChild.specIcon:SetTexture(icon)

		local role1 = GetSpecializationRole(shownSpec, nil, self.isPet)
		if role1 then
			scrollChild.roleIcon:SetTexCoord(F.GetRoleTexCoord(role1))
		end

		local index = 1
		local bonuses
		local bonusesIncrement = 1
		local disable = (playerTalentSpec and shownSpec ~= playerTalentSpec) or petNotActive

		if self.isPet then
			bonuses = {GetSpecializationSpells(shownSpec, nil, self.isPet, true)}
			bonusesIncrement = 2
		else
			bonuses = C_SpecializationInfo.GetSpellsDisplay(specID)
		end

		if bonuses then
			for i = 1, #bonuses, bonusesIncrement do
				local frame = scrollChild["abilityButton"..index]
				local _, icon = GetSpellTexture(bonuses[i])
				frame.icon:SetTexture(icon)

				if not frame.styled then
					F.StripTextures(frame)
					F.ReskinIcon(frame.icon)

					frame.styled = true
				end

				index = index + 1
			end
		end

		if self.disabled then
			scrollChild.specName:SetTextColor(.5, .5, .5)
			scrollChild.roleName:SetTextColor(.5, .5, .5)
			scrollChild.primaryStat:SetTextColor(.5, .5, .5)
			scrollChild.description:SetTextColor(.5, .5, .5)
		else
			scrollChild.specName:SetTextColor(cr, cg, cb)
			scrollChild.roleName:SetTextColor(1, .8, 0)
			scrollChild.primaryStat:SetTextColor(1, 1, 1)
			scrollChild.description:SetTextColor(1, .8, 0)
		end
	end)

	-- PVP Talents
	PlayerTalentFrameTalentsPvpTalentButton:SetSize(20, 20)
	F.ReskinButton(PlayerTalentFrameTalentsPvpTalentButton)
	F.StripTextures(PlayerTalentFrameTalentsPvpTalentFrame)

	local TalentList = PlayerTalentFrameTalentsPvpTalentFrameTalentList
	TalentList:ClearAllPoints()
	TalentList:SetPoint("LEFT", PlayerTalentFrame, "RIGHT", 2, 0)

	F.ReskinFrame(TalentList)

	local close = select(4, TalentList:GetChildren())
	F.ReskinButton(close)

	local ScrollFrame = TalentList.ScrollFrame
	F.ReskinScroll(ScrollFrame.ScrollBar)

	for i = 1, 10 do
		local bu = ScrollFrame.buttons[i]
		F.StripTextures(bu)

		local icon = bu.Icon
		icon:SetSize(34, 34)

		local icbg = F.ReskinIcon(icon)
		local bubg = F.CreateBDFrame(bu, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", 0, 2)

		F.ReskinTexture(bu, bubg, true)
		F.ReskinTexture(bu.Selected, bubg, true)

		local name = bu.Name
		name:ClearAllPoints()
		name:SetPoint("LEFT", bubg, 4, 0)
	end
end