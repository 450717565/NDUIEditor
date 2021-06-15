local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Update_AddonList()
	for i = 1, MAX_ADDONS_DISPLAYED do
		local entry = _G["AddonListEntry"..i]
		if entry and entry:IsShown() then
			local checkbox = _G["AddonListEntry"..i.."Enabled"]
			if checkbox.force then
				local tex = checkbox:GetCheckedTexture()
				if checkbox.state == 2 then
					tex:SetDesaturated(true)
					tex:SetVertexColor(cr, cg, cb)
				elseif checkbox.state == 1 then
					tex:SetVertexColor(1, .8, 0)
				end
			end
		end
	end
end

tinsert(C.XMLThemes, function()
	B.ReskinFrame(AddonList)

	B.ReskinCheck(AddonListForceLoad)
	B.ReskinDropDown(AddonCharacterDropDown)
	B.ReskinScroll(AddonListScrollFrameScrollBar)

	AddonListCancelButton:SetWidth(120)
	AddonListOkayButton:SetWidth(120)
	AddonCharacterDropDown:SetWidth(170)

	local buttons = {
		AddonListCancelButton,
		AddonListDisableAllButton,
		AddonListEnableAllButton,
		AddonListOkayButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	for i = 1, MAX_ADDONS_DISPLAYED do
		local Enabled = _G["AddonListEntry"..i.."Enabled"]
		B.ReskinCheck(Enabled, true)

		local Load = _G["AddonListEntry"..i.."Load"]
		B.ReskinButton(Load)
	end

	hooksecurefunc("AddonList_Update", Update_AddonList)
end)