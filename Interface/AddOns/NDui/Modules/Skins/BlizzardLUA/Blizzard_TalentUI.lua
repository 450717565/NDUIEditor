local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_PvPTalentList(self, _, selectedOther)
	if selectedOther then
		self.bubg:SetBackdropBorderColor(cr, cg, cb)
	else
		self.bubg:SetBackdropBorderColor(0, 0, 0)
	end
end

local function Reskin_UpdateSpecFrame(self, spec)
	local playerTalentSpec = GetSpecialization(nil, self.isPet, 1)
	local shownSpec = spec or playerTalentSpec or 1
	local numSpecs = GetNumSpecializations(nil, self.isPet)
	local sex = self.isPet and UnitSex("pet") or UnitSex("player")
	local id, _, _, icon, role = GetSpecializationInfo(shownSpec, nil, self.isPet, nil, sex)

	if not id then return end

	local scrollChild = self.spellsScroll.child
	scrollChild.specIcon:SetTexture(icon)
	if role then
		scrollChild.roleIcon:SetTexCoord(B.GetRoleTexCoord(role))
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

			if not frame.styled then
				B.StripTextures(frame)
				B.ReskinIcon(frame.icon)

				frame.styled = true
			end

			if self.disabled then
				B.ReskinText(frame.name, .5, .5, .5)
			else
				B.ReskinText(frame.name, 1, 1, 1)
			end

			index = index + 1
		end
	end

	for i = 1, numSpecs do
		local bu = self["specButton"..i]
		if bu.disabled then
			B.ReskinText(bu.roleName, .5, .5, .5)
		else
			B.ReskinText(bu.roleName, 1, 1, 1)
		end
	end

	if self.disabled then
		B.ReskinText(scrollChild.specName, .5, .5, .5)
		B.ReskinText(scrollChild.roleName, .5, .5, .5)
		B.ReskinText(scrollChild.primaryStat, .5, .5, .5)
		B.ReskinText(scrollChild.description, .5, .5, .5)
	else
		B.ReskinText(scrollChild.specName, cr, cg, cb)
		B.ReskinText(scrollChild.roleName, 1, .8, 0)
		B.ReskinText(scrollChild.primaryStat, 1, 1, 1)
		B.ReskinText(scrollChild.description, 1, .8, 0)
	end
end

local function Reskin_TalentFrame()
	for i = 1, MAX_TALENT_TIERS do
		for j = 1, NUM_TALENT_COLUMNS do
			local selected = select(4, GetTalentInfo(i, j, 1))
			local known = select(11, GetTalentInfo(i, j, 1))
			local bu = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]

			if known then
				bu.bubg:SetBackdropBorderColor(cr, cg, cb)
			elseif selected then
				bu.bubg:SetBackdropColor(cr, cg, cb, .5)
			else
				bu.bubg:SetBackdropBorderColor(0, 0, 0)
				bu.bubg:SetBackdropColor(0, 0, 0, 0)
			end
		end
	end
end

C.LUAThemes["Blizzard_TalentUI"] = function()
	B.ReskinFrame(PlayerTalentFrame)
	B.ReskinButton(PlayerTalentFrameSpecializationLearnButton)
	B.ReskinButton(PlayerTalentFrameActivateButton)
	B.ReskinButton(PlayerTalentFramePetSpecializationLearnButton)

	hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
		B.ReskinFrameTab(PlayerTalentFrame, NUM_TALENT_FRAME_TABS)
	end)

	-- Specialization
	local frames = {
		PlayerTalentFrameSpecialization,
		PlayerTalentFramePetSpecialization,
	}
	for _, frame in pairs(frames) do
		B.StripTextures(frame)

		local children = {frame:GetChildren()}
		for _, child in pairs(children) do
			if child:IsObjectType("Frame") and not child:GetName() then
				B.StripTextures(child)
			end
		end

		local scrollChild = frame.spellsScroll.child
		B.StripTextures(scrollChild)
		B.ReskinIcon(scrollChild.specIcon)
		B.ReskinRoleIcon(scrollChild.roleIcon)

		local tutorial = _G[frame:GetDebugName().."TutorialButton"]
		S.ReskinTutorialButton(tutorial, PlayerTalentFrame)

		for i = 1, 4 do
			local bu = frame["specButton"..i]
			local _, _, _, icon, role = GetSpecializationInfo(i, false, frame.isPet)
			B.StripTextures(bu)
			B.ReskinButton(bu)
			B.ReskinHighlight(bu.selectedTex, bu.bgTex, true)

			local specIcon = bu.specIcon
			specIcon:SetTexture(icon)
			specIcon:ClearAllPoints()
			specIcon:SetPoint("LEFT", bu, "LEFT")
			B.ReskinIcon(specIcon)

			local roleIcon = bu.roleIcon
			local icbg = B.ReskinRoleIcon(roleIcon)
			icbg:SetFrameLevel(bu:GetFrameLevel())
			if role then
				roleIcon:SetTexCoord(B.GetRoleTexCoord(role))
			end
		end
	end

	hooksecurefunc("PlayerTalentFrame_UpdateSpecFrame", Reskin_UpdateSpecFrame)

	-- Talents
	B.StripTextures(PlayerTalentFrameTalents)
	S.ReskinTutorialButton(PlayerTalentFrameTalentsTutorialButton, PlayerTalentFrame)

	for i = 1, MAX_TALENT_TIERS do
		local button = "PlayerTalentFrameTalentsTalentRow"..i

		local row = _G[button]
		B.StripTextures(row)

		for j = 1, NUM_TALENT_COLUMNS do
			local bu = _G[button.."Talent"..j]
			B.StripTextures(bu)
			bu.knownSelection:SetAlpha(0)

			local bubg = B.CreateBGFrame(bu, 10, 0, 0, 0)
			B.ReskinHighlight(bu, bubg, true)

			local icon = _G[button.."Talent"..j.."IconTexture"]
			B.ReskinIcon(icon)

			bu.bubg = bubg
		end
	end

	hooksecurefunc("TalentFrame_Update", Reskin_TalentFrame)

	-- PVP Talents
	B.StripTextures(PlayerTalentFrameTalentsPvpTalentFrame)
	B.ReskinButton(PlayerTalentFrameTalentsPvpTalentButton)

	PlayerTalentFrameTalentsPvpTalentButton:SetSize(20, 20)

	local TalentList = PlayerTalentFrameTalentsPvpTalentFrameTalentList
	TalentList:ClearAllPoints()
	TalentList:SetPoint("LEFT", PlayerTalentFrame, "RIGHT", 2, 0)

	B.ReskinFrame(TalentList)

	local close = select(4, TalentList:GetChildren())
	B.ReskinButton(close)

	local ScrollFrame = TalentList.ScrollFrame
	B.ReskinScroll(ScrollFrame.ScrollBar)

	for i = 1, 10 do
		local bu = ScrollFrame.buttons[i]
		B.StripTextures(bu)

		local icon = bu.Icon
		icon:SetSize(32, 32)

		local icbg = B.ReskinIcon(icon)
		local bubg = B.CreateBGFrame(bu, 2, 0, 0, 0, icbg)
		B.ReskinHighlight(bu, bubg, true)
		B.ReskinHighlight(bu.Selected, bubg, true)

		local name = bu.Name
		name:ClearAllPoints()
		name:SetPoint("LEFT", bubg, 4, 0)

		bu.bubg = bubg

		hooksecurefunc(bu, "Update", Reskin_PvPTalentList)
	end
end