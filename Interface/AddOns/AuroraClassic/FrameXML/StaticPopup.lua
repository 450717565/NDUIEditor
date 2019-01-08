local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	for i = 1, 4 do
		local frame = _G["StaticPopup"..i]
		F.ReskinPortraitFrame(frame, true)
		F.Reskin(frame["extraButton"])

		for j = 1, 4 do
			F.Reskin(frame["button"..j])
		end

		local edit = _G["StaticPopup"..i.."EditBox"]
		F.ReskinInput(edit, 20)

		local item = _G["StaticPopup"..i.."ItemFrame"]
		F.StripTextures(item)
		F.ReskinTexture(item.IconBorder, false, item, true)

		local name = _G["StaticPopup"..i.."ItemFrameNameFrame"]
		name:Hide()

		local icon = _G["StaticPopup"..i.."ItemFrameIconTexture"]
		local ic = F.ReskinIcon(icon, true)
		F.ReskinTexture(item, false, ic)

		local gold = _G["StaticPopup"..i.."MoneyInputFrameGold"]
		F.ReskinInput(gold)

		local silver = _G["StaticPopup"..i.."MoneyInputFrameSilver"]
		silver:SetPoint("LEFT", gold, "RIGHT", 1, 0)
		F.ReskinInput(silver)

		local copper = _G["StaticPopup"..i.."MoneyInputFrameCopper"]
		copper:SetPoint("LEFT", silver, "RIGHT", 1, 0)
		F.ReskinInput(copper)
	end

	hooksecurefunc("StaticPopup_Show", function(which, _, _, data)
		local info = StaticPopupDialogs[which]

		if not info then return end

		local dialog = nil
		dialog = StaticPopup_FindVisible(which, data)

		if not dialog then
			local index = 1
			if info.preferredIndex then
				index = info.preferredIndex
			end
			for i = index, STATICPOPUP_NUMDIALOGS do
				local frame = _G["StaticPopup"..i]
				if not frame:IsShown() then
					dialog = frame
					break
				end
			end

			if not dialog and info.preferredIndex then
				for i = 1, info.preferredIndex do
					local frame = _G["StaticPopup"..i]
					if not frame:IsShown() then
						dialog = frame
						break
					end
				end
			end
		end

		if not dialog then return end

		if info.closeButton then
			local closeButton = _G[dialog:GetName().."CloseButton"]

			closeButton:SetNormalTexture("")
			closeButton:SetPushedTexture("")

			if info.closeButtonIsHide then
				for _, pixel in pairs(closeButton.pixels) do
					pixel:Hide()
				end
			else
				for _, pixel in pairs(closeButton.pixels) do
					pixel:Show()
				end
			end
		end
	end)

	-- Pet battle queue popup

	F.CreateBD(PetBattleQueueReadyFrame)
	F.CreateSD(PetBattleQueueReadyFrame)
	F.CreateBDFrame(PetBattleQueueReadyFrame.Art)
	F.Reskin(PetBattleQueueReadyFrame.AcceptButton)
	F.Reskin(PetBattleQueueReadyFrame.DeclineButton)

	-- PlayerReportFrame
	PlayerReportFrame:HookScript("OnShow", function(self)
		if not self.styled then
			F.StripTextures(self)
			F.CreateBD(self)
			F.CreateSD(self)
			F.StripTextures(self.Comment)
			F.ReskinInput(self.Comment)
			F.Reskin(self.ReportButton)
			F.Reskin(self.CancelButton)

			self.styled = true
		end
	end)
end)