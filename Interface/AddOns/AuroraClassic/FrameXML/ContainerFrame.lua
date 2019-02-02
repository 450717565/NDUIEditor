local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraConfig.bags then return end

	BackpackTokenFrame:GetRegions():Hide()

	for i = 1, 12 do
		local frame = _G["ContainerFrame"..i]
		frame.PortraitButton.Highlight:SetTexture("")

		F.StripTextures(frame, true)
		F.SetBDFrame(frame, 8, -4, -3, 0)
		F.ReskinClose(_G["ContainerFrame"..i.."CloseButton"], "TOPRIGHT", frame, "TOPRIGHT", -6, -7)

		local name = _G["ContainerFrame"..i.."Name"]
		name:ClearAllPoints()
		name:SetPoint("TOP", 0, -10)

		for k = 1, MAX_CONTAINER_ITEMS do
			local item = "ContainerFrame"..i.."Item"..k

			local button = _G[item]
			button:SetNormalTexture("")
			button:SetPushedTexture("")

			local questTexture = _G[item.."IconQuestTexture"]
			questTexture:SetAlpha(0)

			local newItemTexture = button.NewItemTexture
			newItemTexture:SetAlpha(0)

			local ic = F.ReskinIcon(button.icon)
			F.ReskinTexture(button, ic, false)

			local border = button.IconBorder
			F.ReskinBorder(border, button)

			local searchOverlay = button.searchOverlay
			searchOverlay:SetPoint("TOPLEFT", -C.mult, C.mult)
			searchOverlay:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)
		end
	end

	for i = 1, 3 do
		local ic = _G["BackpackTokenFrameToken"..i.."Icon"]
		F.ReskinIcon(ic)
	end

	F.ReskinInput(BagItemSearchBox)

	hooksecurefunc("ContainerFrame_Update", function(frame)
		local id = frame:GetID()
		local name = frame:GetName()

		if id == 0 then
			BagItemSearchBox:ClearAllPoints()
			BagItemSearchBox:SetPoint("TOP", 0, -35)
			BagItemAutoSortButton:ClearAllPoints()
			BagItemAutoSortButton:SetPoint("TOPRIGHT", -10, -30)
		end

		for i = 1, frame.size do
			local itemButton = _G[name.."Item"..i]

			itemButton.IconBorder:SetTexture(C.media.bdTex)
			if _G[name.."Item"..i.."IconQuestTexture"]:IsShown() then
				itemButton.IconBorder:SetVertexColor(1, 1, 0)
			end
		end
	end)

	BagItemAutoSortButton:GetNormalTexture():SetTexCoord(.17, .83, .17, .83)
	BagItemAutoSortButton:GetPushedTexture():SetTexCoord(.17, .83, .17, .83)
	BagItemAutoSortButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	BagItemAutoSortButton:GetHighlightTexture():SetAllPoints()
	F.CreateBDFrame(BagItemAutoSortButton, 0)
end)