local B, C, L, DB = unpack(select(2, ...))

local mrad = math.rad

-- the actual frame
local frame = CreateFrame("Frame",nil,UIParent)
frame:SetFrameStrata("FULLSCREEN")
frame:SetAllPoints()
frame.h = frame:GetHeight()
frame:EnableMouse(true)
frame:SetAlpha(0)
frame:Hide()

-- frame when /afk is initiated
function frame:Enable()
	if self.isActive then return end
	self.isActive = true
	self:Show()
	self.fadeIn:Play()
end

-- frame after /afk is over
function frame:Disable()
	if not self.isActive then return end
	self.isActive = false
	self.fadeOut:Play()
end

-- Main Handler
function frame:OnEvent(event)
	if event == "PLAYER_LOGIN" then
		self.model:SetUnit("player")
		self.model:SetRotation(mrad(-30))

		-- close button at bottom left incase /afk bugs out
		local button = B.CreateButton(frame.model, 40, 20, AFK)
		button:SetPoint("BOTTOMLEFT", frame, 20, 20)
		button:SetScript("OnClick", function() frame:Disable() end)
	else
		if UnitIsAFK("player") then
			self:Enable()
		else
			self:Disable()
		end
	end
end

-- Bassically makes it fade IN
frame.fadeIn = frame:CreateAnimationGroup()
frame.fadeIn.anim = frame.fadeIn:CreateAnimation("Alpha")
frame.fadeIn.anim:SetDuration(1)
frame.fadeIn.anim:SetSmoothing("OUT")
frame.fadeIn.anim:SetFromAlpha(0)
frame.fadeIn.anim:SetToAlpha(1)
frame.fadeIn:HookScript("OnFinished", function(self)
	self:GetParent():SetAlpha(1)
end)

-- Bassically makes it fade OUT
frame.fadeOut = frame:CreateAnimationGroup()
frame.fadeOut.anim = frame.fadeOut:CreateAnimation("Alpha")
frame.fadeOut.anim:SetDuration(1)
frame.fadeOut.anim:SetSmoothing("OUT")
frame.fadeOut.anim:SetFromAlpha(1)
frame.fadeOut.anim:SetToAlpha(0)
frame.fadeOut:HookScript("OnFinished", function(self)
	self:GetParent():SetAlpha(0)
	self:GetParent():Hide()
end)

-- complete black background to make it look better
frame.bg = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
frame.bg:SetTexture(1,1,1)
frame.bg:SetVertexColor(0,0,0,.5)
frame.bg:SetAllPoints()

-- player model with actualy transmog enabled aswell
frame.model = CreateFrame("PlayerModel",nil,frame)
frame.model:SetSize(frame.h,frame.h*1.5)
frame.model:SetPoint("BOTTOMRIGHT",frame.h*0.2,-frame.h*0.4)

-- shadow gran
frame.gradient = frame.model:CreateTexture(nil,"BACKGROUND",nil,-7)
frame.gradient:SetTexture(1,1,1)
frame.gradient:SetVertexColor(0,0,0,1)
frame.gradient:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
frame.gradient:SetPoint("BOTTOMLEFT",frame)
frame.gradient:SetPoint("BOTTOMRIGHT",frame)
frame.gradient:SetHeight(50)

frame.gradient2 = frame.model:CreateTexture(nil,"BACKGROUND",nil,-7)
frame.gradient2:SetTexture(1,1,1)
frame.gradient2:SetVertexColor(0,0,0,1)
frame.gradient2:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 0.5)
frame.gradient2:SetPoint("TOPLEFT",frame)
frame.gradient2:SetPoint("TOPRIGHT",frame)
frame.gradient2:SetHeight(50)

frame.gradient3 = frame.model:CreateTexture(nil,"BACKGROUND",nil,-7)
frame.gradient3:SetTexture(1,1,1)
frame.gradient3:SetVertexColor(0,0,0,1)
frame.gradient3:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.5, 0, 0, 0, 0)
frame.gradient3:SetPoint("TOPLEFT",frame)
frame.gradient3:SetPoint("BOTTOMLEFT",frame)
frame.gradient3:SetWidth(50)

frame.gradient4 = frame.model:CreateTexture(nil,"BACKGROUND",nil,-7)
frame.gradient4:SetTexture(1,1,1)
frame.gradient4:SetVertexColor(0,0,0,1)
frame.gradient4:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0, 0, 0, 0, 0.5)
frame.gradient4:SetPoint("TOPRIGHT",frame)
frame.gradient4:SetPoint("BOTTOMRIGHT",frame)
frame.gradient4:SetWidth(50)

-- registers the /afk scene
frame:RegisterEvent("PLAYER_FLAGS_CHANGED")
frame:RegisterEvent("PLAYER_LOGIN")

-- on event start
frame:SetScript("OnEvent",frame.OnEvent)