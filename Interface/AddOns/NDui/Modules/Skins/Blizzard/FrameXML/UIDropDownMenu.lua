local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	local lists = {"DropDownList", "ADD_DropDownList", "L_DropDownList", "Lib_DropDownList"}
	hooksecurefunc("UIDropDownMenu_CreateFrames", function()
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
	end)

	local function isCheckTexture(check)
		if check:GetTexture() == "Interface\\Common\\UI-DropDownRadioChecks" then
			return true
		end
	end

	hooksecurefunc("ToggleDropDownMenu", function(level, _, dropDownFrame, anchorName)
		if not level then level = 1 end

		local uiScale = UIParent:GetScale()
		local listFrame = _G["DropDownList"..level]

		if level == 1 then
			if not anchorName then
				local xOffset = dropDownFrame.xOffset and dropDownFrame.xOffset or 16
				local yOffset = dropDownFrame.yOffset and dropDownFrame.yOffset or 9
				local point = dropDownFrame.point and dropDownFrame.point or "TOPLEFT"
				local relativeTo = dropDownFrame.relativeTo and dropDownFrame.relativeTo or dropDownFrame
				local relativePoint = dropDownFrame.relativePoint and dropDownFrame.relativePoint or "BOTTOMLEFT"

				listFrame:ClearAllPoints()
				listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)

				-- make sure it doesn't go off the screen
				local offLeft = listFrame:GetLeft()/uiScale
				local offRight = (GetScreenWidth() - listFrame:GetRight())/uiScale
				local offTop = (GetScreenHeight() - listFrame:GetTop())/uiScale
				local offBottom = listFrame:GetBottom()/uiScale

				local xAddOffset, yAddOffset = 0, 0
				if offLeft < 0 then
					xAddOffset = -offLeft
				elseif offRight < 0 then
					xAddOffset = offRight
				end

				if offTop < 0 then
					yAddOffset = offTop
				elseif offBottom < 0 then
					yAddOffset = -offBottom
				end
				listFrame:ClearAllPoints()
				listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset)
			elseif anchorName ~= "cursor" then
				-- this part might be a bit unreliable
				local _, _, relPoint, xOff, yOff = listFrame:GetPoint()
				if relPoint == "BOTTOMLEFT" and xOff == 0 and floor(yOff) == 5 then
					listFrame:SetPoint("TOPLEFT", anchorName, "BOTTOMLEFT", 16, 9)
				end
			end
		else
			local point, anchor, relPoint, _, y = listFrame:GetPoint()
			if point:find("RIGHT") then
				listFrame:SetPoint(point, anchor, relPoint, -14, y)
			else
				listFrame:SetPoint(point, anchor, relPoint, 9, y)
			end
		end

		for j = 1, UIDROPDOWNMENU_MAXBUTTONS do
			local bu = _G["DropDownList"..level.."Button"..j]
			local x = select(4, bu:GetPoint())
			if bu:IsShown() and x then
				local arrow = _G["DropDownList"..level.."Button"..j.."ExpandArrow"]
				arrow:SetNormalTexture(DB.arrowRight)
				arrow:SetSize(8, 8)

				local hl = _G["DropDownList"..level.."Button"..j.."Highlight"]
				hl:SetColorTexture(cr, cg, cb, .25)
				hl:SetPoint("TOPLEFT", -x + C.mult, 0)
				hl:SetPoint("BOTTOMRIGHT", listFrame:GetWidth() - bu:GetWidth() - x - C.mult, 0)

				local check = _G["DropDownList"..level.."Button"..j.."Check"]
				if isCheckTexture(check) then
					check:SetSize(20, 20)
					check:SetTexCoord(0, 1, 0, 1)
					check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
					check:SetVertexColor(cr, cg, cb, 1)
					check:SetDesaturated(true)
				end

				local uncheck = _G["DropDownList"..level.."Button"..j.."UnCheck"]
				if isCheckTexture(uncheck) then uncheck:SetTexture("") end
			end
		end
	end)

	hooksecurefunc("UIDropDownMenu_SetIconImage", function(icon, texture)
		if texture:find("Divider") then
			icon:SetColorTexture(1, 1, 1, .25)
			icon:SetHeight(C.mult)
		end
	end)
end)