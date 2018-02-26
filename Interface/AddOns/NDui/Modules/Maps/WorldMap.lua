local B, C, L, DB = unpack(select(2, ...))
local module = NDui:RegisterModule("Maps")

function module:OnLogin()
	local WorldMapDetailFrame, WorldMapTitleButton, WorldMapFrame, WorldMapFrameTutorialButton = _G.WorldMapDetailFrame, _G.WorldMapTitleButton, _G.WorldMapFrame, _G.WorldMapFrameTutorialButton
	local formattext = DB.MyColor.."%.1f , %.1f"

	-- Default Settings
	SetCVar("lockedWorldMap", 0)
	WorldMapFrame:SetScale(NDuiDB["Map"]["MapScale"])
	hooksecurefunc("WorldMap_ToggleSizeUp", function()
		if InCombatLockdown() then return end
		WorldMapFrame:SetScale(1)
	end)
	hooksecurefunc("WorldMap_ToggleSizeDown", function()
		if InCombatLockdown() then return end
		WorldMapFrame:SetScale(NDuiDB["Map"]["MapScale"])
	end)

	-- Generate Coords
	if not NDuiDB["Map"]["Coord"] then return end

	local player = B.CreateFS(WorldMapTitleButton, 14, "")
	local cursor = B.CreateFS(WorldMapTitleButton, 14, "")
	player:SetJustifyH("LEFT")
	cursor:SetJustifyH("LEFT")

	if IsAddOnLoaded("Aurora") then
		player:SetPoint("TOPLEFT", 40, -8)
		cursor:SetPoint("TOPLEFT", 170, -8)
	else
		player:SetPoint("TOPLEFT", 60, -6)
		cursor:SetPoint("TOPLEFT", 180, -6)
	end

	local width, height = WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight()
	local scale = WorldMapDetailFrame:GetEffectiveScale()

	local function CursorCoords()
		local left, top = WorldMapDetailFrame:GetLeft() or 0, WorldMapDetailFrame:GetTop() or 0
		local x, y = GetCursorPosition()
		local cx = (x/scale - left) / width
		local cy = (top - y/scale) / height
		if cx < 0 or cx > 1 or cy < 0 or cy > 1 then return end
		return cx, cy
	end

	local function CoordsUpdate(player, cursor)
		local cx, cy = CursorCoords()
		local px, py = GetPlayerMapPosition("player")
		if cx and cy then
			cursor:SetFormattedText(MOUSE_LABEL..L[":"]..formattext, 100 * cx, 100 * cy)
		else
			cursor:SetText(MOUSE_LABEL..L[":"]..DB.MyColor.."-- , --")
		end
		if (not px) or (not py) or (px == 0) or (py == 0) then
			player:SetText(PLAYER..L[":"]..DB.MyColor.."-- , --")
		else
			player:SetFormattedText(PLAYER..L[":"]..formattext, 100 * px, 100 * py)
		end
	end

	local function UpdateCoords(self, elapsed)
		self.elapsed = self.elapsed - elapsed
		if self.elapsed <= 0 then
			self.elapsed = .1
			CoordsUpdate(player, cursor)
		end
	end

	NDui:EventFrame{"WORLD_MAP_UPDATE"}:SetScript("OnEvent", function(self)
		if WorldMapFrame:IsVisible() then
			self.elapsed = .1
			self:SetScript("OnUpdate", UpdateCoords)
		else
			self.elapsed = nil
			self:SetScript("OnUpdate", nil)
		end
	end)
end