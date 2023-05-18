---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.Target = {}
TRB.Classes.Target.__index = TRB.Classes.Target

function TRB.Classes.Target:New(guid)
    local self = {}
    setmetatable(self, TRB.Classes.Target)
    self.guid = guid
    self.timeToDie = {
        time = 0,
        lastUpdate = nil,
        deathPercent = TRB.Functions.TimeToDie:GetDeathHealthPercentage(guid),
        snapshots = {}
    }
    self.spells = {}
    return self
end

function TRB.Classes.Target:AddSpellTracking(spell, isDot, hasCounter)
    isDot = isDot or true
    hasCounter = hasCounter or false
    if self.spells[spell.id] == nil then
		self.spells[spell.id] = {
			active = false
		}

        self.spells[spell.id].isDot = isDot
        if isDot then
            self.spells[spell.id].remainingTime = 0
        end

        self.spells[spell.id].hasCounter = hasCounter
        if hasCounter then
            self.spells[spell.id].count = 0
        end
	end
end

function TRB.Classes.Target:UpdateAllSpellTracking(currentTime)
	currentTime = currentTime or GetTime()
    if TRB.Functions.Table:Length(self.spells) > 0 then
        for spellId, _ in pairs(self.spells) do
            self:UpdateSpellTracking(spellId, currentTime)
        end
    end
end

function TRB.Classes.Target:UpdateSpellTracking(spellId, currentTime)
	currentTime = currentTime or GetTime()
    if self.spells[spellId] == nil then
        return
    end

    if self.spells[spellId].isDot then
        local expiration = select(6, TRB.Functions.Aura:FindDebuffById(spellId, "target", "player"))

        if expiration ~= nil then
            self.spells[spellId].active = true
            self.spells[spellId].remainingTime = expiration - currentTime
            return
        end
    end
end

---Attempts to update the Time To Die for this creature. May fail if this creature does not have a current UnitToken.
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
function TRB.Classes.Target:UpdateTimeToDie(currentTime)
    currentTime = currentTime or GetTime()
    -- TODO: Look in to hooking in to nameplates to get the info we need for this
    local unitToken = UnitTokenFromGUID(self.guid)

    if unitToken ~= nil then
        local currentHealth = UnitHealth(unitToken)
        local maxHealth = UnitHealthMax(unitToken)
        local healthDelta = 0
        local timeDelta = 0
        local dps = 0
        local ttd = 0
        local count = TRB.Functions.Table:Length(self.timeToDie.snapshots)

        if count > 0 and self.timeToDie.snapshots[1] ~= nil then
            healthDelta = math.max(self.timeToDie.snapshots[1].health - currentHealth, 0)
            timeDelta = math.max(currentTime - self.timeToDie.snapshots[1].time, 0)
        end

        if currentHealth <= 0 or maxHealth <= 0 then
            dps = 0
            ttd = 0
        else
            if count == 0 or self.timeToDie.snapshots[count] == nil or
                (self.timeToDie.snapshots[1].health == currentHealth and count == TRB.Data.settings.core.ttd.numEntries) then
                dps = 0
            elseif healthDelta == 0 or timeDelta == 0 then
                dps = self.timeToDie.snapshots[count].dps
            else
                dps = healthDelta / timeDelta
            end

            if dps == nil or dps == 0 then
                ttd = 0
            else
                local deathHealth = maxHealth * self.timeToDie.deathPercent
                ttd = math.max(math.max(currentHealth - deathHealth, 0) / dps, 0)
            end
        end

        self.timeToDie.lastUpdate = currentTime

        if count >= TRB.Data.settings.core.ttd.numEntries then
            table.remove(self.timeToDie.snapshots, 1)
        end

        table.insert(self.timeToDie.snapshots, {
            health=currentHealth,
            time=currentTime,
            dps=dps
        })

        self.timeToDie.time = ttd
    end
end