local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_Button(self)
	B.CreateBDFrame(self)
	B.ReskinText(self.ButtonText, 1, .8, 0)
end

C.LUAThemes["Blizzard_SubscriptionInterstitialUI"] = function()
	B.ReskinFrame(SubscriptionInterstitialFrame)

	B.ReskinButton(SubscriptionInterstitialFrame.ClosePanelButton)
	Reskin_Button(SubscriptionInterstitialFrame.UpgradeButton)
	Reskin_Button(SubscriptionInterstitialFrame.SubscribeButton)
end