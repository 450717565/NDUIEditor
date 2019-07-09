local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

function S:BigWigsSkin()
	if not NDuiDB["Skins"]["Bigwigs"] or not IsAddOnLoaded("BigWigs") then return end
	if not BigWigs3DB then return end

	local function removeStyle(bar)
		B.StripTextures(bar)

		bar:Hide()

		local height = bar:Get("bigwigs:restoreheight")
		if height then bar:SetHeight(height) end

		local tex = bar:Get("bigwigs:restoreicon")
		if tex then
			bar:SetIcon(tex)
			bar:Set("bigwigs:restoreicon", nil)
			bar.candyBarIconFrame:Hide()
		end

		local timer = bar.candyBarDuration
		timer:SetJustifyH("RIGHT")
		timer:ClearAllPoints()
		timer:SetPoint("RIGHT", bar, "RIGHT", -2, 7)
		timer:SetFont(DB.Font[1], 13, DB.Font[3])
		timer.SetFont = B.Dummy

		local name = bar.candyBarLabel
		name:SetJustifyH("LEFT")
		name:SetWordWrap(false)
		name:ClearAllPoints()
		name:SetPoint("LEFT", bar, "LEFT", 2, 7)
		name:SetPoint("RIGHT", timer, "LEFT", -5, 0)
		name:SetFont(DB.Font[1], 13, DB.Font[3])
		name.SetFont = B.Dummy
	end

	local function styleBar(bar)
		B.StripTextures(bar)

		local height = bar:GetHeight()
		bar:Set("bigwigs:restoreheight", height)
		bar:SetHeight(height/2)
		bar:SetTexture(DB.normTex)

		if not bar.styled then
			B.CreateTex(B.CreateBGFrame(bar))

			bar.styled = true
		end

		local tex = bar:GetIcon()
		if tex then
			bar:SetIcon(nil)
			bar:Set("bigwigs:restoreicon", tex)

			local icon = bar.candyBarIconFrame
			icon:Show()
			icon:SetTexture(tex)
			icon:SetSize(height, height)
			icon:SetTexCoord(unpack(DB.TexCoord))

			icon:ClearAllPoints()
			if bar.iconPosition == "RIGHT" then
				icon:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT", 5, 0)
			else
				icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
			end

			if not icon.styled then
				B.CreateBGFrame(icon)

				icon.styled = true
			end
		end

		local timer = bar.candyBarDuration
		timer:SetJustifyH("RIGHT")
		timer:ClearAllPoints()
		timer:SetPoint("RIGHT", bar, "RIGHT", -2, 7)
		timer:SetFont(DB.Font[1], 13, DB.Font[3])
		timer.SetFont = B.Dummy

		local name = bar.candyBarLabel
		name:SetJustifyH("LEFT")
		name:SetWordWrap(false)
		name:ClearAllPoints()
		name:SetPoint("LEFT", bar, "LEFT", 2, 7)
		name:SetPoint("RIGHT", timer, "LEFT", -5, 0)
		name:SetFont(DB.Font[1], 13, DB.Font[3])
		name.SetFont = B.Dummy
	end

	local function registerStyle()
		local bars = BigWigs:GetPlugin("Bars", true)
		bars:RegisterBarStyle("NDui", {
			apiVersion = 1,
			version = 2,
			GetSpacing = function(bar) return bar:GetHeight()+5 end,
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