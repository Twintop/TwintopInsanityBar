---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Target = {}


function TRB.Functions.Target:CheckTargetExists(guid)
	if guid == nil or (not TRB.Data.snapshot.targetData.targets[guid] or TRB.Data.snapshot.targetData.targets[guid] == nil) then
		return false
	end
	return true
end

function TRB.Functions.Target:RemoveTarget(guid)
	if guid ~= nil and TRB.Functions.Target:CheckTargetExists(guid) then
		TRB.Data.snapshot.targetData.targets[guid] = nil
	end
end

function TRB.Functions.Target:InitializeTarget(guid)
	if guid ~= nil and guid ~= "" then
		if not TRB.Functions.Target:CheckTargetExists(guid) then
			TRB.Data.snapshot.targetData.targets[guid] = TRB.Classes.Target:New(guid)
		end
	end
end

function TRB.Functions.Target:TargetsCleanup(clearAll)
	if clearAll == true then
		TRB.Data.snapshot.targetData.targets = {}
	else
		local currentTime = GetTime()
		for tguid,count in pairs(TRB.Data.snapshot.targetData.targets) do
			if (currentTime - TRB.Data.snapshot.targetData.targets[tguid].lastUpdate) > 20 then
				TRB.Functions.Target:RemoveTarget(tguid)
			end
		end
	end
end

function TRB.Functions.Target:GetUnitHealthPercent(unit)
	if GetUnitName(unit) then
		local health = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		return health / maxHealth
	else
		return nil
	end
end
