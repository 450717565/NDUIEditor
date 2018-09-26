local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraConfig.loot then return end
	local r, g, b = C.r, C.g, C.b

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
			bg:SetFrameLevel(bu:GetFrameLevel()-1)

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
end)