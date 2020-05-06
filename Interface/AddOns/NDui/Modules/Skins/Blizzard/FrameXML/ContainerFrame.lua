local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	if NDuiDB["Bags"]["Enable"] then return end

	B.ReskinInput(BagItemSearchBox)
	B.ReskinSort(BagItemAutoSortButton)

	for i = 1, 12 do
		local container = "ContainerFrame"..i

		local frame = _G[container]
		frame.PortraitButton.Highlight:SetTexture("")

		B.StripTextures(frame, 0)
		local bg = B.CreateBGFrame(frame, 8, -4, -3, 0)
		B.ReskinClose(_G[container.."CloseButton"], "TOPRIGHT", bg, "TOPRIGHT", -6, -6)

		local name = _G[container.."Name"]
		name:ClearAllPoints()
		name:SetPoint("TOP", 0, -10)

		for j = 1, MAX_CONTAINER_ITEMS do
			local item = container.."Item"..j

			local button = _G[item]
			B.CleanTextures(button)

			local questTexture = _G[item.."IconQuestTexture"]
			if questTexture then questTexture:SetAlpha(0) end

			local newTexture = button.NewItemTexture
			if newTexture then newTexture:SetAlpha(0) end

			local icbg = B.ReskinIcon(button.icon)
			B.ReskinHighlight(button, icbg)

			local border = button.IconBorder
			B.ReskinBorder(border, icbg)

			local searchOverlay = button.searchOverlay
			searchOverlay:SetAllPoints(icbg)
		end
	end

	B.StripTextures(BackpackTokenFrame)
	for i = 1, 3 do
		local ic = _G["BackpackTokenFrameToken"..i.."Icon"]
		B.ReskinIcon(ic)
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