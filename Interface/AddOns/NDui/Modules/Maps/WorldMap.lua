local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:RegisterModule("Maps")

function module:PlayerCoords()
	local px, py = 0, 0
	local mapID = C_Map.GetBestMapForUnit("player")

	if not IsInInstance() and mapID then
		px, py = C_Map.GetPlayerMapPosition(mapID, "player"):GetXY()
	end

	return px, py
end

function module:OnLogin()
	-- Scaling
	if not WorldMapFrame.isMaximized then WorldMapFrame:SetScale(NDuiDB["Map"]["MapScale"]) end
	hooksecurefunc(WorldMapFrame, "Minimize", function(self)
		if InCombatLockdown() then return end
		self:SetScale(NDuiDB["Map"]["MapScale"])
	end)
	hooksecurefunc(WorldMapFrame, "Maximize", function(self)
		if InCombatLockdown() then return end
		self:SetScale(1)
	end)
	-- cursor fix, need reviewed
	if NDuiDB["Map"]["MapScale"] > 1 then
		RunScript("WorldMapFrame.ScrollContainer.GetCursorPosition=function(f) local x,y=MapCanvasScrollControllerMixin.GetCursorPosition(f);local s=WorldMapFrame:GetScale();return x/s,y/s;end")
	end

	-- Generate Coords
	if not NDuiDB["Map"]["Coord"] then return end

	WorldMapFrame.BorderFrame.Tutorial:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", -12, -12)

	local playerText = PLAYER..L[":"]
	local mouseText = L["Mouse"]..L[":"]
	local player = B.CreateFS(WorldMapFrame.BorderFrame, 14, "")
	local cursor = B.CreateFS(WorldMapFrame.BorderFrame, 14, "")
	player:SetJustifyH("LEFT")
	cursor:SetJustifyH("LEFT")

	if IsAddOnLoaded("AuroraClassic") then
		player:SetPoint("TOPLEFT", 40, -8)
		cursor:SetPoint("TOPLEFT", 170, -8)
	else
		player:SetPoint("TOPLEFT", 60, -6)
		cursor:SetPoint("TOPLEFT", 180, -6)
	end

	local mapBody = WorldMapFrame:GetCanvasContainer()
	local scale, width, height = mapBody:GetEffectiveScale(), mapBody:GetWidth(), mapBody:GetHeight()
	hooksecurefunc(WorldMapFrame, "OnFrameSizeChanged", function()
		width, height = mapBody:GetWidth(), mapBody:GetHeight()
	end)

	local function CursorCoords()
		local left, top = mapBody:GetLeft() or 0, mapBody:GetTop() or 0
		local x, y = GetCursorPosition()
		local cx = (x/scale - left) / width
		local cy = (top - y/scale) / height
		if cx < 0 or cx > 1 or cy < 0 or cy > 1 then return end
		return cx, cy
	end

	local function CoordsFormat(owner, none)
		local text = none and "-- , --" or "%.1f , %.1f"
		return owner..DB.MyColor..text
	end

	local function UpdateCoords(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed > .1 then
			local cx, cy = CursorCoords()
			if cx and cy then
				cursor:SetFormattedText(CoordsFormat(mouseText), 100 * cx, 100 * cy)
			else
				cursor:SetText(CoordsFormat(mouseText, true))
			end

			local px, py = module:PlayerCoords()
			if (px and px~= 0) and (py and py~= 0) then
				player:SetFormattedText(CoordsFormat(playerText), 100 * px, 100 * py)
			else
				player:SetText(CoordsFormat(playerText, true))
			end

			self.elapsed = 0
		end
	end

	local CoordsUpdater = CreateFrame("Frame", nil, WorldMapFrame.BorderFrame)
	CoordsUpdater:SetScript("OnUpdate", UpdateCoords)
end