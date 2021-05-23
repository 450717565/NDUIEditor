local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local lists = {
	"ADD_DropDownList",
	"DropDownList",
	"L_DropDownList",
	"Lib_DropDownList",
}

local function Reskin_CreateFrames()
	for _, name in pairs(lists) do
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			local menu = _G[name..i.."MenuBackdrop"]
			if menu and not menu.styled then
				B.ReskinFrame(menu)

				menu.styled = true
			end

			local back = _G[name..i.."Backdrop"]
			if back and not back.styled then
				B.ReskinFrame(back)

				back.styled = true
			end
		end
	end
end

local function Reskin_SetIconImage(icon, texture)
	if texture:find("Divider") then
		icon:SetColorTexture(cr, cg, cb, C.alpha)
		icon:SetHeight(C.mult)
	end
end

local function isCheckTexture(check)
	if check:GetTexture() == "Interface\\Common\\UI-DropDownRadioChecks" then
		return true
	end
end

local function Reskin_ToggleDropDownMenu(level)
	if not level then level = 1 end

	local listFrame = _G["DropDownList"..level]
	for index = 1, UIDROPDOWNMENU_MAXBUTTONS do
		local button = _G["DropDownList"..level.."Button"..index]
		local xOffset = select(4, button:GetPoint())
		local lfWidth = listFrame:GetWidth()
		local buWidth = button:GetWidth()
		if button:IsShown() and xOffset then
			local arrow = _G["DropDownList"..level.."Button"..index.."ExpandArrow"]
			arrow:SetNormalTexture(DB.arrowTex.."right")
			arrow:SetSize(14, 14)

			local hl = _G["DropDownList"..level.."Button"..index.."Highlight"]
			hl:SetColorTexture(cr, cg, cb, .25)
			hl:SetPoint("TOPLEFT", -xOffset + C.mult, 0)
			hl:SetPoint("BOTTOMRIGHT", lfWidth - buWidth - xOffset - C.mult, 0)

			local uncheck = _G["DropDownList"..level.."Button"..index.."UnCheck"]
			if uncheck then uncheck:SetTexture("") end

			local check = _G["DropDownList"..level.."Button"..index.."Check"]
			if not button.notCheckable then
				local _, cood = check:GetTexCoord()
				if cood == 0 then
					check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
					check:SetVertexColor(cr, cg, cb, 1)
					check:SetSize(20, 20)
					check:SetDesaturated(true)
				else
					check:SetColorTexture(cr, cg, cb, C.alpha)
					check:SetSize(10, 10)
					check:SetDesaturated(false)
				end

				check:SetTexCoord(0, 1, 0, 1)
			end
		end
	end
end

tinsert(C.XMLThemes, function()
	hooksecurefunc("UIDropDownMenu_CreateFrames", Reskin_CreateFrames)
	hooksecurefunc("UIDropDownMenu_SetIconImage", Reskin_SetIconImage)
	hooksecurefunc("ToggleDropDownMenu", Reskin_ToggleDropDownMenu)
end)