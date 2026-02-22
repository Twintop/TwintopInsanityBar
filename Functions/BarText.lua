local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.BarText = {}

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

		{ variable = "$health", description = L["BarTextVariable_health"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariable_healthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariable_healthPercent"], printInSettings = true, color = false },

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

local function TryUpdateText(frame, text)
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

	local len = TRB.Functions.Table:Length(t)
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

	local len = TRB.Functions.Table:Length(t)

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


---Removes invalid variables from the bar text represented within the tree
---@param tree table
---@return string
local function RemoveInvalidVariablesFromBarText(tree)
	if tree == nil or tree.barText == nil then
		return ""
	end
	
	local returnText = {}

	for _, v in ipairs(tree.barText) do
		if type(v) == "string" then
			table.insert(returnText, v)
		else
			local canCache = true
			local outputStringTable = {}
			local s = 1
			local index = 1
			while s <= #v.logic do
				local nextVariable = v.logicVariables[index]
				if nextVariable then
					local valid = TRB.Functions.Class:IsValidVariableForSpec(nextVariable.variable)
					if TRB.Data.lookupLogic[nextVariable.variable] and nextVariable.prevSymbol ~= "!" and ((nextVariable.prevSymbol ~= "{" and nextVariable.prevSymbol ~= "|" and nextVariable.prevSymbol ~= "&" and nextVariable.prevSymbol ~= "(") or (nextVariable.nextSymbol ~= "}" and nextVariable.nextSymbol ~= "|" and nextVariable.nextSymbol ~= "&" and nextVariable.nextSymbol ~= ")")) then
						valid = TRB.Data.lookupLogic[nextVariable.variable]

						if issecretvalue(valid) then
							valid = false
						end

						if type(valid) == "number" and not TRB.Functions.Number:IsInteger(tostring(valid)) then
							canCache = false
						end
					end

					if nextVariable.beforeVarIsNot then
						table.insert(outputStringTable, " ")
						table.insert(outputStringTable, nextVariable.beforeVarIsNotSubString)
						table.insert(outputStringTable, " (not ")
						table.insert(outputStringTable, tostring(valid))
						table.insert(outputStringTable, ") ")
					else
						table.insert(outputStringTable, " ")
						table.insert(outputStringTable, nextVariable.beforeVar)
						table.insert(outputStringTable, " ")
						table.insert(outputStringTable, tostring(valid))
					end

					s = nextVariable.variableEnd + 1
					index = index + 1
				else
					local remainder = string.trim(string.sub(v.logic, s))
					table.insert(outputStringTable, " ")
					table.insert(outputStringTable, remainder)
					s = #v.logic + 2
				end
			end
			local outputString = table.concat(outputStringTable)
			local cacheKey = outputString
			local processResult = v.processedLogicStrings[cacheKey]
		
			if processResult == nil or canCache == false then
				outputString = string.lower(outputString)
				--outputString = string.gsub(outputString, " ", "") -- This is causing problems with ! nots
				outputString = string.gsub(outputString, "%(%)", "")
				outputString = string.gsub(outputString, "=", "==")
				outputString = string.gsub(outputString, "!==", "!=")
				outputString = string.gsub(outputString, "~==", "~=")
				outputString = string.gsub(outputString, ">==", ">=")
				outputString = string.gsub(outputString, "<==", "<=")
				outputString = string.gsub(outputString, "===", "==")
				outputString = string.gsub(outputString, "!=", "~=")
				outputString = string.gsub(outputString, "!", " not ")
				outputString = string.gsub(outputString, "&", " and ")
				outputString = string.gsub(outputString, "||", " or ")
				
				local resultCode, resultFunc = pcall(assert, loadstring("return (" .. outputString .. ")"))
				if resultCode then
					local pcallSuccess, result = pcall(resultFunc)
					if not pcallSuccess then-- Something went wrong
						processResult = "INVALID"
					elseif result == true or result then
						processResult = "TRUE"
					elseif v.falseResult then
						processResult = "FALSE"
					else
						processResult = "NONE"
					end
				else -- Something went wrong
					processResult = "INVALID"
				end

				if canCache then
					v.processedLogicStrings[cacheKey] = processResult
				end
			end

			if processResult == "INVALID" then-- Something went wrong, show the error text instead
				table.insert(returnText, L["BarTextInvalidIfElseLogic"])
			elseif processResult == "TRUE" then
				table.insert(returnText, RemoveInvalidVariablesFromBarText(v.trueResult))
			elseif processResult == "FALSE" then
				table.insert(returnText, RemoveInvalidVariablesFromBarText(v.falseResult))
			end
		end
	end

    return table.concat(returnText)
end

---Adds the input to the bar text cache
---@param input string
---@return table
local function AddToBarTextCache(input)
	local barTextVariables = TRB.Data.barTextVariables
	local iconEntries = TRB.Functions.Table:Length(barTextVariables.icons)
	local valueEntries = TRB.Functions.Table:Length(barTextVariables.values)
	local pipeEntries = TRB.Functions.Table:Length(barTextVariables.pipe)
	local percentEntries = TRB.Functions.Table:Length(barTextVariables.percent)
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
	local entries = TRB.Functions.Table:Length(TRB.Data.cache.barText)

	if entries > 0 then
		for x = 1, entries do
			if TRB.Data.cache.barText[x].cleanedText == barText then
				return TRB.Data.cache.barText[x]
			end
		end
	end

	return AddToBarTextCache(barText)
end

---Gets the return text after processing the input text
---@param inputText table
---@return string
local function GetReturnText(inputText)
	local lookup = TRB.Data.lookup
	lookup["color"] = inputText.color
	inputText.text = RemoveInvalidVariablesFromBarText(GetFromBarTextTreeCache(inputText.text))

	local cache = GetFromBarTextCache(inputText.text)
	local mapping = {}
	local cachedTextVariableLength = TRB.Functions.Table:Length(cache.variables)

	if cachedTextVariableLength > 0 then
		for y = 1, cachedTextVariableLength do
			table.insert(mapping, lookup[cache.variables[y]])
		end
	end

	if TRB.Functions.Table:Length(mapping) > 0 then
		_, inputText.text = pcall(string.format, cache.stringFormat, unpack(mapping))
	elseif string.len(cache.stringFormat) > 0 then
		inputText.text = cache.stringFormat
	else
		inputText.text = ""
	end

	return string.format("%s%s", inputText.color, inputText.text)
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

	local checkPrimaryStats = true
	local checkSecondaryStats = true
	local primary = ArePrimaryRatingsNil()
	local secondary = AreSecondaryRatingsNil()
	if primary then
		TRB.Functions.Character:UpdatePrimaryStatsSnapshot()
	elseif snapshotData.attributes.cacheRefresh == false then
		checkPrimaryStats = false
	end
	
	if secondary then
		TRB.Functions.Character:UpdateSecondaryStatsSnapshot()
	elseif snapshotData.attributes.cacheRefresh == false then
		checkSecondaryStats = false
	end

	if checkPrimaryStats or lookup["$int"] == nil then
		--$int
		local int = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.intellect, settings.precision.secondary, "floor", true))
		--$agi
		local agi = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.agility, settings.precision.secondary, "floor", true))
		--$str
		local str = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.strength, settings.precision.secondary, "floor", true))
		--$stam
		local stam = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.stamina, settings.precision.secondary, "floor", true))

		
		lookup["$int"] = int
		lookup["$intellect"] = int
		lookup["$str"] = str
		lookup["$strength"] = str
		lookup["$agi"] = agi
		lookup["$agility"] = agi
		lookup["$stam"] = stam
		lookup["$stamina"] = stam
	
		lookupLogic["$int"] = snapshotData.attributes.intellect
		lookupLogic["$intellect"] = snapshotData.attributes.intellect
		lookupLogic["$str"] = snapshotData.attributes.strength
		lookupLogic["$strength"] = snapshotData.attributes.strength
		lookupLogic["$agi"] = snapshotData.attributes.agility
		lookupLogic["$agility"] = snapshotData.attributes.agility
		lookupLogic["$stam"] = snapshotData.attributes.stamina
		lookupLogic["$stamina"] = snapshotData.attributes.stamina

		snapshotData.attributes.cacheRefresh = false
	end

	--$health, $healthMax, $healthPercent - always update these since health changes frequently
	local healthRaw = snapshotData.attributes.health-- or UnitHealth("player", true)
	local healthMaxRaw = snapshotData.attributes.healthMax-- or UnitHealthMax("player")
	local healthPercentRaw = snapshotData.attributes.healthPercent-- or UnitHealthPercent("player", true, CurveConstants.ScaleTo100)

	local healthPrecision = settings.precision.health or 1
	local health = string.format("%s", TRB.Functions.String:ConvertToAbbreviatedNumber(healthRaw))
	local healthMax = string.format("%s", TRB.Functions.String:ConvertToAbbreviatedNumber(healthMaxRaw))
	local healthPercent = string.format("%." .. healthPrecision .. "f", healthPercentRaw)

	lookup["$health"] = health
	lookup["$healthMax"] = healthMax
	lookup["$healthPercent"] = healthPercent

	lookupLogic["$health"] = healthRaw
	lookupLogic["$healthMax"] = healthMaxRaw
	lookupLogic["$healthPercent"] = healthPercentRaw

	if checkSecondaryStats or lookup["$haste"] == nil then
		--$critRating
		local critRating = nil

		--$masteryRating
		local masteryRating = nil

		--$hasteRating
		local hasteRating = nil

		--$vers
		local versOff = nil
		local versDef = nil

		critRating = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.critRating, settings.precision.secondary, "floor", true))
		masteryRating = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.masteryRating, settings.precision.secondary, "floor", true))
		hasteRating = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.hasteRating, settings.precision.secondary, "floor", true))
		versOff = string.format("%." .. settings.precision.secondary .. "f", TRB.Functions.Number:RoundTo(snapshotData.attributes.versatilityOffensive, settings.precision.secondary))
		versDef = string.format("%." .. settings.precision.secondary .. "f", TRB.Functions.Number:RoundTo(snapshotData.attributes.versatilityDefensive, settings.precision.secondary))
		
		--$crit
		local critPercent = string.format("%." .. settings.precision.secondary .. "f", TRB.Functions.Number:RoundTo(snapshotData.attributes.crit, settings.precision.secondary))

		--$versRating
		local versRating = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.versatilityRating, settings.precision.secondary, "floor", true))

		--$mastery
		local masteryPercent = string.format("%." .. settings.precision.secondary .. "f", TRB.Functions.Number:RoundTo(snapshotData.attributes.mastery, settings.precision.secondary))

		--$haste
		local hastePercent = string.format("%." .. settings.precision.secondary .. "f", TRB.Functions.Number:RoundTo(snapshotData.attributes.haste, settings.precision.secondary))
			
		--$gcd
		local _gcd = 1.5 / (1 + ((snapshotData.attributes.haste or 0)  / 100))
		if _gcd > 1.5 then
			_gcd = 1.5
		elseif _gcd < 0.75 then
			_gcd = 0.75
		end
		local gcd = string.format("%.2f", _gcd)

		lookup["$haste"] = hastePercent
		lookup["$hastePercent"] = hastePercent
		lookup["$crit"] = critPercent
		lookup["$critPercent"] = critPercent
		lookup["$mastery"] = masteryPercent
		lookup["$masteryPercent"] = masteryPercent
		lookup["$vers"] = versOff
		lookup["$versPercent"] = versOff
		lookup["$versatility"] = versOff
		lookup["$versatilityPercent"] = versOff
		lookup["$oVers"] = versOff
		lookup["$oVersPercent"] = versOff
		lookup["$dVers"] = versDef
		lookup["$dVersPercent"] = versDef

		lookup["$hasteRating"] = hasteRating
		lookup["$critRating"] = critRating
		lookup["$masteryRating"] = masteryRating
		lookup["$versRating"] = versRating
		lookup["$versatilityRating"] = versRating

		lookup["$gcd"] = gcd

		lookupLogic["$haste"] = snapshotData.attributes.haste
		lookupLogic["$hastePercent"] = snapshotData.attributes.haste
		lookupLogic["$crit"] = snapshotData.attributes.crit
		lookupLogic["$critPercent"] = snapshotData.attributes.crit
		lookupLogic["$mastery"] = snapshotData.attributes.mastery
		lookupLogic["$masteryPercent"] = snapshotData.attributes.mastery
		lookupLogic["$vers"] = snapshotData.attributes.versatilityOffensive
		lookupLogic["$versPercent"] = snapshotData.attributes.versatilityOffensive
		lookupLogic["$versatility"] = snapshotData.attributes.versatilityOffensive
		lookupLogic["$versatilityPercent"] = snapshotData.attributes.versatilityOffensive
		lookupLogic["$oVers"] = snapshotData.attributes.versatilityOffensive
		lookupLogic["$oVersPercent"] = snapshotData.attributes.versatilityOffensive
		lookupLogic["$dVers"] = snapshotData.attributes.versatilityDefensive
		lookupLogic["$dVersPercent"] = snapshotData.attributes.versatilityDefensive
	
		lookupLogic["$hasteRating"] = snapshotData.attributes.hasteRating
		lookupLogic["$critRating"] = snapshotData.attributes.critRating
		lookupLogic["$masteryRating"] = snapshotData.attributes.masteryRating
		lookupLogic["$versRating"] = snapshotData.attributes.versatilityRating
		lookupLogic["$versatilityRating"] = snapshotData.attributes.versatilityRating
	
		lookupLogic["$gcd"] = _gcd

		snapshotData.attributes.cacheRefresh = false
	end

	lookup["||n"] = string.format("\n")
	lookup["||c"] = string.format("%s", "|c")
	lookup["||r"] = string.format("%s", "|r")
	lookup["%%"] = "%"

	--$inCombatTime
	local inCombatTime = "00:00"
	local _inCombatTime = 0
	if TRB.Data.character.inCombat and TRB.Data.character.combatStartTime ~= nil then
		_inCombatTime = GetTime() - TRB.Data.character.combatStartTime
		local minutes = math.floor(_inCombatTime / 60)
		local seconds = math.floor(_inCombatTime - (minutes * 60))
		inCombatTime = string.format("%02d:%02d", minutes, seconds)
	end
	lookup["$inCombatTime"] = inCombatTime
	lookupLogic["$inCombatTime"] = _inCombatTime
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

---Flags many variables, for baseline stats and stat percentages, as valid for bar text logic
---@param var string
---@return boolean
function TRB.Functions.BarText:IsValidVariableBase(var)
	local valid = false
	if var == "$crit" or var == "$critPercent" then
		valid = true
	elseif var == "$mastery" or var == "$masteryPercent" then
		valid = true
	elseif var == "$haste" or var == "$hastePercent" then
		valid = true
	elseif var == "$gcd" then
		valid = true
	elseif var == "$vers" or var == "$versatility" or var == "$oVers" or var == "$versPercent" or var == "$versatilityPercent" or var == "$oVersPercent" then
		valid = true
	elseif var == "$dVers" or var == "$dversPercent" then
		valid = true
	elseif var == "$critRating" then
		valid = true
	elseif var == "$masteryRating" then
		valid = true
	elseif var == "$hasteRating" then
		valid = true
	elseif var == "$versRating" or var == "$versatilityRating" then
		valid = true
	elseif var == "$dVersRating" then
		valid = true
	elseif var == "$int" or var == "$intellect" then
		valid = true
	elseif var == "$agi" or var == "$agility" then
		valid = true
	elseif var == "$str" or var == "$strength" then
		valid = true
	elseif var == "$stam" or var == "$stamina" then
		valid = true
	elseif var == "$inCombat" then
		if TRB.Data.character.inCombat then
			valid = true
		end
	elseif var == "$inCombatTime" then
		if TRB.Data.character.inCombat then
			valid = true
		end
	end

	return valid
end

---Updates the resource bar text based on the settings
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param refreshText boolean
function TRB.Functions.BarText:UpdateResourceBarText(settings, refreshText)
	--Always refresh the lookup data as this also updates the global variable used by other addons/WAs
	TRB.Functions.BarText:RefreshLookupDataBase(settings)
	TRB.Functions.RefreshLookupData()
	
	--Only parse bar text if we're we need to refresh the text
	if settings ~= nil and settings.displayText ~= nil and refreshText then
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
				
				-- Check if the target frame is visible before doing expensive text processing
				local _, isEnabled, isVisible = TRB.Functions.Class:GetBarTextFrame(e.position.relativeToFrame)
				
				-- UIParent-attached bar text is always considered visible
				if e.position.relativeToFrame == "UIParent" then
					isVisible = true
				end
				
				TRB.Data.cache.values.frame["textFrames" .. i] = TRB.Data.cache.values.frame["textFrames" .. i] or {}
				
				-- Skip expensive text processing if the target bar is not visible
				if not isEnabled or not isVisible then
					TRB.Data.cache.values.frame["textFrames" .. i].text = ""
				else
					local color = e.color.color
					
					if e.useDefaultFontColor then
						-- displayText.default.color uses the new table format { color = "..." }
						color = displayText.default.color.color
					end

					local barText = {
						text = e.text,
						color = string.format("|c%s", color)
					}

					local returnText = GetReturnText(barText)

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
					TRB.Data.cache.values.frame["textFrames" .. i].text = returnText
				end
				
				if TRB.Data.cache.values.frame["textFrames" .. i].level ~= TRB.Data.settings.core.strata.level then
					if textFrames ~= nil and textFrames[i] ~= nil then
						textFrames[i]:SetFrameLevel(TRB.Data.constants.frameLevels.barText)
						textFrames[i]:SetFrameStrata(TRB.Data.settings.core.strata.level)
					end
					TRB.Data.cache.values.frame["textFrames" .. i].level = TRB.Data.settings.core.strata.level
				end
			end
		end
	end
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
	
	local entries = TRB.Functions.Table:Length(displayText.barText)
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

			local relativeTo = e.position.relativeTo
			---@type Frame
			local relativeToFrame
			local isEnabled = true
			
			if e.position.relativeToFrame == "UIParent" then
				relativeToFrame = UIParent
			elseif e.position.relativeToFrame == "AllComboPoints" then
			else
				-- Capture isVisible but don't use it for frame creation - parenting needs the frame regardless
				relativeToFrame, isEnabled, _ = TRB.Functions.Class:GetBarTextFrame(e.position.relativeToFrame)

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
				font:SetFont(fontFace, fontSize, "OUTLINE")
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
				textFrames[frameCount]:Hide()
				font:Hide()
			end
			frameCount = frameCount + 1
		end
	end
	
	local textFramesEntries = TRB.Functions.Table:Length(textFrames)
	-- We have extra frames we don't need now, probably because we changed talents/specs/deleted one in config. Hide extras.
	if textFramesEntries >= frameCount then
		for i = frameCount, textFramesEntries do
			textFrames[i]:Hide()
			---@diagnostic disable-next-line: undefined-field
			textFrames[i].font:Hide()
		end
	end
end

---Returns a string formatted time value based on settings for precision
---@param value number # Timer value to format
---@param positiveOnly boolean? # Should the timer only ever show a positive number?
---@return string # String formatted value with correct precision based on thresholds
function TRB.Functions.BarText:TimerPrecision(value, positiveOnly)
	if positiveOnly == nil then
		positiveOnly = true
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

---Hides all bar text
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
function TRB.Functions.BarText:Hide(settings)
	if 1 == 2 then-- settings ~= nil then
		local displayText = settings.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		---@type Frame[]
		local textFrames = TRB.Frames.textFrames
		local entries = TRB.Functions.Table:Length(displayText.barText)
		if entries > 0 then
			for i = 1, entries do
				textFrames[i]:Hide()
				---@diagnostic disable-next-line: undefined-field
				textFrames[i].font:Hide()
			end
		end
	else
		local textFrames = TRB.Frames.textFrames
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
	local entries = TRB.Functions.Table:Length(displayText.barText)
	if entries > 0 then
		for i = 1, entries do
			local e = displayText.barText[i]
			local _, isEnabled, isVisible = TRB.Functions.Class:GetBarTextFrame(e.position.relativeToFrame)
			
			-- UIParent-attached bar text is always considered visible
			if e.position.relativeToFrame == "UIParent" then
				isVisible = true
			end
			
			if e.enabled and isEnabled and isVisible and textFrames[i] ~= nil then
				if TRB.Functions.Bar:IsRenderTransitionActive() then
					textFrames[i]:Hide()
					---@diagnostic disable-next-line: undefined-field
					textFrames[i].font:Hide()
				else
					textFrames[i]:Show()
					---@diagnostic disable-next-line: undefined-field
					textFrames[i].font:Show()
				end
			elseif textFrames[i] ~= nil then
				textFrames[i]:Hide()
				---@diagnostic disable-next-line: undefined-field
				textFrames[i].font:Hide()
			end
		end
	end
end