local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if AuroraConfig.tooltips then
		F.StripTextures(QueueStatusFrame, true)
		F.CreateBD(QueueStatusFrame)
		F.CreateSD(QueueStatusFrame)
	end
end)
