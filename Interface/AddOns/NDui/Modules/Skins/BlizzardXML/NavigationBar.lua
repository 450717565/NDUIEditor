local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Move_NavButtons(self)
	local width = 0
	local collapsedWidth
	local maxWidth = self:GetWidth() - self.widthBuffer

	local lastShown
	local collapsed = false

	for i = #self.navList, 1, -1 do
		local currentWidth = width
		width = width + self.navList[i]:GetWidth()

		if width > maxWidth then
			collapsed = true
			if not collapsedWidth then
				collapsedWidth = currentWidth
			end
		else
			if lastShown then
				self.navList[lastShown]:ClearAllPoints()
				self.navList[lastShown]:SetPoint("LEFT", self.navList[i], "RIGHT", 1, 0)
			end
			lastShown = i
		end
	end

	if collapsed then
		if collapsedWidth + self.overflowButton:GetWidth() > maxWidth then
			lastShown = lastShown + 1
		end

		if lastShown then
			local lastButton = self.navList[lastShown]

			if lastButton then
				lastButton:ClearAllPoints()
				lastButton:SetPoint("LEFT", self.overflowButton, "RIGHT", 1, 0)
			end
		end
	end
end

local function Reskin_AddButton(self)
	B.ReskinNavBar(self)

	local navButton = self.navList[#self.navList]
	if not navButton.restyled then
		B.StripTextures(navButton)
		B.ReskinButton(navButton)

		navButton:HookScript("OnClick", function()
			Move_NavButtons(self)
		end)

		local selected = navButton.selected
		B.ReskinHLTex(selected, navButton.bgTex, true)

		local MenuArrowButton = navButton.MenuArrowButton
		MenuArrowButton:ClearAllPoints()
		MenuArrowButton:SetPoint("RIGHT", navButton, "RIGHT", -5, 0)
		B.ReskinArrow(MenuArrowButton, "down", 20)

		navButton.restyled = true
	end

	Move_NavButtons(self)
end

C.OnLoginThemes["NavigationBar"] = function()
	hooksecurefunc("NavBar_Initialize", B.ReskinNavBar)
	hooksecurefunc("NavBar_AddButton", Reskin_AddButton)
end