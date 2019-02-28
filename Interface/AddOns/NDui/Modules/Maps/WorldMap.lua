local _, ns = ...
local B, C, L, DB, F = unpack(ns)
local module = B:RegisterModule("Maps")

local mapRects = {}
local tempVec2D = CreateVector2D(0, 0)

function module:PlayerCoords(mapID)
	tempVec2D.x, tempVec2D.y = UnitPosition("player")
	if not tempVec2D.x or not mapID then return end

	local mapRect = mapRects[mapID]
	if not mapRect then
		mapRect = {}
		mapRect[1] = select(2, C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0)))
		mapRect[2] = select(2, C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1)))
		mapRect[2]:Subtract(mapRect[1])

		mapRects[mapID] = mapRect
	end
	tempVec2D:Subtract(mapRect[1])

	return tempVec2D.y/mapRect[2].y, tempVec2D.x/mapRect[2].x
end

function module:UpdateCoords()
	if not NDuiDB["Map"]["Coord"] then return end

	local BorderFrame = WorldMapFrame.BorderFrame
	BorderFrame.Tutorial:ClearAllPoints()
	BorderFrame.Tutorial:SetPoint("TOPLEFT", -10, 10)

	local playerText = PLAYER..L[":"]
	local mouseText = L["Mouse"]..L[":"]

	local player = B.CreateFS(BorderFrame, 14, "", false, "TOPLEFT", 55, -6)
	player:SetJustifyH("LEFT")

	local cursor = B.CreateFS(BorderFrame, 14, "", false, "TOPLEFT", 175, -6)
	cursor:SetJustifyH("LEFT")

	local mapBody = WorldMapFrame:GetCanvasContainer()
	local scale, width, height = mapBody:GetEffectiveScale(), mapBody:GetWidth(), mapBody:GetHeight()
	hooksecurefunc(WorldMapFrame, "OnFrameSizeChanged", function()
		width, height = mapBody:GetWidth(), mapBody:GetHeight()
	end)

	local mapID
	hooksecurefunc(WorldMapFrame, "OnMapChanged", function(self)
		if self:GetMapID() == C_Map.GetBestMapForUnit("player") then
			mapID = self:GetMapID()
		else
			mapID = nil
		end
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

			local px, py = module:PlayerCoords(mapID)
			if (px and px~= 0) and (py and py~= 0) then
				player:SetFormattedText(CoordsFormat(playerText), 100 * px, 100 * py)
			else
				player:SetText(CoordsFormat(playerText, true))
			end

			self.elapsed = 0
		end
	end

	local CoordsUpdater = CreateFrame("Frame", nil, BorderFrame)
	CoordsUpdater:SetScript("OnUpdate", UpdateCoords)
end

function module:WorldMapScale()
	local function setupScale(self)
		if self.isMaximized and self:GetScale() ~= 1 then
			self:SetScale(1)
		elseif not self.isMaximized and self:GetScale() ~= NDuiDB["Map"]["MapScale"] then
			self:SetScale(NDuiDB["Map"]["MapScale"])
		end
	end

	if NDuiDB["Map"]["MapScale"] > 1 then
		WorldMapFrame.ScrollContainer.GetCursorPosition = function(f)
			local x, y = MapCanvasScrollControllerMixin.GetCursorPosition(f)
			local s = WorldMapFrame:GetScale()
			return x/s, y/s
		end
	end

	local function updateMapAnchor(self)
		setupScale(self)
		if not self.isMaximized then B.RestoreMF(self) end
	end
	B.CreateMF(WorldMapFrame, nil, true)
	hooksecurefunc(WorldMapFrame, "SynchronizeDisplayState", updateMapAnchor)
end

function module:OnLogin()
	self:WorldMapScale()
	self:UpdateCoords()
	self:SetupMinimap()
	self:MapReveal()
end