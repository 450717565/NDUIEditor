local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	for i = 1, 4 do
		local main = "StaticPopup"..i
		local frame = _G[main]
		F.ReskinFrame(frame)
		F.ReskinButton(frame["extraButton"])

		for j = 1, 4 do
			F.ReskinButton(frame["button"..j])
		end

		local edit = _G[main.."EditBox"]
		F.ReskinInput(edit, 20)

		local item = _G[main.."ItemFrame"]
		F.StripTextures(item)
		F.ReskinBorder(item.IconBorder, item)

		local name = _G[main.."ItemFrameNameFrame"]
		name:Hide()

		local icon = _G[main.."ItemFrameIconTexture"]
		local ic = F.ReskinIcon(icon)
		F.ReskinTexture(item, ic, false)

		local gold = _G[main.."MoneyInputFrameGold"]
		F.ReskinInput(gold)

		local silver = _G[main.."MoneyInputFrameSilver"]
		silver:ClearAllPoints()
		silver:SetPoint("LEFT", gold, "RIGHT", 1, 0)
		F.ReskinInput(silver)

		local copper = _G[main.."MoneyInputFrameCopper"]
		copper:ClearAllPoints()
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
	end)

	-- Pet battle queue popup
	F.ReskinFrame(PetBattleQueueReadyFrame)
	F.CreateBDFrame(PetBattleQueueReadyFrame.Art)
	F.ReskinButton(PetBattleQueueReadyFrame.AcceptButton)
	F.ReskinButton(PetBattleQueueReadyFrame.DeclineButton)

	-- PlayerReportFrame
	PlayerReportFrame:HookScript("OnShow", function(self)
		if not self.styled then
			F.ReskinFrame(self)
			F.ReskinInput(self.Comment)
			F.ReskinButton(self.ReportButton)
			F.ReskinButton(self.CancelButton)

			self.styled = true
		end
	end)
end)