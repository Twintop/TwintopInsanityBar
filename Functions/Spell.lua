---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Spell = {}


function TRB.Functions.Spell:FillSpellData(spells)
	if spells == nil then
		spells = TRB.Data.spells
	end

	local toc = select(4, GetBuildInfo())

	for k, v in pairs(spells) do
		if spells[k] ~= nil and (spells[k]["tocMinVersion"] == nil or toc >= spells[k]["tocMinVersion"]) then
			if spells[k]["itemId"] ~= nil and spells[k]["useSpellIcon"] ~= true then
				local _, name, icon
				name, _, _, _, _, _, _, _, _, icon = GetItemInfo(spells[k]["itemId"])
				if name ~= nil then
					spells[k]["name"] = name
				end

				if spells[k]["iconName"] ~= nil then
					icon = "Interface\\Icons\\" .. spells[k]["iconName"]
				end
				
				if icon ~= nil then
					spells[k]["icon"] = string.format("|T%s:0|t", icon)
					spells[k]["texture"] = icon
				end
			elseif spells[k]["id"] ~= nil or (spells[k]["spellId"] ~= nil and spells[k]["useSpellIcon"] == true) then
				local _, name, icon
				if spells[k]["spellId"] ~= nil and spells[k]["useSpellIcon"] == true then
					name, _, icon = GetSpellInfo(spells[k]["spellId"])
				else
					name, _, icon = GetSpellInfo(spells[k]["id"])
				end
				
				if spells[k]["iconName"] ~= nil then
					icon = "Interface\\Icons\\" .. spells[k]["iconName"]
				end

				spells[k]["icon"] = string.format("|T%s:0|t", icon)
				spells[k]["name"] = name

				if spells[k]["thresholdId"] ~= nil then
					spells[k]["texture"] = icon
				end
			end
		end
	end

	spells = TRB.Functions.Spell:FillSpellDataManaCost(spells)

	return spells
end

function TRB.Functions.Spell:GetSpellManaCost(spellId)
---@diagnostic disable-next-line: redundant-parameter
	local spc = GetSpellPowerCost(spellId)
	local length = TRB.Functions.Table:Length(spc)

	for x = 1, length do
		if spc[x]["name"] == "MANA" and spc[x]["cost"] > 0 then
			return spc[x]["cost"]
		end
	end
	return 0
end

function TRB.Functions.Spell:GetSpellManaCostPerSecond(spellId)
---@diagnostic disable-next-line: redundant-parameter
	local spc = GetSpellPowerCost(spellId)
	local length = TRB.Functions.Table:Length(spc)

	for x = 1, length do
		if spc[x]["name"] == "MANA" and spc[x]["costPerSec"] > 0 then
			return spc[x]["costPerSec"]
		end
	end
	return 0
end

function TRB.Functions.Spell:FillSpellDataManaCost(spells)
	if spells == nil then
		spells = TRB.Data.spells
	end

	local toc = select(4, GetBuildInfo())

	for k, v in pairs(spells) do
		if spells[k] ~= nil and spells[k]["id"] ~= nil and (spells[k]["tocMinVersion"] == nil or toc >= spells[k]["tocMinVersion"]) and spells[k]["usesMana"] then
			spells[k]["mana"] = -TRB.Functions.Spell:GetSpellManaCost(spells[k]["id"])
		end
	end

	return spells
end

function TRB.Functions.Spell:GetRemainingTime(snapshotSpell, leeway)
	-- For snapshotData objects that contain .isActive or .endTime
	local currentTime = GetTime()
	local remainingTime = 0
	local endTime = nil

	if snapshotSpell == nil then
		return remainingTime
	end
	
	if leeway and snapshotSpell.endTimeLeeway ~= nil then
		endTime = snapshotSpell.endTimeLeeway
	else
		endTime = snapshotSpell.endTime
	end

	if endTime ~= nil and (snapshotSpell.isActive or endTime > currentTime) then
		remainingTime = endTime - currentTime
	elseif snapshotSpell.startTime ~= nil and snapshotSpell.duration ~= nil and snapshotSpell.duration > 0 then
		remainingTime = snapshotSpell.duration - (currentTime - snapshotSpell.startTime)
	end

	if remainingTime < 0 then
		remainingTime = 0
	end

	return remainingTime
end