local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	for i = 1, 4 do
		local main = "StaticPopup"..i

		local frame = _G[main]
		B.ReskinFrame(frame, "noKill")
		B.ReskinButton(frame["extraButton"])

		for j = 1, 4 do
			B.ReskinButton(frame["button"..j])
		end

		local edit = _G[main.."EditBox"]
		B.ReskinInput(edit, 20)

		local item = _G[main.."ItemFrame"]
		B.StripTextures(item)

		local name = _G[main.."ItemFrameNameFrame"]
		name:Hide()

		local icon = _G[main.."ItemFrameIconTexture"]
		local icbg = B.ReskinIcon(icon)
		B.ReskinHighlight(item, icbg)
		B.ReskinIconBorder(item.IconBorder, icbg)

		local gold = _G[main.."MoneyInputFrameGold"]
		B.ReskinInput(gold)

		local silver = _G[main.."MoneyInputFrameSilver"]
		silver:ClearAllPoints()
		silver:SetPoint("LEFT", gold, "RIGHT", 1, 0)
		B.ReskinInput(silver)

		local copper = _G[main.."MoneyInputFrameCopper"]
		copper:ClearAllPoints()
		copper:SetPoint("LEFT", silver, "RIGHT", 1, 0)
		B.ReskinInput(copper)
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
	B.ReskinFrame(PetBattleQueueReadyFrame)
	B.CreateBDFrame(PetBattleQueueReadyFrame.Art)
	B.ReskinButton(PetBattleQueueReadyFrame.AcceptButton)
	B.ReskinButton(PetBattleQueueReadyFrame.DeclineButton)

	-- PlayerReportFrame
	PlayerReportFrame:HookScript("OnShow", function(self)
		if not self.styled then
			B.ReskinFrame(self)
			B.ReskinInput(self.Comment)
			B.ReskinButton(self.ReportButton)
			B.ReskinButton(self.CancelButton)

			self.styled = true
		end
	end)
end)