local _, TRB = ...
if TRB.Data.character.classId ~= 1 then -- Only do this if we are on a Warrior!
	return
end

-- Warrior runtime (World of Warcraft: Forever). The template installs the bars; stance tracking is
-- layered on top so stance-gated threshold lines only draw in a stance that can cast them.
local runtime = TRB.Forever.Templates.Runtime:Install("warrior")

-- The stance bar is in learn order, so the index alone identifies the stance when the client's
-- GetShapeshiftFormInfo gives no spell id.
local stanceByIndex = { "battle", "defensive", "berserker" }

---The stance a stance spell belongs to, from the spell list, or nil when it isn't one.
---@param spellId integer?
---@return string?
local function GetStanceBySpellId(spellId)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.GeneralSpells?]]
	if spellId == nil or spells == nil or spells.battleStance == nil then
		return nil
	end
	if spellId == spells.battleStance.id then
		return "battle"
	elseif spellId == spells.defensiveStance.id then
		return "defensive"
	elseif spellId == spells.berserkerStance.id then
		return "berserker"
	end
	return nil
end

---The stance the character is in, or nil when in none.
---@return string?
local function GetActiveStance()
	local index = GetShapeshiftForm()
	if index == nil or index == 0 then
		return nil
	end
	local spellId = select(4, GetShapeshiftFormInfo(index))
	return GetStanceBySpellId(spellId) or stanceByIndex[index]
end

---Re-reads the stance; a change redraws the threshold lines gated on it.
local function UpdateStance()
	local stance = GetActiveStance()
	if stance == runtime.stance then
		return
	end
	runtime.stance = stance
	TRB.Data.character.currentStance = stance
	if TRB.Data.barConstructedForSpec == nil then
		return
	end
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local stanceFrame = CreateFrame("Frame")
stanceFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
stanceFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
stanceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
stanceFrame:SetScript("OnEvent", UpdateStance)

-- /trb stance reports what the stance bar says, so a wrong stance gate can be spotted in one line.
TRB.Classes.SpecDescriptor:Declare("warrior_general", {
	slashCommands = {
		stance = function()
			local index = GetShapeshiftForm()
			print(string.format("|cFFFF8800TRB Stance:|r resolved=%s GetShapeshiftForm()=%s forms=%s",
				tostring(runtime.stance), tostring(index), tostring(GetNumShapeshiftForms())))
			for i = 1, (GetNumShapeshiftForms() or 0) do
				local a, b, c, d = GetShapeshiftFormInfo(i)
				print(string.format("  [%d] %s, %s, %s, %s", i, tostring(a), tostring(b), tostring(c), tostring(d)))
			end
		end,
	},
})
