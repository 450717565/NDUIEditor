local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

function Skins:MogPartialSets()
	if not IsAddOnLoaded("MogPartialSets") then return end

	B.ReskinFilter(MogPartialSetsFilterButton)
	B.ReskinFrame(MogPartialSetsFilter)
	B.ReskinButton(MogPartialSetsFilterOkButton)
	B.ReskinButton(MogPartialSetsFilterRefreshButton)

	local EditBox = MogPartialSetsFilterMaxMissingPiecesEditBox
	B.ReskinInput(EditBox, B.Scale(16), B.Scale(16))
	EditBox:ClearAllPoints()
	EditBox:SetPoint("TOPLEFT", MogPartialSetsFilterFavoriteVariantsButton, "BOTTOMLEFT", 7, -2)

	local Text = MogPartialSetsFilterMaxMissingPiecesText
	Text:ClearAllPoints()
	Text:SetPoint("LEFT", EditBox, "RIGHT", 1, 0)

	local names = {
		"FavoriteVariants",
		"IgnoreBoots",
		"IgnoreBracers",
		"IgnoreCloak",
		"IgnoreHead",
		"OnlyFavorite",
		"Splash",
		"Toggle",
	}
	for _, name in pairs(names) do
		local check = _G["MogPartialSetsFilter"..name.."Button"]
		B.ReskinCheck(check)

		local text = _G["MogPartialSetsFilter"..name.."Text"]
		text:ClearAllPoints()
		text:SetPoint("LEFT", check, "RIGHT", 0, 0)
	end

	MogPartialSetsFilterFavoriteVariantsText:SetText("偏好套装变体版")
	MogPartialSetsFilterIgnoreBootsText:SetText("鞋子")
	MogPartialSetsFilterIgnoreBracersText:SetText("护腕")
	MogPartialSetsFilterIgnoreCloakText:SetText("披风")
	MogPartialSetsFilterIgnoredSlotsText:SetText("需要忽略的部位")
	MogPartialSetsFilterIgnoreHeadText:SetText("头盔")
	MogPartialSetsFilterMaxMissingPiecesText:SetText("部位缺失数量")
	MogPartialSetsFilterOnlyFavoriteText:SetText("只显示偏好套装")
	MogPartialSetsFilterSplashText:SetText("打印加载信息")
	MogPartialSetsFilterToggleText:SetText("显示不完整套装")

	MogPartialSetsFilterOkButton:SetText(OKAY)
	MogPartialSetsFilterRefreshButton:SetText(REFRESH)
end