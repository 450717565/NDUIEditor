local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

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

	hooksecurefunc("NavBar_Initialize", F.ReskinNavBar)

	hooksecurefunc("NavBar_AddButton", function(self)
		F.ReskinNavBar(self)

		local navButton = self.navList[#self.navList]
		if not navButton.restyled then
			F.StripTextures(navButton)
			F.ReskinButton(navButton)

			local selected = navButton.selected
			selected:SetDrawLayer("BACKGROUND")
			F.ReskinTexture(selected, navButton, true)

			navButton:HookScript("OnClick", function()
				moveNavButtons(self)
			end)

			-- arrow button
			local arrowButton = navButton.MenuArrowButton
			F.StripTextures(arrowButton)

			local bgTex = arrowButton:CreateTexture(nil, "ARTWORK")
			bgTex:SetTexture(C.media.arrowDown)
			bgTex:SetSize(8, 8)
			bgTex:SetPoint("CENTER")
			arrowButton.bgTex = bgTex

			arrowButton:SetScript("OnEnter", F.texOnEnter)
			arrowButton:SetScript("OnLeave", F.texOnLeave)

			navButton.restyled = true
		end

		moveNavButtons(self)
	end)
end)