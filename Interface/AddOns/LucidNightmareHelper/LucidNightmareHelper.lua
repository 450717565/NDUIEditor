-- Lucid Nightmare Helper
-- by Vildiesel EU - Well of Eternity

local addonName, addonTable = ...
local ng

local L = addonTable.L

local player_icon = "interface\\worldmap\\WorldMapArrow"

local containerW, containerH = 25000, 25000
local buttonW, buttonH = 18, 18

local north = 1
local east = 2
local south = 3
local west = 4

local dir_to_region = {"TOP", "RIGHT", "BOTTOM", "LEFT"}
local dir_to_region_opposite = {"BOTTOM", "LEFT", "TOP", "RIGHT"}

local color_strings = {"Yellow","Blue","Red","Green","Purple"}
local colors = {{1, 1, 0},{0, 0.6, 1},{1, 0, 0},{0, 1, 0},{1, 0, 1}}

local buttonsPool = {}
local linksPool = {}
local rooms = {}
local links = {}
local current_room, mf, scrollframe, container, playerframe, last_dir, last_room_number

--local doors = {{{-1378, 680},{-1300,710}}, -- north
--               {{-1440, 600},{-1410,660}}, -- east
--               {{-1520, 680},{-1460,710}}, -- south
--               {{-1460, 740},{-1410,800}}} -- west

local function getOppositeDir(dir)
 if dir == north then return south
 elseif dir == east then return west
 elseif dir == south then return north
 else return east end
end

local function detectDir(x, y)
 if y > -1410 then
  return north
 elseif y < -1440 then
  return south
 elseif x < 660 then
  return east
 elseif x > 720 then
  return west
 end
end

local function centerCam(x, y)
 scrollframe:SetHorizontalScroll(x - 200 + buttonW / 2)
 scrollframe:SetVerticalScroll(y - 200 + buttonH / 2)
end

local function getUnused(t)
 local pool = t == "link" and linksPool or buttonsPool
 if #pool > 0 then
  return tremove(pool, 1)
 elseif t == "link" then
  local link = container:CreateTexture()
  link:SetSize(3, 3)
  return link
 else
  local btn = ng:New(addonName, "Frame", nil, container)
  btn:SetSize(buttonW, buttonH)
  btn.text = btn:CreateFontString()
  btn.text:SetFont("Fonts\\FRIZQT__.TTF", 8)
  btn.text:SetAllPoints()
  btn.text:SetText("")
  return btn
 end
end

local function createElement(t, r, ...)
 local f = getUnused(t)
 if t == "button" then
  f:SetPoint("TOPLEFT", container, "TOPLEFT", r.x, -r.y)
  f:SetBackdropColor(1, 1, 1, 1)
  f:SetBackdropBorderColor(0, 0, 0, 0) 
  r.button = f
 else -- link
  local r2, dir = ...
  f:ClearAllPoints()
  f:SetPoint(dir_to_region_opposite[dir], r.button, dir_to_region[dir])
  f:SetPoint(dir_to_region[dir], r2.button, dir_to_region_opposite[dir])
  local count = #links
  if count > 0 then
   links[count]:SetColorTexture(1, 1, 1, 1)
  end
  links[count + 1] = f
  f:SetColorTexture(0, 1, 1, 1)
 end
 f:Show()
end

local function resetColor(r, c, t)
 for k,v in pairs(rooms) do
  if v ~= r and v.POI_c == c and v.POI_t == t then
   if t == "rune" then
    v.button:SetBackdropColor(1, 1, 1, 1)
   else
    v.button:SetBackdropBorderColor(0, 0, 0, 0)
   end
   v.POI_c = nil
  end
 end
end

local function setRoomNumber(r)
 last_room_number = last_room_number + 1
 if last_room_number < 100 then
  r.button.text:SetTextHeight(10)
 else
  r.button.text:SetTextHeight(8)
 end
 r.button.text:SetText("|cff000000"..last_room_number.."|r")
 r.number = last_room_number
end

local function recolorRoom(r)
 resetColor(r, r.POI_c, r.POI_t)
 
 local func = r.POI_t == "rune" and r.button.SetBackdropColor or r.button.SetBackdropBorderColor
 
 if r.POI_c == 6 then
  r.button:SetBackdropColor(1, 1, 1, 1) 
  r.button:SetBackdropBorderColor(0, 0, 0, 0)
 else
  func(r.button, unpack(colors[r.POI_c]))
 end
end

local function newRoom()
 local r = {}
 r.neighbors = {}
 rooms[#rooms + 1] = r
 return r
end

local function getRotation(dir)
 if dir == west then
  return 90
 elseif dir == south then
  return 180
 elseif dir == east then
  return 270
 elseif dir == north then
  return 0
 end
end

local function setCurrentRoom(r)
 current_room = r
 centerCam(r.x, r.y)
 playerframe:SetParent(r.button)
 playerframe:SetAllPoints()
 playerframe.tex:SetRotation(math.rad(getRotation(last_dir or north))) 
end

local function linkRooms(dir, r1, r2)
 r1.neighbors[dir] = r2
 r2.neighbors[getOppositeDir(dir)] = r1
 local link = createElement("link", r1, r2, dir)
end

local function addRoom(dir)

 local dx, dy = 0, 0
 
 if dir == north then
  dy = -buttonH - 5
 elseif dir == east then
  dx = buttonW + 5
 elseif dir == south then
  dy = buttonH + 5
 elseif dir == west then
  dx = -buttonW - 5
 end

 local found
 for k,v in pairs(rooms) do
  if v.x == current_room.x + dx and v.y == current_room.y + dy then
   found = v
   break
  end
 end

 if found then
  linkRooms(dir, current_room, found)
  return found
 end

 local r = newRoom()

 r.x = current_room.x + dx
 r.y = current_room.y + dy
 
 createElement("button", r)
 setRoomNumber(r)
 linkRooms(dir, current_room, r)
 return r
end

local function ResetMap()
 for _,v in pairs(rooms) do
  v.button:Hide()
  buttonsPool[#buttonsPool + 1] = v.button
 end

 for _,v in pairs(links) do
  v:Hide()
  linksPool[#linksPool + 1] = v
 end
 
 wipe(rooms)
 wipe(links)
 
 last_dir = north
 
 rooms[1] = newRoom()
 
 rooms[1].x = containerW / 2
 rooms[1].y = containerH / 2
  
 last_room_number = -1
 createElement("button", rooms[1])
 setRoomNumber(rooms[1])

 setCurrentRoom(rooms[1])
end

local ly, lx = 0, 0
local function update()
 local y, x = UnitPosition("player")
 
 if math.abs(x - lx) > 70 or math.abs(y - ly) > 70 then
  local dir = detectDir(lx, ly)
  if dir then
   last_dir = dir
   setCurrentRoom(current_room.neighbors[dir] or addRoom(dir))
  end
 end
 
 lx = x
 ly = y
 
 -- camera nav
 if scrollframe.dragging_camera then
  local cur_x, cur_y = GetCursorPosition()
  if cur_x ~= scrollframe.cursor_x then
   scrollframe:SetHorizontalScroll(scrollframe.last_horiz + scrollframe.cursor_x - cur_x)
  end
  if cur_y ~= scrollframe.cursor_y then
   scrollframe:SetVerticalScroll(scrollframe.last_vert + cur_y - scrollframe.cursor_y)
  end
 end
end

local default_theme = {
				   l0_color      = "191919ff",
				   l0_border     = "191919Ee",
				   l0_texture    = "Interface\\Buttons\\GreyscaleRamp64",
				   --l0_texture    = "environments\\stars\\brokenshore_skybox_stormy_front03",
                   l2_color      = "444444cc",
				   l2_border     = "000000aa",
				   l1_texture    = "environments\\stars\\brokenshore_skybox_stormy_front03",
				   l3_color      = "555555ff",
				   l3_border     = "000000aa",
				   l3_texture    = "item\\objectcomponents\\weapon\\challengeknife_effect_smoke",
				   thumb         = "00aaffbb",
				   highlight     = "00aaff33",
	              -- fonts
				   f_label_name   = "Fonts\\FRIZQT__.ttf",
				   f_label_h      = 11,
				   f_label_flags  = "",
				   f_label_color  = "FFFFFFFF",
				   f_button_name  = "Fonts\\FRIZQT__.ttf",
				   f_button_h     = 11,
				   f_button_flags = "",
				   f_button_color = "FFFFFFFF",
				  }


local function setPOIClick(self)
 current_room.POI_t = self.t
 current_room.POI_c = self.c
 recolorRoom(current_room)
end
                  
local function initialize()

 if mf then 
  mf:SetShown(not mf:IsShown())
  return
 end

 local function hideTooltip()
  GameTooltip:Hide()
 end
 
 ng = NyxGUI("1.0")
 ng:Initialize(addonName, nil, "main", default_theme)
 
 mf = ng:New(addonName, "Frame", nil, UIParent)
 ng:SetFrameMovable(mf, true)
 mf:SetPoint("CENTER")
 mf:SetSize(525, 480)
 
 local topheader = ng:New(addonName, "Groupbox", nil, mf)
 topheader:SetHeight(20)
 topheader:SetPoint("TOPLEFT")
 topheader:SetPoint("TOPRIGHT", mf, "TOPRIGHT", -20, 0)
 topheader.text:ClearAllPoints()
 topheader.text:SetPoint("CENTER") 
 topheader:SetText("Lucid Nightmare Helper")
 
 scrollframe = CreateFrame("ScrollFrame", nil, mf)
 scrollframe:SetPoint("TOPLEFT", mf, "TOPLEFT", 75, -50)
 scrollframe:SetPoint("TOPRIGHT", mf, "TOPRIGHT", -30, -50)
 scrollframe:SetPoint("BOTTOMLEFT", mf, "BOTTOMLEFT", 75, 50)
 scrollframe:SetPoint("BOTTOMRIGHT", mf, "BOTTOMRIGHT", -30, 50)
 
 scrollframe.bg = scrollframe:CreateTexture()
 scrollframe.bg:SetAllPoints()
 scrollframe.bg:SetColorTexture(0, 0, 0, 1)
 
 container = CreateFrame("Frame", nil, scrollframe)
 container:SetSize(containerW, containerH)
 scrollframe:SetScrollChild(container)
 
 local last_x, last_y = 0,0
 scrollframe:SetScript("OnMouseDown", function(self, button)
   if button ~= "RightButton" then return end

   -- snapshot cursor and scroll values
   local x, y = GetCursorPosition()
   scrollframe.cursor_x = x
   scrollframe.cursor_y = y
   scrollframe.last_horiz = scrollframe:GetHorizontalScroll()
   scrollframe.last_vert = scrollframe:GetVerticalScroll()
   scrollframe.dragging_camera = true
  end)
  
 scrollframe:SetScript("OnMouseUp", function(self, button)
  if button ~= "RightButton" then return end
  scrollframe.dragging_camera = false
 end)

 scrollframe.centerButton = CreateFrame("Button", nil, scrollframe)
 scrollframe.centerButton.tex = scrollframe.centerButton:CreateTexture()
 scrollframe.centerButton.tex:SetTexture("interface\\cursor\\crosshairs")
 scrollframe.centerButton.tex:SetAllPoints()
 scrollframe.centerButton:SetSize(20, 20)
 scrollframe.centerButton:SetPoint("CENTER", scrollframe, "TOPRIGHT", 0, -35)
 scrollframe.centerButton:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
  GameTooltip:ClearLines()
  GameTooltip:AddLine(L["Center camera to the current room"])
  GameTooltip:Show()
  end)
 scrollframe.centerButton:SetScript("OnLeave", hideTooltip)
 scrollframe.centerButton:SetScript("OnClick", function() centerCam(current_room.x, current_room.y) end)

 scrollframe.resetButton = CreateFrame("Button", nil, scrollframe)
 scrollframe.resetButton.tex = scrollframe.resetButton:CreateTexture()
 scrollframe.resetButton.tex:SetTexture("interface\\common\\voicechat-muted")
 scrollframe.resetButton.tex:SetAllPoints()
 scrollframe.resetButton:SetSize(20, 20)
 scrollframe.resetButton:SetPoint("CENTER", scrollframe, "TOPRIGHT")
 scrollframe.resetButton:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
  GameTooltip:ClearLines()
  GameTooltip:AddLine(L["Erase the current map and start over"])
  GameTooltip:Show()
  end)
 scrollframe.resetButton:SetScript("OnLeave", hideTooltip)
 scrollframe.resetButton:SetScript("OnClick", ResetMap)
 
 scrollframe.infoButton = CreateFrame("Button", nil, scrollframe)
 scrollframe.infoButton.tex = scrollframe.infoButton:CreateTexture()
 scrollframe.infoButton.tex:SetTexture("interface\\friendsframe\\informationicon")
 scrollframe.infoButton.tex:SetAllPoints()
 scrollframe.infoButton:SetSize(20, 20)
 scrollframe.infoButton:SetPoint("CENTER", scrollframe, "TOPRIGHT", -35, 0)
 scrollframe.infoButton:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
  GameTooltip:ClearLines()
  GameTooltip:AddLine(L["You can navigate the map by Right-Click Dragging it"])
  GameTooltip:Show()
  end)
 scrollframe.infoButton:SetScript("OnLeave", hideTooltip)
 
 playerframe = CreateFrame("Frame")
 playerframe:SetAllPoints()
 playerframe.tex = playerframe:CreateTexture()
 playerframe.tex:SetAllPoints()
 playerframe.tex:SetTexture(player_icon)
 
 local label = ng:New(addonName, "Label", nil, mf)
 label:SetPoint("TOPLEFT", mf, "TOPLEFT", 15, -50)
 label:SetText(L["Markers"])

 for i = 1,5 do
  local btn = CreateFrame("Button", nil, mf)
  btn.tex = btn:CreateTexture()
  btn.tex:SetAllPoints()
  btn.tex:SetTexture("interface\\icons\\boss_odunrunes_"..(i == 3 and "orange" or color_strings[i]))

  btn:SetPoint("TOPLEFT", mf, "TOPLEFT", 25, -40 + i * -32)
  btn:SetSize(30, 30)
  btn.t = "rune"
  btn.c = i
  btn:SetScript("OnClick", setPOIClick)
  btn:SetText(color_strings[i].." Rune")
  
  btn = CreateFrame("Button", nil, mf)
  btn.tex = btn:CreateTexture()
  btn.tex:SetAllPoints()
  btn.tex:SetTexture("spells\\mage_frostorb_orb")
  btn.tex:SetVertexColor(unpack(colors[i]))
  
  btn:SetPoint("TOPLEFT", mf, "TOPLEFT", 25, -220 + i * -32)
  btn:SetSize(30, 30)
  btn.t = "orb"
  btn.c = i
  btn:SetScript("OnClick", setPOIClick)
  btn:SetText(color_strings[i].." Orb")
 end
 
 local btn = ng:New(addonName, "Button", nil, mf)
 btn:SetPoint("TOPLEFT", mf, "TOPLEFT", 15, -420)
 btn:SetSize(50, 30)
 btn.c = 6
 btn:SetScript("OnClick", setPOIClick)
 btn:SetText(L["Clear"])

 ResetMap()

 ly, lx = UnitPosition("player")
 
 mf:SetScript("OnUpdate", update)
 
 local alpha = ng:New(addonName, "SliderH", nil, mf)
 alpha:SetPoint("TOPLEFT", scrollframe, "BOTTOMRIGHT", -100, -20)
 alpha:SetPoint("TOPRIGHT", scrollframe, "BOTTOMRIGHT", 0, -20)
 alpha.text:ClearAllPoints()
 alpha.text:SetPoint("BOTTOM", alpha, "TOP", 0, 2)
 alpha:SetText(L["Transparency"])
 alpha:SetMinMaxValues(40, 100)
 alpha:SetValue(100)
 alpha:SetScript("OnValueChanged", function(self, value)
   mf:SetAlpha(value / 100)
  end)
 
 local hide = ng:New(addonName, "Button", nil, mf)
 hide:SetSize(75, 20)
 hide:SetPoint("BOTTOM", mf, "BOTTOM", 0, 10)
 hide:SetScript("OnClick", function() mf:Hide() end)
 hide:SetText(CLOSE)
 
 hide = ng:New(addonName, "Button", nil, mf)
 hide:SetSize(20, 20)
 hide:SetPoint("TOPRIGHT")
 hide:SetScript("OnClick", function() mf:Hide() end)
 hide:SetText("X")
end

-- slash command
SLASH_LUCIDNIGHTMAREHELPER1 = "/lucid"
SLASH_LUCIDNIGHTMAREHELPER2 = "/ln"
SlashCmdList["LUCIDNIGHTMAREHELPER"] = initialize
