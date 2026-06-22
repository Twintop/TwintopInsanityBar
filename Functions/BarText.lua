local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.BarText = {}

local containerAnchorPrefix = "Container::"
local containerAnchorLabelByResourceType = {
	AngelicFeather = L["AngelicFeatherContainer"],
	ArcaneCharges = L["ArcaneChargesContainer"],
	BoneShield = L["BoneShieldContainer"],
	Chi = L["ChiContainer"],
	ComboPoints = L["ComboPointsContainer"],
	Essence = L["EssenceContainer"],
	Icicles = L["IciclesContainer"],
	Lightweaver = L["LightweaverContainer"],
	HolyPower = L["HolyPowerContainer"],
	MaelstromWeapon = L["MaelstromWeaponContainer"],
	Runes = L["RunesContainer"],
	SoulFragments = L["SoulFragmentsContainer"],
	SoulShards = L["SoulShardsContainer"],
	TipOfTheSpear = L["TipOfTheSpearContainer"],
	WhirlwindCharges = L["WhirlwindChargesContainer"],
}

local containerAnchorFirstNodeLabelByResourceType = {
	AngelicFeather = L["AngelicFeatherCharge1"],
	ArcaneCharges = L["ArcaneCharge1"],
	BoneShield = L["BoneShield1"],
	Chi = L["Chi1"],
	ComboPoints = L["ComboPoint1"],
	Essence = L["Essence1"],
	HolyPower = L["HolyPower1"],
	Icicles = L["Icicle1"],
	Lightweaver = L["LightweaverCharge1"],
	MaelstromWeapon = L["Maelstrom1"],
	Runes = L["Rune1"],
	SoulFragments = L["SoulFragment1"],
	SoulShards = L["SoulShard1"],
	TipOfTheSpear = L["TipOfTheSpear1"],
	WhirlwindCharges = L["WhirlwindCharge1"],
}

local function GetContainerAnchorBarGroupKey(relativeToFrame)
	if type(relativeToFrame) ~= "string" then
		return nil
	end

	return string.match(relativeToFrame, "^Container::(.+)$")
end

local function GetContainerAnchorDefinition(classId, specId, barGroupKey)
	local specConfig = TRB.Functions.Character:GetSpecBarGroupConfig(classId, specId)
	if specConfig == nil then
		return nil
	end

	local barGroupConfig = specConfig[barGroupKey]
	if barGroupConfig == nil or (barGroupConfig.maxNodes or 1) <= 1 or barGroupConfig.allowContainerAnchor == false then
		return nil
	end

	local label = containerAnchorLabelByResourceType[barGroupConfig.resourceType]
	if label == nil then
		return nil
	end

	return {
		id = containerAnchorPrefix .. barGroupKey,
		label = label,
		barGroupKey = barGroupKey,
		insertBeforeLabel = containerAnchorFirstNodeLabelByResourceType[barGroupConfig.resourceType],
	}
end

---@param classId integer?
---@param specId integer?
---@return table[]
function TRB.Functions.BarText:GetContainerAnchorOptions(classId, specId)
	local specConfig = TRB.Functions.Character:GetSpecBarGroupConfig(classId, specId)
	local options = {}

	if specConfig == nil then
		return options
	end

	for barGroupKey, _ in pairs(specConfig) do
		local definition = GetContainerAnchorDefinition(classId, specId, barGroupKey)
		if definition ~= nil then
			table.insert(options, definition)
		end
	end

	table.sort(options, function(a, b)
		return a.label < b.label
	end)

	return options
end

---@param relativeToFrame string
---@param classId integer?
---@param specId integer?
---@return Frame|nil, boolean, boolean
function TRB.Functions.BarText:GetAnchorFrame(relativeToFrame, classId, specId)
	classId = classId or TRB.Data.character.classId
	specId = specId or TRB.Data.character.specId

	if relativeToFrame == "UIParent" then
		return UIParent, true, true
	end

	local barGroupKey = GetContainerAnchorBarGroupKey(relativeToFrame)
	if barGroupKey ~= nil then
		local definition = GetContainerAnchorDefinition(classId, specId, barGroupKey)
		if definition == nil then
			return nil, false, false
		end

		local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
		local barGroup = barGroups and barGroups[barGroupKey]
		if barGroup ~= nil then
			return barGroup:GetContainerFrame(), true, barGroup.isVisible
		end

		return nil, true, false
	end

	return TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
end

---@param frame Frame?
---@param barGroup TRB.Classes.BarGroup?
---@return boolean
local function BarGroupContainsFrame(frame, barGroup)
	if frame == nil or barGroup == nil then
		return false
	end

	if barGroup.GetContainerFrame and frame == barGroup:GetContainerFrame() then
		return true
	end

	if barGroup.GetAnchorFrame and frame == barGroup:GetAnchorFrame() then
		return true
	end

	if barGroup.GetNodes then
		for _, node in ipairs(barGroup:GetNodes()) do
			if node and node.GetFrame and frame == node:GetFrame() then
				return true
			end
		end
	end

	return false
end

---@param barTextEntry table?
---@param barGroupKey string
---@param classId integer?
---@param specId integer?
---@return boolean
function TRB.Functions.BarText:IsEntryAnchoredToBarGroup(barTextEntry, barGroupKey, classId, specId)
	local relativeToFrame = barTextEntry and barTextEntry.position and barTextEntry.position.relativeToFrame
	if type(relativeToFrame) ~= "string" then
		return false
	end

	local containerBarGroupKey = GetContainerAnchorBarGroupKey(relativeToFrame)
	if containerBarGroupKey ~= nil then
		return containerBarGroupKey == barGroupKey
	end

	local activeClassId = TRB.Data.character.classId
	local activeSpecId = TRB.Data.character.specId
	if classId ~= nil and specId ~= nil and (classId ~= activeClassId or specId ~= activeSpecId) then
		return false
	end

	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local barGroup = barGroups and barGroups[barGroupKey]
	if barGroup == nil then
		return false
	end

	local anchorFrame = self:GetAnchorFrame(relativeToFrame, classId, specId)
	return BarGroupContainsFrame(anchorFrame, barGroup)
end

-- Hash table for O(1) bar text cache lookups (keyed by cleanedText).
-- Declared at file scope so ClearBarTextCacheHash and GetFromBarTextCache share the same upvalue.
local barTextCacheHash = {}

---Returns true if the value or color has changed for this key, indicating the
---formatted lookup string needs updating. Reuses existing prevState entries to
---avoid table allocation after initial warm-up.
---@param prevState table Memoization state table (TRB.Data.prevLookupState)
---@param key string The lookup key (e.g., "$resource")
---@param rawValue any The current raw value (used for equality comparison only)
---@param color string|nil The current color hex string (nil for uncolored variables)
---@param isSecret boolean|nil When true, the value originates from a WoW API that returns
---        "secret" numbers (e.g., UnitPower, UnitHealth). Secret numbers cannot be
---        compared or stored safely, so we always assume the value has changed.
---@return boolean changed True if the formatted lookup[key] needs rewriting
function TRB.Functions.BarText.LookupChanged(prevState, key, rawValue, color, isSecret)
	if isSecret or issecretvalue(rawValue) then
		-- Invalidate prevState so the next non-secret value is guaranteed to trigger an update
		prevState[key] = nil
		return true
	end
	local prev = prevState[key]
	if prev ~= nil and prev[1] == rawValue and prev[2] == color then
		return false
	end
	if prev == nil then
		prevState[key] = { rawValue, color }
	else
		prev[1] = rawValue
		prev[2] = color
	end
	return true
end

---Marks the lookup data as dirty so the next tick will refresh all lookup variables.
---This is very cheap (a single boolean write) and should be called from any event handler
---that changes data consumed by RefreshLookupData.
function TRB.Functions.BarText:MarkLookupDirty()
	TRB.Data.lookupDirty = true
end

---Clears the lookup memoization state, forcing all variables to be recomputed on next tick.
---Also marks lookup data as dirty.
function TRB.Functions.BarText:InvalidateLookupMemoization()
	TRB.Data.prevLookupState = TRB.Data.prevLookupState or {}
	wipe(TRB.Data.prevLookupState)
	TRB.Data.lookupDirty = true
end

---Clears the bar text format cache hash. Must be called whenever TRB.Data.cache.barText
---is reassigned (spec switch, settings edit, etc.) to keep the O(1) hash in sync.
function TRB.Functions.BarText:ClearBarTextCacheHash()
	-- The hash is a local upvalue; wipe it here where it's in scope
	for k in pairs(barTextCacheHash) do barTextCacheHash[k] = nil end
end

---Scans all enabled bar text entries and builds a set of which $variable and #icon
---keys are actually referenced. This set is used by RefreshLookupData functions to
---skip computation of variables that no enabled bar text entry uses.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
function TRB.Functions.BarText:BuildActiveVariableSet(settings)
	local activeVars = {}
	if settings ~= nil and settings.displayText ~= nil then
		local displayText = settings.displayText
		local entries = #displayText.barText
		for i = 1, entries do
			if displayText.barText[i].enabled then
				local text = displayText.barText[i].text
				if text and text ~= "" then
					-- Extract $variable references (e.g., $resource, $eclipseTime)
					for var in string.gmatch(text, "%$[%a_][%w_]*") do
						activeVars[var] = true
					end
					-- Extract #icon references (e.g., #casting, #eclipse)
					for icon in string.gmatch(text, "#[%a_][%w_]*") do
						activeVars[icon] = true
					end
				end
			end
		end
	end
	TRB.Data.activeVariables = activeVars
end

---Creates and returns the common bar text icons shared by all specializations, with any additional spec-specific icons appended.
---@param additionalIcons table|nil Optional array of spec-specific icon entries to append
---@return table # Combined icons table
function TRB.Functions.BarText:GetCommonIcons(additionalIcons)
	local icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	if additionalIcons then
		for _, v in ipairs(additionalIcons) do
			table.insert(icons, v)
		end
	end
	return icons
end

TRB.Functions.BarText.VariableLogicType = {
	NONE = "none",
	BOOLEAN = "boolean",
	INTEGER = "integer",
	NUMBER = "number",
	TEXT = "text",
	UNKNOWN = "unknown",
}

TRB.Functions.BarText.VariableRenderType = {
	TEXT = "text",
	LOGIC_ONLY = "logicOnly",
	ICON = "icon",
	COMMAND = "command",
	UNKNOWN = "unknown",
}

local defaultSecretBarTextVariables = {
	["$health"] = true,
	["$healthMax"] = true,
	["$healthPercent"] = true,
	["$absorb"] = true,
	["$incomingHeal"] = true,
	["$healAbsorb"] = true,
}

---@param variable string|nil
---@param sectionKey string
---@param entry table
---@return string
local function InferBarTextVariableLogicType(variable, sectionKey, entry)
	if sectionKey == "icons" or sectionKey == "pipe" then
		return TRB.Functions.BarText.VariableLogicType.NONE
	end

	if type(entry.logicType) == "string" and entry.logicType ~= "" then
		return entry.logicType
	end

	local variableName = string.gsub(variable or "", "^%$", "")
	variableName = string.lower(variableName)

	if variableName == "" then
		return TRB.Functions.BarText.VariableLogicType.UNKNOWN
	end

	if entry.logicOnly == true then
		return TRB.Functions.BarText.VariableLogicType.BOOLEAN
	end

	if variableName == "incombat" or variableName == "instealth" or variableName == "eclipse" or
		variableName == "lunar" or variableName == "solar" or variableName == "celestialalignment" or
		variableName == "rtbgoodbuff" or variableName == "benediction" or
		string.match(variableName, "usable$") ~= nil or string.match(variableName, "ready$") ~= nil or
		string.match(variableName, "active$") ~= nil then
		return TRB.Functions.BarText.VariableLogicType.BOOLEAN
	end

	if string.match(variableName, "percent$") ~= nil or string.match(variableName, "time$") ~= nil or
		variableName == "gcd" or variableName == "haste" or variableName == "crit" or
		variableName == "mastery" or variableName == "vers" or variableName == "versatility" or
		variableName == "overs" or variableName == "dvers" then
		return TRB.Functions.BarText.VariableLogicType.NUMBER
	end

	if string.match(variableName, "stacks$") ~= nil or string.match(variableName, "charges$") ~= nil or
		string.match(variableName, "count$") ~= nil or string.match(variableName, "rating$") ~= nil or
		string.match(variableName, "max$") ~= nil or string.match(variableName, "maxcharges$") ~= nil or
		string.match(variableName, "remainingstacks$") ~= nil or string.match(variableName, "extensionsremaining$") ~= nil then
		return TRB.Functions.BarText.VariableLogicType.INTEGER
	end

	return TRB.Functions.BarText.VariableLogicType.NUMBER
end

---@param variable string|nil
---@param sectionKey string
---@param entry table
---@param logicType string
---@return boolean
local function InferBarTextVariableBooleanCheck(variable, sectionKey, entry, logicType)
	if entry.booleanCheck ~= nil then
		return entry.booleanCheck == true
	end

	if sectionKey == "icons" or sectionKey == "pipe" then
		return false
	end

	if entry.logicOnly == true or logicType == TRB.Functions.BarText.VariableLogicType.BOOLEAN then
		return true
	end

	local variableName = string.gsub(variable or "", "^%$", "")
	variableName = string.lower(variableName)

	if variableName == "resource" or variableName == "mana" or variableName == "energy" or
		variableName == "rage" or variableName == "focus" or variableName == "fury" or
		variableName == "pain" or variableName == "insanity" or variableName == "astralpower" or
		variableName == "maelstrom" or variableName == "runicpower" or variableName == "holypower" or
		variableName == "resourcepercent" or variableName == "manapercent" then
		return false
	end

	if variableName == "casting" or variableName == "health" or variableName == "healthmax" or
		variableName == "healthpercent" or variableName == "absorb" or variableName == "incomingheal" or
		variableName == "gcd" or variableName == "haste" or variableName == "crit" or
		variableName == "mastery" or variableName == "vers" or variableName == "versatility" or
		variableName == "overs" or variableName == "dvers" then
		return true
	end

	return string.match(variableName, "time$") ~= nil or string.match(variableName, "stacks$") ~= nil or
		string.match(variableName, "charges$") ~= nil or string.match(variableName, "count$") ~= nil or
		string.match(variableName, "rating$") ~= nil or string.match(variableName, "max$") ~= nil or
		string.match(variableName, "remainingstacks$") ~= nil or string.match(variableName, "extensionsremaining$") ~= nil
end

---@param entry table
---@param sectionKey string
---@return table
function TRB.Functions.BarText:GetVariableMetadata(entry, sectionKey)
	entry = entry or {}
	sectionKey = sectionKey or "values"

	local logicType = InferBarTextVariableLogicType(entry.variable, sectionKey, entry)
	local comparisonUsable = entry.comparisonUsable
	if comparisonUsable == nil then
		comparisonUsable = logicType == self.VariableLogicType.NUMBER or logicType == self.VariableLogicType.INTEGER
	end

	local booleanCheck = InferBarTextVariableBooleanCheck(entry.variable, sectionKey, entry, logicType)

	local renderType = entry.renderType
	if renderType == nil then
		if sectionKey == "icons" then
			renderType = self.VariableRenderType.ICON
		elseif sectionKey == "pipe" then
			renderType = self.VariableRenderType.COMMAND
		elseif entry.logicOnly == true or entry.renderText == false then
			renderType = self.VariableRenderType.LOGIC_ONLY
		elseif logicType == self.VariableLogicType.BOOLEAN and entry.variable ~= "$inCombat" then
			renderType = self.VariableRenderType.LOGIC_ONLY
		else
			renderType = self.VariableRenderType.TEXT
		end
	end

	return {
		secret = entry.secret == true or defaultSecretBarTextVariables[entry.variable] == true,
		logicType = logicType,
		comparisonUsable = comparisonUsable == true,
		booleanCheck = booleanCheck == true,
		logicOnly = renderType == self.VariableRenderType.LOGIC_ONLY,
		renderType = renderType,
	}
end

---Creates and returns the common bar text values shared by all specializations, with any additional spec-specific values appended.
---@param additionalValues table|nil Optional array of spec-specific value entries to append
---@return table # Combined values table
function TRB.Functions.BarText:GetCommonValues(additionalValues)
	local values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },

		{ variable = "$health", description = L["BarTextVariable_health"], printInSettings = true, color = false, secret = true },
		{ variable = "$healthMax", description = L["BarTextVariable_healthMax"], printInSettings = true, color = false, secret = true },
		{ variable = "$healthPercent", description = L["BarTextVariable_healthPercent"], printInSettings = true, color = false, secret = true },
		{ variable = "$absorb", description = L["BarTextVariable_absorb"], printInSettings = true, color = false, secret = true },
		{ variable = "$incomingHeal", description = L["BarTextVariable_incomingHeal"], printInSettings = true, color = false, secret = true },
		{ variable = "$healAbsorb", description = L["BarTextVariable_healAbsorb"], printInSettings = true, color = false, secret = true },

		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
		{ variable = "$inCombatTime", description = L["BarTextVariableInCombatTime"], printInSettings = true, color = false },
	}
	if additionalValues then
		for _, v in ipairs(additionalValues) do
			table.insert(values, v)
		end
	end
	return values
end

---Sets the text on a bar text frame's font string via a protected call wrapper
---@param frame Frame The bar text frame containing a .font FontString
---@param text string The text to display
local function TryUpdateText(frame, text)
---@diagnostic disable-next-line: undefined-field
	frame.font:SetText(text)
end

---Scans the input string for logic symbols and returns their positions and levels
---@param input string
---@return table
local function ScanForLogicSymbols(input)
	local returnTable = {
		all = {}
	}

	if input == nil or string.len(input) == 0 then
		return returnTable
	end

	local a, b, c, d, e, e_1, e_2, e_3, f, g, h, i, j, k, k_1, l, m, n, o, p, q, r, s, t
	local _
	local currentLevel = 0
	local currentParenthesisLevel = 0
	local min
	local index = 0

	local all = {}
	local ins = {}

	local endLength = (string.len(input) + 1)

	local currentPosition = 0
	while currentPosition <= string.len(input) do
		a, _ = string.find(input, "{", currentPosition)
		b, _ = string.find(input, "}", currentPosition)
		c, _ = string.find(input, "%[", currentPosition) --Escape because this isn't regex
		d, _ = string.find(input, "]", currentPosition)
		e, _ = string.find(input, "||", currentPosition)
		e_1, _ = string.find(input, "|n", currentPosition)
		e_2, _ = string.find(input, "|c", currentPosition)
		e_3, _ = string.find(input, "|r", currentPosition)
		f, _ = string.find(input, "&", currentPosition)
		g, _ = string.find(input, "!", currentPosition)
		h, _ = string.find(input, "%$", currentPosition) --Escape because this isn't regex
		i, _ = string.find(input, "%(", currentPosition) --Escape because this isn't regex
		j, _ = string.find(input, ")", currentPosition)
		k, _ = string.find(input, "==", currentPosition)
		k_1, _ = string.find(input, "=", currentPosition)
		l, _ = string.find(input, "~=", currentPosition)
		m, _ = string.find(input, ">=", currentPosition)
		n, _ = string.find(input, "<=", currentPosition)
		o, _ = string.find(input, ">", currentPosition)
		p, _ = string.find(input, "<", currentPosition)
		q, _ = string.find(input, "+", currentPosition)
		r, _ = string.find(input, "-", currentPosition)
		s, _ = string.find(input, "*", currentPosition)
		t, _ = string.find(input, "/", currentPosition)


		a = a or endLength
		b = b or endLength
		c = c or endLength
		d = d or endLength
		e = e or endLength
		e_1 = e_1 or endLength
		e_2 = e_2 or endLength
		e_3 = e_3 or endLength
		f = f or endLength
		g = g or endLength
		h = h or endLength
		i = i or endLength
		j = j or endLength
		k = k or endLength
		k_1 = k_1 or endLength
		l = l or endLength
		m = m or endLength
		n = n or endLength
		o = o or endLength
		p = p or endLength
		q = q or endLength
		r = r or endLength
		s = s or endLength
		t = t or endLength

		if e == e_1 or e == e_2 or e == e_3 then
			e = endLength
		end

		min = math.min(a, b, c, d, e, f, g, h, i, j, k, k_1, l, m, n, o, p, q, r, s, t)
		index = index + 1

		if min <= string.len(input) then
			ins.position = min
			ins.level = currentLevel
			ins.parenthesisLevel = currentParenthesisLevel
			ins.index = index

			if min == a then
				currentLevel = currentLevel + 1
				currentParenthesisLevel = currentParenthesisLevel + 1
				ins.level = currentLevel
				ins.parenthesisLevel = currentParenthesisLevel
				ins.symbol = "{"
				currentPosition = a + 1
			elseif min == b then
				currentLevel = currentLevel - 1
				currentParenthesisLevel = currentParenthesisLevel - 1
				ins.symbol = "}"
				currentPosition = b + 1
			elseif min == c then
				currentLevel = currentLevel + 1
				currentParenthesisLevel = currentParenthesisLevel + 1
				ins.level = currentLevel
				ins.parenthesisLevel = currentParenthesisLevel
				ins.symbol = "["
				currentPosition = c + 1
			elseif min == d then
				currentLevel = currentLevel - 1
				currentParenthesisLevel = currentParenthesisLevel - 1
				ins.symbol = "]"
				currentPosition = d + 1
			elseif min == e then
				ins.symbol = "|"
				currentPosition = e + 1
			elseif min == f then
				ins.symbol = "&"
				currentPosition = f + 1
			elseif min == g then
				ins.symbol = "!"
				currentPosition = g + 1
			elseif min == h then
				ins.symbol = "$"
				currentPosition = h + 1
			elseif min == i then
				currentParenthesisLevel = currentParenthesisLevel + 1
				ins.parenthesisLevel = currentParenthesisLevel
				ins.symbol = "("
				currentPosition = i + 1
			elseif min == j then
				ins.symbol = ")"
				currentParenthesisLevel = currentParenthesisLevel - 1
				currentPosition = j + 1
			elseif min == k then
				ins.symbol = "=="
				currentPosition = k + 2
			elseif min == l then
				ins.symbol = "~="
				currentPosition = l + 2
			elseif min == m then
				ins.symbol = ">="
				currentPosition = m + 2
			elseif min == n then
				ins.symbol = "<="
				currentPosition = n + 2
			elseif min == k_1 then
				ins.symbol = "="
				currentPosition = k_1 + 1
			elseif min == o then
				ins.symbol = ">"
				currentPosition = o + 1
			elseif min == p then
				ins.symbol = "<"
				currentPosition = p + 1
			elseif min == q then
				ins.symbol = "+"
				currentPosition = q + 1
			elseif min == r then
				ins.symbol = "-"
				currentPosition = r + 1
			elseif min == s then
				ins.symbol = "*"
				currentPosition = s + 1
			elseif min == t then
				ins.symbol = "/"
				currentPosition = t + 1
			else -- Something went wrong. Break for safety
				currentPosition = string.len(input) + 1
				break
			end

			table.insert(all, {
				position = ins.position,
				level = ins.level,
				parenthesisLevel = ins.parenthesisLevel,
				index = ins.index,
				symbol = ins.symbol
			})
		else
			currentPosition = string.len(input) + 1
			break
		end
	end
	returnTable.all = all

	return returnTable
end

---Finds the next symbol index in the table
---@param t table
---@param symbol string
---@param notSymbol boolean?
---@param minIndex number
---@param maxIndex number?
---@param minPosition number?
---@param maxPosition number?
---@return table|nil
local function FindNextSymbolIndex(t, symbol, notSymbol, minIndex, maxIndex, minPosition, maxPosition)
	if t == nil or symbol == nil then
		return nil
	end

	local len = #t
	if len == 0 then
		return nil
	end

	minIndex = minIndex or 0
	minPosition = minPosition or 0
	notSymbol = notSymbol or false
	maxIndex = maxIndex or t[len].index
	maxPosition = maxPosition or t[len].position

	for k, _ in ipairs(t) do
		if t[k] ~= nil and
			((t[k].symbol == symbol and not notSymbol) or (t[k].symbol ~= symbol and notSymbol)) and
			t[k].index >= minIndex and
			t[k].index <= maxIndex and
			t[k].position >= minPosition and
			t[k].position <= maxPosition then
			return t[k]
		end
	end
	return nil
end

---Finds the next symbol level in the table
---@param t table
---@param symbol string
---@param minIndex number
---@param level number
---@return table|nil
local function FindNextSymbolLevel(t, symbol, minIndex, level)
	if t == nil or symbol == nil or level == nil or level < 0 then
		return nil
	end

	minIndex = minIndex or 0

	local len = #t

	if len > 0 then
		for k, _ in ipairs(t) do
			if t[k] ~= nil and t[k].level ~= nil and t[k].index >= minIndex and t[k].symbol == symbol and t[k].level == level then
				return t[k]
			end
		end
	end
	return nil
end

---Gets the symbols cache for the input string
---@param inputString string
---@return table
local function GetFromSymbolsCache(inputString)
	if TRB.Data.cache.symbols[inputString] == nil then
		TRB.Data.cache.symbols[inputString] = ScanForLogicSymbols(inputString)
	end

	return TRB.Data.cache.symbols[inputString]
end

---Converts the supplied string into a table of text and logic blocks
---@param input string
---@return table
local function CreateBarTextTree(input)
    local inputLength = #input

	local returnText = {
		symbols = GetFromSymbolsCache(input),
		barText = {}
	}

    ---@diagnostic disable-next-line: undefined-field
    if inputLength == 0 then
        return returnText
    end

    local p = 0
    local indexOffset = 0
    local positionOffset = 0
    local lastIndex = indexOffset

    while p <= inputLength do
        local nextOpenIf = FindNextSymbolIndex(returnText.symbols.all, '{', nil, lastIndex)
        if nextOpenIf then
            local matchedCloseIf = FindNextSymbolLevel(returnText.symbols.all, '}', nextOpenIf.index + 1, nextOpenIf.level)

            if nextOpenIf.position - positionOffset > p then
                table.insert(returnText.barText, string.sub(input, p, nextOpenIf.position - positionOffset - 1))
                p = nextOpenIf.position - positionOffset
            end

            if matchedCloseIf and matchedCloseIf.symbol == '}' and matchedCloseIf.level == nextOpenIf.level then -- no weird nesting of if logic, which is unsupported
                local nextOpenResult = FindNextSymbolLevel(returnText.symbols.all, '[', matchedCloseIf.index + 1, nextOpenIf.level)

                if nextOpenResult and nextOpenResult.symbol == '[' and matchedCloseIf.position - positionOffset + 1 == nextOpenResult.position - positionOffset then -- no weird spacing/nesting
                    local nextCloseResult = FindNextSymbolLevel(returnText.symbols.all, ']', nextOpenResult.index, nextOpenResult.level)
                    if nextCloseResult then
                        local hasElse = false
                        local elseOpenResult = FindNextSymbolLevel(returnText.symbols.all, '[', nextCloseResult.index, nextOpenResult.level)
                        local elseCloseResult

                        if elseOpenResult and elseOpenResult.position - positionOffset == nextCloseResult.position - positionOffset + 1 then
                            elseCloseResult = FindNextSymbolLevel(returnText.symbols.all, ']', elseOpenResult.index, nextOpenResult.level)
                            if elseCloseResult then
                                -- We have if/else
                                hasElse = true
                            end
                        end

                        local logicString = string.trim(string.sub(input, nextOpenIf.position - positionOffset + 1, matchedCloseIf.position - positionOffset - 1))

						local trueText = string.sub(input, nextOpenResult.position - positionOffset + 1, nextCloseResult.position - positionOffset - 1)

						local innerReturnText = {
							logic = logicString,
							logicVariables = {},
							processedLogicStrings = {},
							trueResult = CreateBarTextTree(trueText),
							symbols = GetFromSymbolsCache(logicString)
						}
						
						local s = 1
						local lastLogicIndex = 0
						local logicLength = #logicString
						while s <= logicLength do
							local nextVariable = FindNextSymbolIndex(innerReturnText.symbols.all, '$', nil, lastLogicIndex)
							if nextVariable then
								local nextSymbol = FindNextSymbolIndex(innerReturnText.symbols.all, '$', true, nextVariable.index)
								local variableEnd = logicLength
			
								if nextSymbol then
									variableEnd = nextSymbol.position - 1
								end
			
								local var = string.trim(string.gsub(string.sub(innerReturnText.logic, nextVariable.position, variableEnd), " ", ""))
								local beforeVar = string.trim(string.sub(innerReturnText.logic, s, nextVariable.position - 1))
								local prevSymbol = FindNextSymbolIndex(innerReturnText.symbols.all, '$', true, nextVariable.index - 1, nextVariable.index, nil, nil)
								local nextNextSymbol = FindNextSymbolIndex(innerReturnText.symbols.all, '$', true, nextVariable.index + 1, nextVariable.index + 1, nil, nil)
								local pSymbol = "{"
								local nSymbol = "}"
			
								if prevSymbol then
									pSymbol = prevSymbol.symbol
								end
								if nextNextSymbol then
									nSymbol = nextNextSymbol.symbol
								end
			
								table.insert(innerReturnText.logicVariables, {
									variable = var,
									beforeVar = beforeVar,
									beforeVarIsNot = string.sub(beforeVar, #beforeVar) == "!",
									beforeVarIsNotSubString = string.sub(beforeVar, 0, #beforeVar - 1),
									prevSymbol = pSymbol,
									nextSymbol = nSymbol,
									variableEnd = variableEnd
								})

								s = variableEnd + 1
								lastLogicIndex = nextVariable.index + 1
							else
								s = logicLength + 2
							end
						end

						if elseOpenResult and elseCloseResult then
							local falseText = string.sub(input, elseOpenResult.position - positionOffset + 1, elseCloseResult.position - positionOffset - 1)
							innerReturnText.falseResult = CreateBarTextTree(falseText)
						end

						table.insert(returnText.barText, innerReturnText)

                        if elseCloseResult ~= nil and hasElse == true then
                            p = elseCloseResult.position - positionOffset + 1
                            lastIndex = elseCloseResult.index
                        else
                            p = nextCloseResult.position - positionOffset + 1
                            lastIndex = nextCloseResult.index
                        end
					else -- TRUE result block doesn't close, no matching ]
                        table.insert(returnText.barText, string.sub(input, p, nextOpenResult.position - positionOffset))
                        p = nextOpenResult.position - positionOffset + 1
                        lastIndex = nextOpenResult.index
                    end
				else -- Dump all of the previous "if" stuff verbatim
                    table.insert(returnText.barText, string.sub(input, p, matchedCloseIf.position - positionOffset))
                    p = matchedCloseIf.position - positionOffset + 1
                    lastIndex = matchedCloseIf.index
                end
			elseif matchedCloseIf then --nextCloseIf.position+1 is not [
                table.insert(returnText.barText, string.sub(input, p, matchedCloseIf.position - positionOffset))
                p = matchedCloseIf.position - positionOffset + 1
                lastIndex = matchedCloseIf.index
			else -- End of string
                table.insert(returnText.barText, string.sub(input, p, -1))
                p = inputLength + 1
            end
        else
            table.insert(returnText.barText, string.sub(input, p))
            p = inputLength
            break
        end
    end

    return returnText
end

---Gets the bar text tree cache for the input string
---@param input string
---@return table
local function GetFromBarTextTreeCache(input)
	if TRB.Data.cache.barTextTree[input] == nil then
		TRB.Data.cache.barTextTree[input] = CreateBarTextTree(input)
	end

	return TRB.Data.cache.barTextTree[input]
end


---Compiles a conditional expression node into a reusable Lua function.
---The compiled function accepts variable values as positional arguments, eliminating
---the need to rebuild the expression string and call loadstring() every frame.
---@param node table A conditional node from the bar text tree
---@return table compiledExpression { fn, varCount, varInfos } or { invalid = true }
local function CompileConditionalExpression(node)
	local templateParts = {}
	local varInfos = {}
	local varCount = 0
	local s = 1
	local index = 1

	while s <= #node.logic do
		local nextVariable = node.logicVariables[index]
		if nextVariable then
			varCount = varCount + 1
			local paramName = "v" .. varCount

			-- Pre-compute whether this variable occurrence should use lookupLogic values
			-- (numeric context) vs IsValidVariableForSpec (boolean context), based on
			-- the surrounding symbols which are fixed at parse time.
			local useLookupLogic = nextVariable.prevSymbol ~= "!" and
				((nextVariable.prevSymbol ~= "{" and nextVariable.prevSymbol ~= "|" and nextVariable.prevSymbol ~= "&" and nextVariable.prevSymbol ~= "(") or
				 (nextVariable.nextSymbol ~= "}" and nextVariable.nextSymbol ~= "|" and nextVariable.nextSymbol ~= "&" and nextVariable.nextSymbol ~= ")"))

			varInfos[varCount] = {
				variable = nextVariable.variable,
				useLookupLogic = useLookupLogic
			}

			if nextVariable.beforeVarIsNot then
				table.insert(templateParts, " ")
				table.insert(templateParts, nextVariable.beforeVarIsNotSubString)
				table.insert(templateParts, " (not ")
				table.insert(templateParts, paramName)
				table.insert(templateParts, ") ")
			else
				table.insert(templateParts, " ")
				table.insert(templateParts, nextVariable.beforeVar)
				table.insert(templateParts, " ")
				table.insert(templateParts, paramName)
			end

			s = nextVariable.variableEnd + 1
			index = index + 1
		else
			local remainder = string.trim(string.sub(node.logic, s))
			table.insert(templateParts, " ")
			table.insert(templateParts, remainder)
			s = #node.logic + 2
		end
	end

	local templateString = table.concat(templateParts)

	-- Apply operator normalizations
	templateString = string.lower(templateString)
	templateString = string.gsub(templateString, "%(%)", "")
	templateString = string.gsub(templateString, "=", "==")
	templateString = string.gsub(templateString, "!==", "!=")
	templateString = string.gsub(templateString, "~==", "~=")
	templateString = string.gsub(templateString, ">==", ">=")
	templateString = string.gsub(templateString, "<==", "<=")
	templateString = string.gsub(templateString, "===", "==")
	templateString = string.gsub(templateString, "!=", "~=")
	templateString = string.gsub(templateString, "!", " not ")
	templateString = string.gsub(templateString, "&", " and ")
	templateString = string.gsub(templateString, "||", " or ")

	-- Build the compiled function with positional parameters
	local paramList = {}
	for i = 1, varCount do
		paramList[i] = "v" .. i
	end
	local paramString = table.concat(paramList, ",")
	local funcSource = "return function(" .. paramString .. ") return (" .. templateString .. ") end"

	local chunk = loadstring(funcSource)
	if chunk then
		local ok, evalFn = pcall(chunk)
		if ok and type(evalFn) == "function" then
			return {
				fn = evalFn,
				varCount = varCount,
				varInfos = varInfos
			}
		end
	end

	return { invalid = true }
end

---Resolves the current values for a compiled expression's variables
---@param compiledExpr table The compiledExpression table with varInfos
---@return table args Array of resolved values in parameter order
local function ResolveConditionalValues(compiledExpr)
	-- Reuse the args table stored on compiledExpr to avoid per-tick allocation
	local args = compiledExpr.args
	if args == nil then
		args = {}
		compiledExpr.args = args
	end
	for i = 1, compiledExpr.varCount do
		local info = compiledExpr.varInfos[i]
		local val = TRB.Functions.Class:IsValidVariableForSpec(info.variable)
		if info.useLookupLogic and TRB.Data.lookupLogic[info.variable] then
			val = TRB.Data.lookupLogic[info.variable]
			if issecretvalue(val) then
				val = false
			end
		end
		args[i] = val
	end
	return args
end

-- Reusable buffer stack for RemoveInvalidVariablesFromBarText to avoid per-call table allocation.
-- Stack depth handles recursive calls (conditional true/false branches).
local rivBufferStack = {}
local rivBufferDepth = 0

---Removes invalid variables from the bar text represented within the tree.
---Conditional expressions are compiled to reusable Lua functions on first evaluation,
---then re-evaluated each frame by passing current values as arguments — avoiding
---per-frame string building, operator normalization, and loadstring() compilation.
---@param tree table
---@return string
local function RemoveInvalidVariablesFromBarText(tree)
	if tree == nil or tree.barText == nil then
		return ""
	end

	local barText = tree.barText
	local barTextLen = #barText

	-- Fast path: single-element tree with a plain string (very common for true/false branches)
	if barTextLen == 1 and type(barText[1]) == "string" then
		return barText[1]
	end

	-- Acquire a buffer from the stack (or create one)
	rivBufferDepth = rivBufferDepth + 1
	local returnText = rivBufferStack[rivBufferDepth]
	if returnText == nil then
		returnText = {}
		rivBufferStack[rivBufferDepth] = returnText
	end
	local rtLen = 0

	for idx = 1, barTextLen do
		local v = barText[idx]
		if type(v) == "string" then
			rtLen = rtLen + 1
			returnText[rtLen] = v
		else
			-- Compile the expression template on first evaluation of this node
			if v.compiledExpression == nil then
				v.compiledExpression = CompileConditionalExpression(v)
			end

			local processResult
			local ce = v.compiledExpression

			if ce.invalid then
				processResult = "INVALID"
			else
				local args = ResolveConditionalValues(ce)
				local ok, result = pcall(ce.fn, unpack(args, 1, ce.varCount))
				if not ok then
					processResult = "INVALID"
				elseif result == true or result then
					processResult = "TRUE"
				elseif v.falseResult then
					processResult = "FALSE"
				else
					processResult = "NONE"
				end
			end

			if processResult == "INVALID" then-- Something went wrong, show the error text instead
				rtLen = rtLen + 1
				returnText[rtLen] = L["BarTextInvalidIfElseLogic"]
			elseif processResult == "TRUE" then
				rtLen = rtLen + 1
				returnText[rtLen] = RemoveInvalidVariablesFromBarText(v.trueResult)
			elseif processResult == "FALSE" then
				rtLen = rtLen + 1
				returnText[rtLen] = RemoveInvalidVariablesFromBarText(v.falseResult)
			end
		end
	end

	-- Clear trailing stale entries and release buffer back to stack
	for i = rtLen + 1, #returnText do
		returnText[i] = nil
	end
	local result = table.concat(returnText, "", 1, rtLen)
	rivBufferDepth = rivBufferDepth - 1
    return result
end

---Adds the input to the bar text cache
---@param input string
---@return table
local function AddToBarTextCache(input)
	local barTextVariables = TRB.Data.barTextVariables
	local iconEntries = #barTextVariables.icons
	local valueEntries = #barTextVariables.values
	local pipeEntries = #barTextVariables.pipe
	local percentEntries = #barTextVariables.percent
	local returnText = ""
	local returnVariables = {}
	local p = 0
	local infinity = 0
	local barTextValuesVars = barTextVariables.values
	table.sort(barTextValuesVars,
		function(a, b)
			return string.len(a.variable) > string.len(b.variable)
		end)
	local barTextIconsVars = barTextVariables.icons
	table.sort(barTextIconsVars,
		function(a, b)
			return string.len(a.variable) > string.len(b.variable)
		end)
	
	--Only loop through this while we're not at the end of the string AND we haven't done 1000 checks. This is a sanity checker to prevent an infinite run for some reason!
	while p <= string.len(input) and infinity < 1000 do
		infinity = infinity + 1
		local a, b, c, d, z, z1
		local match = false
		a, _ = string.find(input, "#", p)
		b, _ = string.find(input, "%$", p)
		c, _ = string.find(input, "|", p)
		d, _ = string.find(input, "%%", p)
		if a ~= nil and (b == nil or a < b) and (c == nil or a < c) and (d == nil or a < d) then
			if string.sub(input, a+1, a+6) == "spell_" then
				z, z1 = string.find(input, "_", a+7)
				if z ~= nil then
					local iconName = string.sub(input, a, z)
					local spellId = string.sub(input, a+7, z-1)
					local spellInfo = C_Spell.GetSpellInfo(spellId) --[[@as SpellInfo]]

					if spellInfo.iconID ~= nil then
						match = true
						if p ~= a then
							returnText = returnText .. string.sub(input, p, a-1)
						end

						returnText = returnText .. "%s"
						TRB.Data.lookup[iconName] = string.format("|T%s:0|t", spellInfo.iconID)
						table.insert(returnVariables, iconName)
						p = z1 + 1
					end
				end
			elseif string.sub(input, a+1, a+5) == "item_" then
				z, z1 = string.find(input, "_", a+6)
				if z ~= nil then
					local iconName = string.sub(input, a, z)
					local itemId = string.sub(input, a+6, z-1)
					local _, icon
					_, _, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(itemId)

					if icon ~= nil then
						match = true
						if p ~= a then
							returnText = returnText .. string.sub(input, p, a-1)
						end

						returnText = returnText .. "%s"
						TRB.Data.lookup[iconName] = string.format("|T%s:0|t", icon)
						table.insert(returnVariables, iconName)
						p = z1 + 1
					end
				end
			else
				for x = 1, iconEntries do
					z, z1 = string.find(input, barTextIconsVars[x].variable, a-1)
					if z ~= nil and z == a then
						match = true
						if p ~= a then
							returnText = returnText .. string.sub(input, p, a-1)
						end

						returnText = returnText .. "%s"
						table.insert(returnVariables, barTextIconsVars[x].variable)

						p = z1 + 1
						break
					end
				end
			end
		elseif b ~= nil and (c == nil or b < c) and (d == nil or b < d) then
			for x = 1, valueEntries do
				z, z1 = string.find(input, barTextValuesVars[x].variable, b-1)
				if z ~= nil and z == b then
					match = true
					if p ~= b then
						returnText = returnText .. string.sub(input, p, b-1)
					end

					returnText = returnText .. "%s"
					table.insert(returnVariables, barTextValuesVars[x].variable)

					if barTextValuesVars[x].color == true then
						returnText = returnText .. "%s"
						table.insert(returnVariables, "color")
					end

					p = z1 + 1
					break
				end
			end
		elseif c ~= nil and (d == nil or c < d) then
			for x = 1, pipeEntries do
				z, z1 = string.find(input, barTextVariables.pipe[x].variable, c-1)
				if z ~= nil and z == c then
					match = true

					if p == 0 then --Prevent weird newline issues
						returnText = " "
					end

					if p ~= c then
						returnText = returnText .. string.sub(input, p, c-1)
					end

					returnText = returnText .. "%s"
					table.insert(returnVariables, barTextVariables.pipe[x].variable)
					p = z1 + 1
				end
			end
		elseif d ~= nil then
			for x = 1, percentEntries do
				z, z1 = string.find(input, barTextVariables.percent[x].variable, d-1)
				if z ~= nil and z == d then
					match = true
					if p ~= d then
						returnText = returnText .. string.sub(input, p, d-1)
					end

					returnText = returnText .. "%s"
					table.insert(returnVariables, barTextVariables.percent[x].variable)

					p = z1 + 1
					break
				end
			end
		else
			returnText = returnText .. string.sub(input, p, -1)
			p = string.len(input) + 1
			match = true
		end

		if match == false then
			returnText = returnText .. string.sub(input, p, p)
			p = p + 1
		end
	end

	local barTextCacheEntry = {}
	barTextCacheEntry.cleanedText = input
	barTextCacheEntry.stringFormat = returnText
	barTextCacheEntry.variables = returnVariables

	table.insert(TRB.Data.cache.barText, barTextCacheEntry)
	return barTextCacheEntry
end

---Gets the bar text cache for the input string
---@param barText string
---@return table
local function GetFromBarTextCache(barText)
	local cached = barTextCacheHash[barText]
	if cached then
		return cached
	end

	local result = AddToBarTextCache(barText)
	barTextCacheHash[barText] = result
	return result
end

-- Reusable buffer for GetReturnText to avoid allocating a new table every call
local mappingBuffer = {}

---Gets the return text after processing the input text
---@param inputText table
---@return string
local function GetReturnText(inputText)
	local lookup = TRB.Data.lookup
	lookup["color"] = inputText.color
	inputText.text = RemoveInvalidVariablesFromBarText(GetFromBarTextTreeCache(inputText.text))

	local cache = GetFromBarTextCache(inputText.text)
	local cachedTextVariableLength = #cache.variables

	-- Reuse the shared mapping buffer; clear previous entries
	local mapping = mappingBuffer
	local mappingLen = 0

	if cachedTextVariableLength > 0 then
		for y = 1, cachedTextVariableLength do
			mappingLen = mappingLen + 1
			mapping[mappingLen] = lookup[cache.variables[y]]
		end
	end

	-- Nil out any stale entries beyond current length
	for i = mappingLen + 1, #mapping do
		mapping[i] = nil
	end

	if mappingLen > 0 then
		_, inputText.text = pcall(string.format, cache.stringFormat, unpack(mapping, 1, mappingLen))
	elseif string.len(cache.stringFormat) > 0 then
		inputText.text = cache.stringFormat
	else
		inputText.text = ""
	end

	return inputText.color .. inputText.text
end

---Checks if any primary stat ratings are nil
---@return boolean
local function ArePrimaryRatingsNil()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	if snapshotData.attributes.primaryRefresh ~= false or snapshotData.attributes.strength == nil or snapshotData.attributes.strength == nil or snapshotData.attributes.agility == nil or snapshotData.attributes.stamina == nil or snapshotData.attributes.intellect == nil then
		return true
	end
	return false
end

---Checks if any secondary stat ratings are nil
---@return boolean
local function AreSecondaryRatingsNil()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	if snapshotData.attributes.secondaryRefresh ~= false or snapshotData.attributes.critRating == nil or snapshotData.attributes.masteryRating == nil or snapshotData.attributes.hasteRating == nil or snapshotData.attributes.versatilityOffensive == nil or snapshotData.attributes.versatilityDefensive == nil or snapshotData.attributes.versatilityRating == nil then
		return true
	end
	return false
end

---Refreshes the baseline lookup data with the current values.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
function TRB.Functions.BarText:RefreshLookupDataBase(settings)
	--Spec specific implementations also needed. This is general/cross-spec data
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	
	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}

	TRB.Data.prevLookupState = TRB.Data.prevLookupState or {}
	local prevState = TRB.Data.prevLookupState
	local lookupChanged = TRB.Functions.BarText.LookupChanged

	-- Ensure stats are populated if this is the first call
	if ArePrimaryRatingsNil() then
		TRB.Functions.Character:UpdatePrimaryStatsSnapshot()
	end
	if AreSecondaryRatingsNil() then
		TRB.Functions.Character:UpdateSecondaryStatsSnapshot()
	end

	-- Primary stat display strings – pre-formatted at event time in UpdatePrimaryStatsSnapshot
	local formatted = snapshotData.formatted
	local fmtInt  = formatted.int  or ""
	local fmtStr  = formatted.str  or ""
	local fmtAgi  = formatted.agi  or ""
	local fmtStam = formatted.stam or ""

	lookup["$int"]       = fmtInt
	lookup["$intellect"] = fmtInt
	lookup["$str"]       = fmtStr
	lookup["$strength"]  = fmtStr
	lookup["$agi"]       = fmtAgi
	lookup["$agility"]   = fmtAgi
	lookup["$stam"]      = fmtStam
	lookup["$stamina"]   = fmtStam

	lookupLogic["$int"]       = snapshotData.attributes.intellect
	lookupLogic["$intellect"] = snapshotData.attributes.intellect
	lookupLogic["$str"]       = snapshotData.attributes.strength
	lookupLogic["$strength"]  = snapshotData.attributes.strength
	lookupLogic["$agi"]       = snapshotData.attributes.agility
	lookupLogic["$agility"]   = snapshotData.attributes.agility
	lookupLogic["$stam"]      = snapshotData.attributes.stamina
	lookupLogic["$stamina"]   = snapshotData.attributes.stamina

	--$health, $healthMax, $healthPercent
	-- Raw secret values for lookupLogic (conditionals use arithmetic, not equality)
	lookupLogic["$health"] = snapshotData.attributes.health
	lookupLogic["$healthMax"] = snapshotData.attributes.healthMax
	lookupLogic["$healthPercent"] = snapshotData.attributes.healthPercent

	-- Use pre-formatted strings from event time (see UpdateHealthValues)
	local formatted = snapshotData.formatted
	lookup["$health"] = formatted.health or ""
	lookup["$healthMax"] = formatted.healthMax or ""
	lookup["$healthPercent"] = formatted.healthPercent or ""

	--$absorb
	lookupLogic["$absorb"] = snapshotData.attributes.absorb
	lookup["$absorb"] = formatted.absorb or ""

	--$incomingHeal
	lookupLogic["$incomingHeal"] = snapshotData.attributes.incomingHeal or 0
	lookup["$incomingHeal"] = formatted.incomingHeal or ""

	--$healAbsorb
	lookupLogic["$healAbsorb"] = snapshotData.attributes.healAbsorb
	lookup["$healAbsorb"] = formatted.healAbsorb or ""

	-- Secondary stat display strings – pre-formatted at event time in UpdateSecondaryStatsSnapshot
	local fmtHaste      = formatted.haste      or ""
	local fmtCrit       = formatted.crit       or ""
	local fmtMastery    = formatted.mastery    or ""
	local fmtVersOff    = formatted.versOff    or ""
	local fmtVersDef    = formatted.versDef    or ""
	local fmtHasteRat   = formatted.hasteRating  or ""
	local fmtCritRat    = formatted.critRating   or ""
	local fmtMasteryRat = formatted.masteryRating or ""
	local fmtVersRat    = formatted.versRating    or ""
	local fmtGcd        = formatted.gcd        or ""

	lookup["$haste"]              = fmtHaste
	lookup["$hastePercent"]       = fmtHaste
	lookup["$crit"]               = fmtCrit
	lookup["$critPercent"]        = fmtCrit
	lookup["$mastery"]            = fmtMastery
	lookup["$masteryPercent"]     = fmtMastery
	lookup["$vers"]               = fmtVersOff
	lookup["$versPercent"]        = fmtVersOff
	lookup["$versatility"]        = fmtVersOff
	lookup["$versatilityPercent"] = fmtVersOff
	lookup["$oVers"]              = fmtVersOff
	lookup["$oVersPercent"]       = fmtVersOff
	lookup["$dVers"]              = fmtVersDef
	lookup["$dVersPercent"]       = fmtVersDef

	lookup["$hasteRating"]        = fmtHasteRat
	lookup["$critRating"]         = fmtCritRat
	lookup["$masteryRating"]      = fmtMasteryRat
	lookup["$versRating"]         = fmtVersRat
	lookup["$versatilityRating"]  = fmtVersRat

	lookup["$gcd"] = fmtGcd

	lookupLogic["$haste"]              = snapshotData.attributes.haste
	lookupLogic["$hastePercent"]       = snapshotData.attributes.haste
	lookupLogic["$crit"]               = snapshotData.attributes.crit
	lookupLogic["$critPercent"]        = snapshotData.attributes.crit
	lookupLogic["$mastery"]            = snapshotData.attributes.mastery
	lookupLogic["$masteryPercent"]     = snapshotData.attributes.mastery
	lookupLogic["$vers"]               = snapshotData.attributes.versatilityOffensive
	lookupLogic["$versPercent"]        = snapshotData.attributes.versatilityOffensive
	lookupLogic["$versatility"]        = snapshotData.attributes.versatilityOffensive
	lookupLogic["$versatilityPercent"] = snapshotData.attributes.versatilityOffensive
	lookupLogic["$oVers"]              = snapshotData.attributes.versatilityOffensive
	lookupLogic["$oVersPercent"]       = snapshotData.attributes.versatilityOffensive
	lookupLogic["$dVers"]              = snapshotData.attributes.versatilityDefensive
	lookupLogic["$dVersPercent"]       = snapshotData.attributes.versatilityDefensive

	lookupLogic["$hasteRating"]        = snapshotData.attributes.hasteRating
	lookupLogic["$critRating"]         = snapshotData.attributes.critRating
	lookupLogic["$masteryRating"]      = snapshotData.attributes.masteryRating
	lookupLogic["$versRating"]         = snapshotData.attributes.versatilityRating
	lookupLogic["$versatilityRating"]  = snapshotData.attributes.versatilityRating

	lookupLogic["$gcd"] = formatted.gcdRaw or 0

	if lookup["||n"] == nil then
		lookup["||n"] = "\n"
		lookup["||c"] = "|c"
		lookup["||r"] = "|r"
		lookup["%%"] = "%"
	end

	--$inCombatTime
	local _inCombatTime = 0
	if TRB.Data.character.inCombat and TRB.Data.character.combatStartTime ~= nil then
		_inCombatTime = GetTime() - TRB.Data.character.combatStartTime
	end
	lookupLogic["$inCombatTime"] = _inCombatTime
	-- Floor to seconds so we only reformat once per second instead of every tick
	local _inCombatTimeSeconds = math.floor(_inCombatTime)
	if lookupChanged(prevState, "$inCombatTime", _inCombatTimeSeconds) then
		if _inCombatTime > 0 then
			local minutes = math.floor(_inCombatTime / 60)
			local seconds = _inCombatTimeSeconds - (minutes * 60)
			lookup["$inCombatTime"] = string.format("%02d:%02d", minutes, seconds)
		else
			lookup["$inCombatTime"] = "00:00"
		end
	end
	--#castingIcon
	local castingIcon = snapshotData.casting.icon or ""
	local castingAmount = snapshotData.casting.resourceFinal or 0

	lookup["$inCombat"] = tostring(TRB.Data.character.inCombat)
	lookup["#casting"] = castingIcon

	lookupLogic["$inCombat"] = tostring(TRB.Data.character.inCombat)

	Global_TwintopResourceBar = Global_TwintopResourceBar or {}

	Global_TwintopResourceBar.resource = Global_TwintopResourceBar.resource or {}
	Global_TwintopResourceBar.resource.resource = snapshotData.attributes.resource-- or 0
	Global_TwintopResourceBar.resource.casting = castingAmount
end

-- Static set of always-valid base variables (O(1) lookup instead of if/elseif chain)
local validBaseVars = {
	["$crit"] = true, ["$critPercent"] = true,
	["$mastery"] = true, ["$masteryPercent"] = true,
	["$haste"] = true, ["$hastePercent"] = true,
	["$gcd"] = true,
	["$vers"] = true, ["$versatility"] = true, ["$oVers"] = true, ["$versPercent"] = true, ["$versatilityPercent"] = true, ["$oVersPercent"] = true,
	["$dVers"] = true, ["$dversPercent"] = true,
	["$critRating"] = true, ["$masteryRating"] = true, ["$hasteRating"] = true,
	["$versRating"] = true, ["$versatilityRating"] = true,
	["$dVersRating"] = true,
	["$int"] = true, ["$intellect"] = true,
	["$agi"] = true, ["$agility"] = true,
	["$str"] = true, ["$strength"] = true,
	["$stam"] = true, ["$stamina"] = true,
}

---Flags many variables, for baseline stats and stat percentages, as valid for bar text logic
---@param var string
---@return boolean
function TRB.Functions.BarText:IsValidVariableBase(var)
	if validBaseVars[var] then
		return true
	end
	if var == "$inCombat" or var == "$inCombatTime" then
		return TRB.Data.character.inCombat == true
	end
	return false
end

-- Reused per-call cache for GetBarTextFrame results (avoids redundant frame lookups)
local showFrameCache = {}

-- Reusable table for passing to GetReturnText (avoids per-entry table allocation)
local barTextBuffer = { text = "", color = "" }

-- Pre-computed "textFrames"..i key strings (populated on demand, avoids per-frame string concat)
local textFrameKeys = {}
---Returns the cached "textFrames"..i key string for a given bar text entry index, creating it on first access to avoid per-frame string concatenation
---@param i integer The 1-based bar text entry index
---@return string key The cached key string (e.g. "textFrames1")
local function GetTextFrameKey(i)
	local key = textFrameKeys[i]
	if key == nil then
		key = "textFrames" .. i
		textFrameKeys[i] = key
	end
	return key
end

---Updates the resource bar text based on the settings
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param refreshText boolean
function TRB.Functions.BarText:UpdateResourceBarText(settings, refreshText)
	-- Consume the visibility-refresh flag set by ProcessBars on hidden→visible
	-- transition. When true, we must bypass the early-out AND force all bar text
	-- entries to be processed, ensuring text content is written to frames that
	-- were just made visible (they may have empty/stale text from when the bar
	-- was hidden).
	local visibilityRefresh = TRB.Data.barTextVisibilityRefreshNeeded
	if visibilityRefresh then
		TRB.Data.barTextVisibilityRefreshNeeded = false
	end

	-- Early-out: if nothing changed since the last refresh and no timers are
	-- ticking down, all lookup values are identical to last tick — skip the refresh and
	-- bar text rendering entirely. During combat $inCombatTime keeps changing, so we
	-- always refresh when in combat. A pending visibility refresh also bypasses this.
	if not visibilityRefresh and not TRB.Data.lookupDirty and not TRB.Data.character.inCombat and not TRB.Functions.Class:HasActiveTimers() then
		return
	end
	TRB.Data.lookupDirty = false

	-- Rebuild the active variable set if it was invalidated (bar text changed, spec switch, etc.)
	if TRB.Data.activeVariables == nil then
		TRB.Functions.BarText:BuildActiveVariableSet(settings)
	end

	--Always refresh the lookup data as this also updates the global variable used by other addons/WAs
	TRB.Functions.BarText:RefreshLookupDataBase(settings)
	TRB.Functions.RefreshLookupData()
	
	--Only parse bar text if we need to refresh the text (or if there are Screen-bound entries)
	if settings ~= nil and settings.displayText ~= nil then
		-- Clear the per-call frame cache so entries get fresh visibility data
		for k in pairs(showFrameCache) do showFrameCache[k] = nil end

		---@type Frame[]
		local textFrames = TRB.Frames.textFrames
		local displayText = settings.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		local entries = #displayText.barText
		-- Ensure frames exist before trying to update them.
		-- This used to be guaranteed by the legacy bar constructor; the OOP bar system must do this too.
		if textFrames == nil or textFrames[1] == nil then
			TRB.Functions.BarText:CreateBarTextFrames()
			textFrames = TRB.Frames.textFrames
		end
		for i = 1, entries do
			if displayText.barText[i].enabled then
				local e = displayText.barText[i]
				local isScreenText = e.position.relativeToFrame == "UIParent"
				
				-- Screen-bound text is always processed; other text only when refreshText is true.
				-- visibilityRefresh forces processing for all entries after a hidden→visible transition.
				if refreshText or isScreenText or visibilityRefresh then
					-- Check if the target frame is visible before doing expensive text processing
					-- Use per-call cache to avoid redundant GetBarTextFrame calls for entries sharing a frame
					local frameKey = e.position.relativeToFrame
					local isEnabled, isVisible
					local cached = showFrameCache[frameKey]
					if cached then
						isEnabled = cached[1]
						isVisible = cached[2]
					else
						_, isEnabled, isVisible = TRB.Functions.BarText:GetAnchorFrame(frameKey)
						if isScreenText then
							isVisible = true
						end
						showFrameCache[frameKey] = { isEnabled, isVisible }
					end
					
					local tfKey = GetTextFrameKey(i)
					local frameCache = TRB.Data.cache.values.frame[tfKey]
					if frameCache == nil then
						frameCache = {}
						TRB.Data.cache.values.frame[tfKey] = frameCache
					end
					
					-- Skip expensive text processing if the target bar is not visible
					if not isEnabled or not isVisible then
						frameCache.text = ""
					else
						local color = e.color and e.color.color
						
						if e.useDefaultFontColor then
							-- displayText.default.color uses the new table format { color = "..." }
							local defaultColor = displayText.default and displayText.default.color
							if type(defaultColor) == "table" then
								color = defaultColor.color
							elseif type(defaultColor) == "string" then
								color = defaultColor
							end
						end

						color = color or "FFFFFFFF"

						barTextBuffer.text = e.text
						barTextBuffer.color = "|c" .. color

						local returnText = GetReturnText(barTextBuffer)

						if textFrames ~= nil and textFrames[i] ~= nil then
							pcall(TryUpdateText, textFrames[i],  returnText)
						else
							-- Frame list is out of sync; rebuild and try once.
							TRB.Functions.BarText:CreateBarTextFrames()
							textFrames = TRB.Frames.textFrames
							if textFrames ~= nil and textFrames[i] ~= nil then
								pcall(TryUpdateText, textFrames[i],  returnText)
							end
						end
						frameCache.text = returnText
					end
					
					if frameCache.level ~= TRB.Data.settings.core.strata.level then
						if textFrames ~= nil and textFrames[i] ~= nil then
							textFrames[i]:SetFrameLevel(TRB.Data.constants.frameLevels.barText)
							textFrames[i]:SetFrameStrata(TRB.Data.settings.core.strata.level)
						end
						frameCache.level = TRB.Data.settings.core.strata.level
					end
				end
			end
		end
	end

	if TRB.Functions.Threshold and TRB.Functions.Threshold.UpdateCustomThresholdLines then
		TRB.Functions.Threshold:UpdateCustomThresholdLines(settings, TRB.Frames.barGroups)
	end
end

---Repositions an existing bar text frame without rebuilding all bar text frames.
---@param entryIndex integer
---@param classId integer?
---@param specId integer?
---@return boolean
function TRB.Functions.BarText:RepositionBarTextEntry(entryIndex, classId, specId)
	classId = classId or TRB.Data.character.classId
	specId = specId or TRB.Data.character.specId

	if classId ~= TRB.Data.character.classId or specId ~= TRB.Data.character.specId then
		return false
	end

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local compositeKey = TRB.Functions.Character:GetCompositeKey(className, specName)
	local settings = TRB.Data.specCache[compositeKey] and TRB.Data.specCache[compositeKey].settings
	local displayText = settings and settings.displayText
	local textFrames = TRB.Frames.textFrames
	local entry = displayText and displayText.barText and displayText.barText[entryIndex]

	if entry == nil or textFrames == nil or textFrames[entryIndex] == nil then
		return false
	end

	---@diagnostic disable-next-line: undefined-field
	local font = textFrames[entryIndex].font
	if font == nil then
		return false
	end

	local relativeToFrame
	local isEnabled = true
	if entry.position.relativeToFrame == "UIParent" then
		relativeToFrame = UIParent
	elseif entry.position.relativeToFrame ~= "AllComboPoints" then
		relativeToFrame, isEnabled, _ = TRB.Functions.BarText:GetAnchorFrame(entry.position.relativeToFrame, classId, specId)
		if relativeToFrame == nil and isEnabled then
			relativeToFrame = _G["TwintopResourceBarFrame_" .. entry.position.relativeToFrame]
		end
	end

	textFrames[entryIndex]:SetFrameLevel(TRB.Data.constants.frameLevels.barText)
	textFrames[entryIndex]:SetFrameStrata(TRB.Data.settings.core.strata.level)

	if relativeToFrame ~= nil and entry.enabled and isEnabled then
		font:ClearAllPoints()
		font:SetPoint(entry.position.relativeTo, relativeToFrame, entry.position.relativeTo, entry.position.xPos, entry.position.yPos)
		textFrames[entryIndex]:SetParent(relativeToFrame)
		textFrames[entryIndex]:ClearAllPoints()
		textFrames[entryIndex]:SetAllPoints(font)

		if TRB.Functions.Bar:IsRenderTransitionActive() then
			font:Hide()
			textFrames[entryIndex]:Hide()
		else
			font:Show()
			textFrames[entryIndex]:Show()
		end
	else
		textFrames[entryIndex]:Hide()
		font:Hide()
	end

	return true
end

---Builds the required bar text frames
---@param classId integer?
---@param specId integer?
function TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	classId = classId or TRB.Data.character.classId
	specId = specId or TRB.Data.character.specId

	-- Don't do this if we're not modifying the current spec's bar text
	if classId ~= TRB.Data.character.classId or specId ~= TRB.Data.character.specId then
		return
	end
	
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local compositeKey = TRB.Functions.Character:GetCompositeKey(className, specName)
	local settings = TRB.Data.specCache[compositeKey].settings

	---@type Frame[]
	local textFrames = TRB.Frames.textFrames
	local displayText = settings.displayText --[[@as TRB.Classes.Settings.DisplayText]]
	
	local entries = #displayText.barText
	local frameCount = 1
	if entries > 0 then
		if displayText.default.fontFace == nil or displayText.default.fontFace == "" or displayText.default.fontFaceName == nil or displayText.default.fontFaceName == "" then
			displayText.default.fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace
			displayText.default.fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName
		end

		for i = 1, entries do
			local e = displayText.barText[i]

			if e.fontFace == nil or e.fontFace == "" or e.fontFaceName == nil or e.fontFaceName == "" then
				e.fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace
				e.fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName
			end

			local fontFace = e.fontFace
			local fontSize = e.fontSize
			local fontJustifyHorizontal = e.fontJustifyHorizontal

			if e.useDefaultFontFace then
				fontFace = displayText.default.fontFace
			end

			if e.useDefaultFontSize then
				fontSize = displayText.default.fontSize
			end

			local fontOutline = e.fontOutline or "OUTLINE"
			if e.useDefaultFontOutline then
				fontOutline = displayText.default.fontOutline or "OUTLINE"
			end

			local fontShadow = e.fontShadow
			if e.useDefaultFontShadow and displayText.default.fontShadow then
				-- Inherit only appearance (color, offsets) from spec defaults; enabled stays per-entry
				fontShadow = fontShadow or {}
				fontShadow = {
					enabled = fontShadow.enabled,
					color = displayText.default.fontShadow.color,
					xOffset = displayText.default.fontShadow.xOffset,
					yOffset = displayText.default.fontShadow.yOffset,
				}
			end

			local relativeTo = e.position.relativeTo
			---@type Frame
			local relativeToFrame
			local isEnabled = true
			
			if e.position.relativeToFrame == "UIParent" then
				relativeToFrame = UIParent
			elseif e.position.relativeToFrame == "AllComboPoints" then
			else
				-- Capture isVisible but don't use it for frame creation - parenting needs the frame regardless
				relativeToFrame, isEnabled, _ = TRB.Functions.BarText:GetAnchorFrame(e.position.relativeToFrame, classId, specId)

				if relativeToFrame == nil and isEnabled then
					relativeToFrame = _G["TwintopResourceBarFrame_"..e.position.relativeToFrame]
				end
			end
			
			if textFrames[frameCount] == nil then
				textFrames[frameCount] = CreateFrame("Frame", "TwintopResourceBarFrame_TextFrame"..frameCount, relativeToFrame)
			end

			textFrames[frameCount]:SetFrameLevel(TRB.Data.constants.frameLevels.barText)
			textFrames[frameCount]:SetFrameStrata(TRB.Data.settings.core.strata.level)

---@diagnostic disable-next-line: undefined-field
			if textFrames[frameCount].font == nil then
				---@diagnostic disable-next-line: inject-field
				textFrames[frameCount].font = TRB.Frames.textFrames[frameCount]:CreateFontString(nil, "BACKGROUND")
			end
---@diagnostic disable-next-line: undefined-field
			local font = textFrames[frameCount].font

			if relativeToFrame ~= nil and e.enabled and isEnabled then
				font:SetTextColor(255/255, 255/255, 255/255, 1.0)
				font:SetJustifyH(fontJustifyHorizontal)
				font:SetFont(fontFace, fontSize, fontOutline)

				-- Apply font shadow settings
				if fontShadow and fontShadow.enabled then
					local sr, sg, sb, sa = TRB.Functions.Color:GetRGBAFromString(fontShadow.color or "FF000000", true)
					font:SetShadowColor(sr, sg, sb, sa)
					font:SetShadowOffset(fontShadow.xOffset or 1, fontShadow.yOffset or -1)
				else
					font:SetShadowColor(0, 0, 0, 0)
					font:SetShadowOffset(0, 0)
				end

				-- Clear any stale text from a previous configuration so old bar text
				-- doesn't linger after a reset or entry change.
				font:SetText("")
				font:ClearAllPoints()
				font:SetPoint(relativeTo, relativeToFrame, relativeTo, e.position.xPos, e.position.yPos)
				textFrames[frameCount]:SetParent(relativeToFrame)
				textFrames[frameCount]:ClearAllPoints()
				textFrames[frameCount]:SetAllPoints(font)

				if TRB.Functions.Bar:IsRenderTransitionActive() then
					font:Hide()
					textFrames[frameCount]:Hide()
				else
					font:Show()
					textFrames[frameCount]:Show()
				end
			else
				-- Clear stale text on disabled/hidden frames too
				if font.SetText and font.GetFont and font:GetFont() then
					font:SetText("")
				end
				textFrames[frameCount]:Hide()
				font:Hide()
			end
			frameCount = frameCount + 1
		end
	end
	
	local textFramesEntries = #textFrames
	-- We have extra frames we don't need now, probably because we changed talents/specs/deleted one in config. Hide extras.
	if textFramesEntries >= frameCount then
		for i = frameCount, textFramesEntries do
			textFrames[i]:Hide()
			---@diagnostic disable-next-line: undefined-field
			local extraFont = textFrames[i].font
			if extraFont and extraFont.GetFont and extraFont:GetFont() then
				extraFont:SetText("")
			end
			extraFont:Hide()
		end
	end

	-- All font strings were just cleared to ""; mark lookup dirty so the next tick
	-- repaints instead of early-outing (otherwise text stays blank out of combat).
	TRB.Data.lookupDirty = true
end

---Returns a string formatted time value based on settings for precision
---@param value number # Timer value to format
---@param positiveOnly boolean? # Should the timer only ever show a positive number?
---@return string # String formatted value with correct precision based on thresholds
function TRB.Functions.BarText:TimerPrecision(value, positiveOnly)
	if positiveOnly == nil then
		positiveOnly = true
	end

	if issecretvalue(value) then
		-- Secret values cannot be compared, but `string.format` is allowed on them
		-- per the Secret Values rules and produces a secret string that still flows
		-- through `FontString:SetText` for display. Skip the sign and threshold
		-- checks (which would crash) and always render with low precision.
		return string.format("%."..TRB.Data.settings.core.timers.precisionLow.."f", value)
	end

	if positiveOnly and value < 0 then
		value = 0
	end

	if value >= TRB.Data.settings.core.timers.precisionThreshold then
		return string.format("%."..TRB.Data.settings.core.timers.precisionHigh.."f", value)
	else
		return string.format("%."..TRB.Data.settings.core.timers.precisionLow.."f", value)
	end
end

---Hides all bar text, except UIParent-bound ("Screen") entries which remain visible
---at full opacity, independent of bar state.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
function TRB.Functions.BarText:Hide(settings)
	local textFrames = TRB.Frames.textFrames
	if settings ~= nil and settings.displayText ~= nil then
		local barText = settings.displayText.barText
		local entries = barText and #barText or 0
		for i = 1, #textFrames do
			-- UIParent-attached bar text stays visible even when bars are hidden
			if i <= entries and barText[i] ~= nil
				and barText[i].enabled
				and barText[i].position.relativeToFrame == "UIParent"
				and not TRB.Functions.Bar:IsRenderTransitionActive() then
				textFrames[i]:Show()
				---@diagnostic disable-next-line: undefined-field
				textFrames[i].font:Show()
				-- Screen-bound text is independent of the bar; always fully opaque
				textFrames[i]:SetAlpha(1.0)
			else
				textFrames[i]:Hide()
				---@diagnostic disable-next-line: undefined-field
				textFrames[i].font:Hide()
			end
		end
	else
		for i = 1, #textFrames do
			textFrames[i]:Hide()
			---@diagnostic disable-next-line: undefined-field
			textFrames[i].font:Hide()
		end
	end
end

---Shows all enabled bar text
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
function TRB.Functions.BarText:Show(settings)
	local displayText = settings.displayText --[[@as TRB.Classes.Settings.DisplayText]]
	---@type Frame[]
	local textFrames = TRB.Frames.textFrames
	local entries = #displayText.barText
	if entries > 0 then
		-- Per-call cache: entries sharing the same relativeToFrame skip redundant GetBarTextFrame calls
		local fCache = showFrameCache
		for k in pairs(fCache) do fCache[k] = nil end

		local anyBecameVisible = false
		local isTransition = TRB.Functions.Bar:IsRenderTransitionActive()
		for i = 1, entries do
			local e = displayText.barText[i]
			local key = e.position.relativeToFrame
			local isEnabled, isVisible
			local cached = fCache[key]
			if cached then
				isEnabled = cached[1]
				isVisible = cached[2]
			else
				_, isEnabled, isVisible = TRB.Functions.BarText:GetAnchorFrame(key)
				if key == "UIParent" then
					isVisible = true
				end
				fCache[key] = { isEnabled, isVisible }
			end

			if e.enabled and isEnabled and isVisible and textFrames[i] ~= nil then
				if isTransition then
					textFrames[i]:Hide()
					---@diagnostic disable-next-line: undefined-field
					textFrames[i].font:Hide()
				else
					-- Detect bar text frame transitioning from hidden to shown.
					-- This catches cases where the bar was already "tracking"
					-- (isTracking=true) but individual nodes were not yet visible
					-- — e.g., after a layout rebuild from the options panel.
					-- When such a frame becomes visible for the first time, its
					-- text content is empty because UpdateResourceBarText skipped
					-- it while isVisible was false.
					if not textFrames[i]:IsShown() then
						anyBecameVisible = true
					end
					textFrames[i]:Show()
					---@diagnostic disable-next-line: undefined-field
					textFrames[i].font:Show()
					-- Screen-bound text is independent of the bar; always fully opaque
					if key == "UIParent" then
						textFrames[i]:SetAlpha(1.0)
					end
				end
			elseif textFrames[i] ~= nil then
				textFrames[i]:Hide()
				---@diagnostic disable-next-line: undefined-field
				textFrames[i].font:Hide()
			end
		end

		-- If any text frame just became visible (was hidden, now shown), force a
		-- full bar text refresh so that UpdateResourceBarText populates content
		-- into the newly-visible frames. Without this, the text stays empty
		-- because the early-out / per-entry skip wrote frameCache.text = "" when
		-- the frame was hidden, and no flag was set to reprocess it.
		if anyBecameVisible and not isTransition then
			self:InvalidateLookupMemoization()
			TRB.Data.barTextVisibilityRefreshNeeded = true
		end
	end
end