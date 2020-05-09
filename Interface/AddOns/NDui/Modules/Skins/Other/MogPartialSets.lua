local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:MogPartialSets()
	if not IsAddOnLoaded("MogPartialSets") then return end

	B.ReskinFilter(MogPartialSetsFilterButton)
	B.ReskinFrame(MogPartialSetsFilter)
	B.ReskinButton(MogPartialSetsFilterOkButton)
	B.ReskinButton(MogPartialSetsFilterRefreshButton)

	local EditBox = MogPartialSetsFilterMaxMissingPiecesEditBox
	B.ReskinInput(EditBox, B.Scale(16), B.Scale(16))
	EditBox:ClearAllPoints()
	EditBox:SetPoint("TOPLEFT", MogPartialSetsFilterIgnoreBracersButton, "BOTTOMLEFT", 7, -2)
	local Text = MogPartialSetsFilterMaxMissingPiecesText
	Text:ClearAllPoints()
	Text:SetPoint("LEFT", EditBox, "RIGHT", 1, 0)

	local names = {"Toggle", "OnlyFavorite", "FavoriteVariants", "IgnoreBracers"}
	for _, name in pairs(names) do
		local check = _G["MogPartialSetsFilter"..name.."Button"]
		B.ReskinCheck(check)

		local text = _G["MogPartialSetsFilter"..name.."Text"]
		text:ClearAllPoints()
		text:SetPoint("LEFT", check, "RIGHT", 0, 0)
	end

	MogPartialSetsFilterToggleText:SetText("显示不完整套装")
	MogPartialSetsFilterOnlyFavoriteText:SetText("只显示偏好套装")
	MogPartialSetsFilterFavoriteVariantsText:SetText("偏好套装变体版")
	MogPartialSetsFilterIgnoreBracersText:SetText("忽略护腕部位")
	MogPartialSetsFilterMaxMissingPiecesText:SetText("部位缺失数量")
	MogPartialSetsFilterOkButton:SetText(OKAY)
	MogPartialSetsFilterRefreshButton:SetText(REFRESH)
end