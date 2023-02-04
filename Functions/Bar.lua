---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Bar = {}

function TRB.Functions.Bar:ShowResourceBar()
	if TRB.Details.addonData.registered == false then
		TRB.Functions.EventRegistration()
	end

	TRB.Data.snapshotData.isTracking = true
	TRB.Functions.Bar:HideResourceBar()
end

function TRB.Functions.Bar:HideResourceBar(force)
    force = force or false
    TRB.Functions.Bar.HideResourceBarFunction(force)
end

function TRB.Functions.Bar:PulseFrame(frame, alphaOffset, flashPeriod)
	frame:SetAlpha(((1.0 - alphaOffset) * math.abs(math.sin(2 * (GetTime()/flashPeriod)))) + alphaOffset)
end