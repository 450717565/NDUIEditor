local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	if AuroraConfig.loot then
		F.ReskinPortraitFrame(LootFrame, true)
		F.ReskinArrow(LootFrameUpButton, "up")
		F.ReskinArrow(LootFrameDownButton, "down")

		hooksecurefunc("LootFrame_UpdateButton", function(index)
			local ic = _G["LootButton"..index.."IconTexture"]

			if not ic.bg then
				local bu = _G["LootButton"..index]

				_G["LootButton"..index.."IconQuestTexture"]:SetAlpha(0)
				_G["LootButton"..index.."NameFrame"]:Hide()

				bu:SetNormalTexture("")
				bu:SetPushedTexture("")
				bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				bu.IconBorder:SetAlpha(0)

				local bg = F.CreateBDFrame(bu, .25)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 114, 0)

				ic:SetTexCoord(.08, .92, .08, .92)
				ic.bg = F.CreateBDFrame(ic, .25)
			end

			if select(7, GetLootSlotInfo(index)) then
				ic.bg:SetBackdropBorderColor(1, 1, 0)
				ic.bg.Shadow:SetBackdropBorderColor(1, 1, 0)
			else
				ic.bg:SetBackdropBorderColor(0, 0, 0)
				ic.bg.Shadow:SetBackdropBorderColor(0, 0, 0)
			end
		end)

		LootFrameDownButton:ClearAllPoints()
		LootFrameDownButton:SetPoint("BOTTOMRIGHT", -8, 6)
		LootFramePrev:ClearAllPoints()
		LootFramePrev:SetPoint("LEFT", LootFrameUpButton, "RIGHT", 4, 0)
		LootFrameNext:ClearAllPoints()
		LootFrameNext:SetPoint("RIGHT", LootFrameDownButton, "LEFT", -4, 0)
	end

	-- Bonus roll
	F.StripTextures(BonusRollFrame, true)
	F.CreateBD(BonusRollFrame)
	F.CreateSD(BonusRollFrame)

	BonusRollFrame.BlackBackgroundHoist:Hide()

	BonusRollFrame.SpecIcon:SetTexCoord(.08, .92, .08, .92)
	local bg = F.CreateBDFrame(BonusRollFrame.SpecIcon, .25)
	bg:SetFrameLevel(BonusRollFrame:GetFrameLevel() + 1)
	hooksecurefunc("BonusRollFrame_StartBonusRoll", function()
		bg:SetShown(BonusRollFrame.SpecIcon:IsShown())
	end)

	local PromptFrame = BonusRollFrame.PromptFrame

	PromptFrame.Icon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(PromptFrame.Icon, .25)

	PromptFrame.Timer.Bar:SetTexture(C.media.statusbar)
	PromptFrame.Timer.Bar:SetVertexColor(r, g, b)
	F.CreateBDFrame(PromptFrame.Timer, .25)

	local from, to = "|T.+|t", "|T%%s:14:14:0:0:64:64:5:59:5:59|t"
	BONUS_ROLL_COST = BONUS_ROLL_COST:gsub(from, to)
	BONUS_ROLL_CURRENT_COUNT = BONUS_ROLL_CURRENT_COUNT:gsub(from, to)

	-- Loot Roll Frame
	--[[
	hooksecurefunc("GroupLootFrame_OpenNewFrame", function()
		for i = 1, NUM_GROUP_LOOT_FRAMES do
			local frame = _G["GroupLootFrame"..i]
			if not frame.styled then
				frame.Border:SetAlpha(0)
				frame.Background:SetAlpha(0)
				F.CreateBD(frame)
				F.CreateSD(frame)

				frame.Timer.Bar:SetTexture(C.media.statusbar)
				frame.Timer.Bar:SetVertexColor(r, g, b)
				frame.Timer.Background:SetAlpha(0)
				F.CreateBDFrame(frame.Timer, .25)

				frame.IconFrame.Border:SetAlpha(0)
				frame.IconFrame.Icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBDFrame(frame.IconFrame.Icon, .25)

				local bg = F.CreateBDFrame(frame, .25)
				bg:SetPoint("TOPLEFT", frame.IconFrame.Icon, "TOPRIGHT", 0, 1)
				bg:SetPoint("BOTTOMRIGHT", frame.IconFrame.Icon, "BOTTOMRIGHT", 150, -1)

				frame.styled = true
			end

			if frame:IsShown() then
				local _, _, _, quality = GetLootRollItemInfo(frame.rollID)
				local color = BAG_ITEM_QUALITY_COLORS[quality]
				frame:SetBackdropBorderColor(color.r, color.g, color.b)
				frame.Shadow:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		end
	end)
	]]
end)