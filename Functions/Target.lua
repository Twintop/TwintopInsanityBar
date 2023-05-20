---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Target = {}

function TRB.Functions.Target:GetUnitHealthPercent(unit)
	if GetUnitName(unit) then
		local health = UnitHealth(unit)
		local maxHealth = UnitHealthMax(unit)
		return health / maxHealth
	else
		return nil
	end
end
