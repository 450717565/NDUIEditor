local _, ns = ...
local B, C, L, DB, F = unpack(ns)
local module = B:RegisterModule("Maps")

local select = select
local CreateVector2D = CreateVector2D
local UnitPosition, GetCursorPosition = UnitPosition, GetCursorPosition
local C_Map_GetWorldPosFromMapPos = C_Map.GetWorldPosFromMapPos
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit

local mapRects = {}
local tempVec2D = CreateVector2D(0, 0)
local mapScale, mapWidth, mapHeight, mapCenterX, mapCenterY
local currentMapID, playerCoords, cursorCoords, playerText, cursorText

function module:GetPlayerMapPos(mapID)
	tempVec2D.x, tempVec2D.y = UnitPosition("player")
	if not tempVec2D.x or not mapID then return end

	local mapRect = mapRects[mapID]
	if not mapRect then
		mapRect = {}
		mapRect[1] = select(2, C_Map_GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0)))
		mapRect[2] = select(2, C_Map_GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1)))
		mapRect[2]:Subtract(mapRect[1])

		mapRects[mapID] = mapRect
	end
	tempVec2D:Subtract(mapRect[1])

	return tempVec2D.y/mapRect[2].y, tempVec2D.x/mapRect[2].x
end

function module:GetCursorCoords()
	local x, y = GetCursorPosition()
	local cursorX = x and ((x / mapScale - (mapCenterX - (mapWidth/2))) / mapWidth)
	local cursorY = y and ((mapCenterY + (mapHeight/2) - y / mapScale) / mapHeight)
	if cursorX < 0 or cursorX > 1 or cursorY < 0 or cursorY > 1 then return end

	return cursorX, cursorY
end

local function CoordsFormat(owner, none)
	local text = none and "-- , --" or "%.1f , %.1f"
	return owner..DB.MyColor..text
end

function module:UpdateCoords(elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > .1 then
		local cursorX, cursorY = module:GetCursorCoords()
		if cursorX and cursorY then
			cursorCoords:SetFormattedText(CoordsFormat(cursorText), 100 * cursorX, 100 * cursorY)
		else
			cursorCoords:SetText(CoordsFormat(cursorText, true))
		end

		local playerX, playerY = module:GetPlayerMapPos(currentMapID)
		if playerX and playerY then
			playerCoords:SetFormattedText(CoordsFormat(playerText), 100 * playerX, 100 * playerY)
		else
			playerCoords:SetText(CoordsFormat(playerText, true))
		end

		self.elapsed = 0
	end
end

function module:SetupCoords()
	if not NDuiDB["Map"]["Coord"] then return end

	local BorderFrame = WorldMapFrame.BorderFrame
	BorderFrame.Tutorial:ClearAllPoints()
	BorderFrame.Tutorial:SetPoint("TOPLEFT", -10, 10)

	playerText = PLAYER..L[":"]
	cursorText = L["Mouse"]..L[":"]

	playerCoords = B.CreateFS(BorderFrame, 14, "", false, "TOPLEFT", 55, -6)
	playerCoords:SetJustifyH("LEFT")

	cursorCoords = B.CreateFS(BorderFrame, 14, "", false, "TOPLEFT", 175, -6)
	cursorCoords:SetJustifyH("LEFT")

	hooksecurefunc(WorldMapFrame, "OnFrameSizeChanged", function(self)
		local mapBody = self:GetCanvasContainer()
		mapWidth = mapBody:GetWidth()
		mapHeight = mapBody:GetHeight()
		mapCenterX, mapCenterY = mapBody:GetCenter()
		mapScale = mapBody:GetEffectiveScale()
	end)

	hooksecurefunc(WorldMapFrame, "OnMapChanged", function(self)
		if self:GetMapID() == C_Map_GetBestMapForUnit("player") then
			currentMapID = self:GetMapID()
		else
			currentMapID = nil
		end
	end)

	local CoordsUpdater = CreateFrame("Frame", nil, WorldMapFrame.BorderFrame)
	CoordsUpdater:SetScript("OnUpdate", module.UpdateCoords)
end

function module:UpdateMapScale()
	if self.isMaximized and self:GetScale() ~= 1 then
		self:SetScale(1)
	elseif not self.isMaximized and self:GetScale() ~= NDuiDB["Map"]["MapScale"] then
		self:SetScale(NDuiDB["Map"]["MapScale"])
	end
end

function module:UpdateMapAnchor()
	module.UpdateMapScale(self)
	if not self.isMaximized then B.RestoreMF(self) end
end

function module:WorldMapScale()
	if NDuiDB["Map"]["MapScale"] > 1 then
		WorldMapFrame.ScrollContainer.GetCursorPosition = function(f)
			local x, y = MapCanvasScrollControllerMixin.GetCursorPosition(f)
			local scale = WorldMapFrame:GetScale()
			return x / scale, y / scale
		end
	end

	B.CreateMF(WorldMapFrame, nil, true)
	hooksecurefunc(WorldMapFrame, "SynchronizeDisplayState", self.UpdateMapAnchor)
end

function module:OnLogin()
	self:WorldMapScale()
	self:SetupCoords()
	self:SetupMinimap()
	self:MapReveal()
end