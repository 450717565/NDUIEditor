local _, ns = ...
local B, C, L, DB, F = unpack(ns)
local S = B:GetModule("Skins")

function S:BigWigsSkin()
	if not NDuiDB["Skins"]["Bigwigs"] or not IsAddOnLoaded("BigWigs") then return end
	if not BigWigs3DB then return end

	local function removeStyle(self)
		B.StripTextures(self)

		self:Hide()

		local height = self:Get("bigwigs:restoreheight")
		if height then self:SetHeight(height) end

		local tex = self:Get("bigwigs:restoreicon")
		if tex then
			self:SetIcon(tex)
			self:Set("bigwigs:restoreicon", nil)
			self.candyBarIconFrame:Hide()
		end

		local timer = self.candyBarDuration
		timer:SetJustifyH("RIGHT")
		timer:ClearAllPoints()
		timer:SetPoint("RIGHT", self, "RIGHT", -2, 8)
		timer:SetFont(DB.Font[1], 13, DB.Font[3])
		timer.SetFont = B.Dummy

		local name = self.candyBarLabel
		name:SetJustifyH("LEFT")
		name:SetWordWrap(false)
		name:ClearAllPoints()
		name:SetPoint("LEFT", self, "LEFT", 2, 8)
		name:SetPoint("RIGHT", self, "RIGHT", -30, 8)
		name:SetFont(DB.Font[1], 13, DB.Font[3])
		name.SetFont = B.Dummy
	end

	local function styleBar(self)
		B.StripTextures(self)

		local height = self:GetHeight()
		self:Set("bigwigs:restoreheight", height)
		self:SetHeight(height/2)
		self:SetTexture(DB.normTex)

		if not self.styled then
			F.CreateBDFrame(self)

			self.styled = true
		end

		local tex = self:GetIcon()
		if tex then
			self:SetIcon(nil)
			self:Set("bigwigs:restoreicon", tex)

			local icon = self.candyBarIconFrame
			icon:Show()
			icon:SetTexture(tex)
			icon:SetSize(height, height)
			icon:SetTexCoord(unpack(DB.TexCoord))

			icon:ClearAllPoints()
			if self.iconPosition == "RIGHT" then
				icon:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 5, 0)
			else
				icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -5, 0)
			end

			if not icon.styled then
				F.CreateBDFrame(icon)

				icon.styled = true
			end
		end

		local timer = self.candyBarDuration
		timer:SetJustifyH("RIGHT")
		timer:ClearAllPoints()
		timer:SetPoint("RIGHT", self, "RIGHT", -2, 8)
		timer:SetFont(DB.Font[1], 13, DB.Font[3])
		timer.SetFont = B.Dummy

		local name = self.candyBarLabel
		name:SetJustifyH("LEFT")
		name:SetWordWrap(false)
		name:ClearAllPoints()
		name:SetPoint("LEFT", self, "LEFT", 2, 8)
		name:SetPoint("RIGHT", self, "RIGHT", -30, 8)
		name:SetFont(DB.Font[1], 13, DB.Font[3])
		name.SetFont = B.Dummy
	end

	local function registerStyle()
		local bars = BigWigs:GetPlugin("Bars", true)
		bars:RegisterBarStyle("NDui", {
			apiVersion = 1,
			version = 2,
			GetSpacing = function(self) return self:GetHeight()+5 end,
			ApplyStyle = styleBar,
			BarStopped = removeStyle,
			GetStyleName = function() return "NDui" end,
		})
	end

	if IsAddOnLoaded("BigWigs_Plugins") then
		registerStyle()
	else
		local function loadStyle(event, addon)
			if addon == "BigWigs_Plugins" then
				registerStyle()
				B:UnregisterEvent(event, loadStyle)
			end
		end
		B:RegisterEvent("ADDON_LOADED", loadStyle)
	end
end