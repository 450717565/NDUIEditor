local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local function moveNavButtons(self)
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
					lastButton:SetPoint("LEFT", self.overflowButton, "RIGHT", 1, 0)
				end
			end
		end
	end

	hooksecurefunc("NavBar_Initialize", B.ReskinNavBar)

	hooksecurefunc("NavBar_AddButton", function(self)
		B.ReskinNavBar(self)

		local navButton = self.navList[#self.navList]
		if not navButton.restyled then
			B.StripTextures(navButton)
			B.ReskinButton(navButton)

			local selected = navButton.selected
			selected:SetDrawLayer("BACKGROUND")
			B.ReskinHighlight(selected, navButton, true)

			navButton:HookScript("OnClick", function()
				moveNavButtons(self)
			end)

			-- arrow button
			local arrowButton = navButton.MenuArrowButton
			B.StripTextures(arrowButton)
			B.SetupArrowTex(arrowButton, "down")

			B.Hook_OnEnter(arrowButton)
			B.Hook_OnLeave(arrowButton)

			navButton.restyled = true
		end

		moveNavButtons(self)
	end)
end)