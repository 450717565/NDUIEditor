local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraConfig.bags then return end

	F.ReskinInput(BagItemSearchBox)
	F.ReskinSort(BagItemAutoSortButton)

	for i = 1, 12 do
		local container = "ContainerFrame"..i

		local frame = _G[container]
		frame.PortraitButton.Highlight:SetTexture("")

		F.StripTextures(frame, true)
		F.SetBDFrame(frame, 8, -4, -3, 0)
		F.ReskinClose(_G[container.."CloseButton"], "TOPRIGHT", frame, "TOPRIGHT", -6, -7)

		local name = _G[container.."Name"]
		name:ClearAllPoints()
		name:SetPoint("TOP", 0, -10)

		for j = 1, MAX_CONTAINER_ITEMS do
			local item = container.."Item"..j

			local button = _G[item]
			F.CleanTextures(button)

			local questTexture = _G[item.."IconQuestTexture"]
			if questTexture then questTexture:SetAlpha(0) end

			local newTexture = button.NewItemTexture
			if newTexture then newTexture:SetAlpha(0) end

			local border = button.IconBorder
			F.ReskinBorder(border, button)

			local icbg = F.ReskinIcon(button.icon)
			F.ReskinTexture(button, icbg, false)

			local searchOverlay = button.searchOverlay
			searchOverlay:SetAllPoints(icbg)
		end
	end

	F.StripTextures(BackpackTokenFrame)
	for i = 1, 3 do
		local ic = _G["BackpackTokenFrameToken"..i.."Icon"]
		F.ReskinIcon(ic, true)
	end

	hooksecurefunc("ContainerFrame_Update", function(frame)
		local name = frame:GetName()

		for i = 1, frame.size do
			local itemButton = _G[name.."Item"..i]

			if _G[name.."Item"..i.."IconQuestTexture"]:IsShown() then
				itemButton.IconBorder:SetVertexColor(1, 1, 0)
			end
		end
	end)
end)