---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
TRB.Functions = TRB.Functions or {}
TRB.Functions.BarText = {}

local function TryUpdateText(frame, text)
	frame.font:SetText(text)
end

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

		--if k == k_1 then
		--	k = endLength
		--end

		min = math.min(a, b, c, d, e, f, g, h, i, j, k, k_1, l, m, n, o, p, q, r, s, t)
		index = index + 1

		if min <= string.len(input) then
			local ins = {
				position = min,
				level = currentLevel,
				parenthesisLevel = currentParenthesisLevel,
				index = index
			}

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

			table.insert(all, ins)
		else
			currentPosition = string.len(input) + 1
			break
		end
	end
	returnTable.all = all

	return returnTable
end

local function FindNextSymbolIndex(t, symbol, notSymbol, minIndex, maxIndex, minPosition, maxPosition)
	if t == nil or symbol == nil then
		return nil
	end

	local len = TRB.Functions.Table:Length(t)
	if len == 0 then
		return nil
	end

	if minIndex == nil then
		minIndex = 0
	end

	if minPosition == nil then
		minPosition = 0
	end

	if notSymbol == nil then
		notSymbol = false
	end

	if maxIndex == nil then
		maxIndex = t[len].index
	end

	if maxPosition == nil then
		maxPosition = t[len].position
	end

	for k, v in ipairs(t) do
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

local function FindNextSymbolLevel(t, symbol, minIndex, level)
	if t == nil or symbol == nil or level == nil or level < 0 then
		return nil
	end

	if minIndex == nil then
		minIndex = 0
	end

	local len = TRB.Functions.Table:Length(t)

	if len > 0 then
		for k, v in ipairs(t) do
			if t[k] ~= nil and t[k].level ~= nil and t[k].index >= minIndex and t[k].symbol == symbol and t[k].level == level then
				return t[k]
			end
		end
	end
	return nil
end

local function RemoveInvalidVariablesFromBarText(inputString)
	local scan = ScanForLogicSymbols(inputString)

	local function RemoveInvalidVariablesFromBarText_Inner(input, indexOffset, maxIndex, positionOffset, maxPosition)
		local returnText = ""

---@diagnostic disable-next-line: undefined-field
		if string.len(string.trim(input)) == 0 then
			return returnText
		end

		local p = 0

		if indexOffset == nil then
			indexOffset = 0
		end

		if positionOffset == nil then
			positionOffset = 0
		end

		local lastIndex = indexOffset
		while p <= string.len(input) do
			local nextOpenIf = FindNextSymbolIndex(scan.all, '{', nil, lastIndex, maxIndex)
			if nextOpenIf ~= nil then
				local matchedCloseIf = FindNextSymbolLevel(scan.all, '}', nextOpenIf.index+1, nextOpenIf.level)

				if nextOpenIf.position - positionOffset > p then
					returnText = returnText .. string.sub(input, p, nextOpenIf.position - positionOffset - 1)
					p = nextOpenIf.position - positionOffset
				end
				
				if matchedCloseIf ~= nil and matchedCloseIf.symbol == '}' and matchedCloseIf.level == nextOpenIf.level then -- no weird nesting of if logic, which is unsupported
					local nextOpenResult = FindNextSymbolLevel(scan.all, '[', matchedCloseIf.index+1, nextOpenIf.level)

					if nextOpenResult ~= nil and nextOpenResult.symbol == '[' and matchedCloseIf.position - positionOffset + 1 == nextOpenResult.position - positionOffset then -- no weird spacing/nesting
						local nextCloseResult = FindNextSymbolLevel(scan.all, ']', nextOpenResult.index, nextOpenResult.level)
						if nextCloseResult ~= nil then
							local hasElse = false
							local elseOpenResult = FindNextSymbolLevel(scan.all, '[', nextCloseResult.index, nextOpenResult.level)
							local elseCloseResult

							if elseOpenResult ~= nil and elseOpenResult.position - positionOffset == nextCloseResult.position - positionOffset + 1 then
								elseCloseResult = FindNextSymbolLevel(scan.all, ']', elseOpenResult.index, nextOpenResult.level)

								if elseCloseResult ~= nil then
									-- We have if/else
									hasElse = true
								end
							end

---@diagnostic disable-next-line: undefined-field
							local logicString = string.trim(string.sub(input, nextOpenIf.position - positionOffset + 1, matchedCloseIf.position - positionOffset - 1))
							local s = nextOpenIf.position - positionOffset + 1
							local outputString = ""
							local lastLogicIndex = nextOpenIf.index+1
							while s-p-1 <= string.len(logicString) do
								local nextVariable = FindNextSymbolIndex(scan.all, '$', nil, lastLogicIndex, nil, nil, matchedCloseIf.position + 1)
								
								if nextVariable ~= nil then
									local nextSymbol = FindNextSymbolIndex(scan.all, '$', true, nextVariable.index, nil, nil, matchedCloseIf.position + 1)
									local variableEnd = string.len(logicString)

									if nextSymbol ~= nil then
										variableEnd = nextSymbol.position - positionOffset - p - 1
									end

---@diagnostic disable-next-line: undefined-field
									local var = string.trim(string.sub(logicString, nextVariable.position - positionOffset - p, variableEnd))
									var = string.gsub(var, " ", "")
									local valid = TRB.Functions.Class:IsValidVariableForSpec(var)
									
---@diagnostic disable-next-line: undefined-field
									local beforeVar = string.trim(string.sub(logicString, s-p, nextVariable.position - positionOffset - p - 1))
---@diagnostic disable-next-line: undefined-field
									local afterVar = string.trim(string.sub(logicString, variableEnd, variableEnd))

									local prevSymbol = FindNextSymbolIndex(scan.all, '$', true, nextVariable.index-1, nextVariable.index, nil, nil)
									local nextNextSymbol = FindNextSymbolIndex(scan.all, '$', true, nextVariable.index+1, nextVariable.index+1, nil, nil)										
									local pSymbol = ""
									local nSymbol = ""

									if prevSymbol ~= nil and nextNextSymbol ~= nil then
										pSymbol = prevSymbol.symbol
										nSymbol = nextNextSymbol.symbol
									end

									if TRB.Data.lookupLogic[var] ~= nil and pSymbol ~= "!" and ((pSymbol ~= "{" and pSymbol ~= "|" and pSymbol ~= "&" and pSymbol ~= "(") or (nSymbol ~= "}" and nSymbol ~= "|" and nSymbol ~= "&" and nSymbol ~= ")")) then
										valid = TRB.Data.lookupLogic[var]
									end

									if string.sub(beforeVar, string.len(beforeVar)) == "!" then
										outputString = outputString .. " " .. string.sub(beforeVar, 0, string.len(beforeVar)-1) .. " (not " .. tostring(valid) .. ") "
									else
										outputString = outputString .. " " .. beforeVar .. " " .. tostring(valid)
									end

									s = p + variableEnd + 1
									lastLogicIndex = nextVariable.index + 1
								else
---@diagnostic disable-next-line: undefined-field
									local remainder = string.trim(string.sub(logicString, s-p))
									outputString = outputString .. " " .. remainder
									s = p + string.len(logicString) + 2
								end
							end

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
								if not pcallSuccess then-- Something went wrong, show the error text instead
									returnText = returnText .. "{INVALID IF/ELSE LOGIC}"
								elseif result == true or result then
									-- Recursive call for "IF", once we find the matched ]
									local trueText = string.sub(input, nextOpenResult.position - positionOffset + 1, nextCloseResult.position - positionOffset - 1)
									returnText = returnText .. RemoveInvalidVariablesFromBarText_Inner(trueText, nextOpenResult.index, nextCloseResult.index - 1, nextOpenResult.position, nextCloseResult.position - 1)
								elseif elseOpenResult ~= nil and elseCloseResult ~= nil and (result == false or (not result)) and hasElse == true then
									-- Recursive call for "ELSE", once we find the matched ]
									local falseText = string.sub(input, elseOpenResult.position - positionOffset + 1, elseCloseResult.position - positionOffset - 1)
									returnText = returnText .. RemoveInvalidVariablesFromBarText_Inner(falseText, elseOpenResult.index, elseCloseResult.index - 1, elseOpenResult.position, elseCloseResult.position - 1)
								end
							else -- Something went wrong, show the error text instead
								returnText = returnText .. "{INVALID IF/ELSE LOGIC}"
							end

							if elseCloseResult ~= nil and hasElse == true then
								p = elseCloseResult.position - positionOffset + 1
								lastIndex = elseCloseResult.index
							else
								p = nextCloseResult.position - positionOffset + 1
								lastIndex = nextCloseResult.index
							end
						else -- TRUE result block doesn't close, no matching ]
							returnText = returnText .. string.sub(input, p, nextOpenResult.position - positionOffset)
							p = nextOpenResult.position - positionOffset + 1
							lastIndex = nextOpenResult.index
						end
					else -- Dump all of the previous "if" stuff verbatim
						returnText = returnText .. string.sub(input, p, matchedCloseIf.position - positionOffset)
						p = matchedCloseIf.position - positionOffset + 1
						lastIndex = matchedCloseIf.index
					end
				elseif matchedCloseIf ~= nil then --nextCloseIf.position+1 is not [
					returnText = returnText .. string.sub(input, p, matchedCloseIf.position - positionOffset)
					p = matchedCloseIf.position - positionOffset + 1
					lastIndex = matchedCloseIf.index
				else -- End of string
					returnText = returnText .. string.sub(input, p)
					p = string.len(input) + 1
				end
			else
				returnText = returnText .. string.sub(input, p)
				p = string.len(input)
				break
			end
		end
		return returnText
	end

	return RemoveInvalidVariablesFromBarText_Inner(inputString)
end

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
	
	--Only loop through this while we're not at the end of the string AND we haven't done 1000 checks. This is a sanity checker to prevent an infinite run for some reason!
	while p <= string.len(input) and infinity < 1000 do
		infinity = infinity + 1
		local a, b, c, d, z, a1, b1, c1, d1, z1
		local match = false
		a, a1 = string.find(input, "#", p)
		b, b1 = string.find(input, "%$", p)
		c, c1 = string.find(input, "|", p)
		d, d1 = string.find(input, "%%", p)
		if a ~= nil and (b == nil or a < b) and (c == nil or a < c) and (d == nil or a < d) then
			if string.sub(input, a+1, a+6) == "spell_" then
				z, z1 = string.find(input, "_", a+7)
				if z ~= nil then
					local iconName = string.sub(input, a, z)
					local spellId = string.sub(input, a+7, z-1)
					local _, icon
					_, _, icon = GetSpellInfo(spellId)

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
			elseif string.sub(input, a+1, a+5) == "item_" then
				z, z1 = string.find(input, "_", a+6)
				if z ~= nil then
					local iconName = string.sub(input, a, z)
					local itemId = string.sub(input, a+6, z-1)
					local _, icon
					_, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemId)

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
					z, z1 = string.find(input, barTextVariables.icons[x].variable, a-1)
					if z ~= nil and z == a then
						match = true
						if p ~= a then
							returnText = returnText .. string.sub(input, p, a-1)
						end

						returnText = returnText .. "%s"
						table.insert(returnVariables, barTextVariables.icons[x].variable)

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

	table.insert(TRB.Data.barTextCache, barTextCacheEntry)
	return barTextCacheEntry
end

local function GetFromBarTextCache(barText)
	local entries = TRB.Functions.Table:Length(TRB.Data.barTextCache)

	if entries > 0 then
		for x = 1, entries do
			if TRB.Data.barTextCache[x].cleanedText == barText then
				return TRB.Data.barTextCache[x]
			end
		end
	end

	return AddToBarTextCache(barText)
end

local function GetReturnText(inputText)
	local lookup = TRB.Data.lookup
	lookup["color"] = inputText.color
	inputText.text = RemoveInvalidVariablesFromBarText(inputText.text)

	local cache = GetFromBarTextCache(inputText.text)
	local mapping = {}
	local cachedTextVariableLength = TRB.Functions.Table:Length(cache.variables)

	if cachedTextVariableLength > 0 then
		for y = 1, cachedTextVariableLength do
			table.insert(mapping, lookup[cache.variables[y]])
		end
	end

	if TRB.Functions.Table:Length(mapping) > 0 then
		local result
		result, inputText.text = pcall(string.format, cache.stringFormat, unpack(mapping))
	elseif string.len(cache.stringFormat) > 0 then
		inputText.text = cache.stringFormat
	else
		inputText.text = ""
	end

	return string.format("%s%s", inputText.color, inputText.text)
end

function TRB.Functions.BarText:RefreshLookupDataBase(settings)
	--Spec specific implementations also needed. This is general/cross-spec data
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]

	--$crit
	local critPercent = string.format("%." .. settings.hastePrecision .. "f", TRB.Functions.Number:RoundTo(snapshotData.attributes.crit, settings.hastePrecision))

	--$critRating
	local critRating = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.critRating, settings.hastePrecision, "floor", true))

	--$mastery
	local masteryPercent = string.format("%." .. settings.hastePrecision .. "f", TRB.Functions.Number:RoundTo(snapshotData.attributes.mastery, settings.hastePrecision))

	--$masteryRating
	local masteryRating = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.masteryRating, settings.hastePrecision, "floor", true))

	--$gcd
	local _gcd = 1.5 / (1 + (snapshotData.attributes.haste/100))
	if _gcd > 1.5 then
		_gcd = 1.5
	elseif _gcd < 0.75 then
		_gcd = 0.75
	end
	local gcd = string.format("%.2f", _gcd)

	--$haste
	local hastePercent = string.format("%." .. settings.hastePrecision .. "f", TRB.Functions.Number:RoundTo(snapshotData.attributes.haste, settings.hastePrecision))
	
	--$hasteRating
	local hasteRating = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.hasteRating, settings.hastePrecision, "floor", true))

	--$vers
	local versOff = string.format("%." .. settings.hastePrecision .. "f", TRB.Functions.Number:RoundTo(snapshotData.attributes.versatilityOffensive, settings.hastePrecision))
	local versDef = string.format("%." .. settings.hastePrecision .. "f", TRB.Functions.Number:RoundTo(snapshotData.attributes.versatilityDefensive, settings.hastePrecision))

	--$versRating
	local versRating = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.versatilityRating, settings.hastePrecision, "floor", true))
	
	--$int
	local int = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.intellect, settings.hastePrecision, "floor", true))
	--$agi
	local agi = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.agility, settings.hastePrecision, "floor", true))
	--$str
	local str = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.strength, settings.hastePrecision, "floor", true))
	--$stam
	local stam = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(snapshotData.attributes.stamina, settings.hastePrecision, "floor", true))

	--$ttd
	local _ttd = 0
	local ttd = "--"
	local ttdTotalSeconds = "0"

	if target ~= nil and target.timeToDie.time ~= 0 then
		local ttdMinutes = math.floor(target.timeToDie.time / 60)
		local ttdSeconds = target.timeToDie.time % 60
		_ttd = target.timeToDie.time
		ttdTotalSeconds = string.format("%s", TRB.Functions.Number:RoundTo(target.timeToDie.time, TRB.Data.settings.core.ttd.precision or 1, "floor"))
		ttd = string.format("%d:%0.2d", ttdMinutes, ttdSeconds)
	end

	--#castingIcon
	local castingIcon = snapshotData.casting.icon or ""
	local castingAmount = snapshotData.casting.resourceFinal or 0

	local lookup = TRB.Data.lookup or {}
	lookup["#casting"] = castingIcon
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
	
	lookup["$int"] = int
	lookup["$intellect"] = int
	lookup["$str"] = str
	lookup["$strength"] = str
	lookup["$agi"] = agi
	lookup["$agility"] = agi
	lookup["$stam"] = stam
	lookup["$stamina"] = stam
	lookup["$inCombat"] = tostring(UnitAffectingCombat("player"))

	lookup["$gcd"] = gcd
	lookup["$ttd"] = ttd
	lookup["$ttdSeconds"] = ttdTotalSeconds
	lookup["||n"] = string.format("\n")
	lookup["||c"] = string.format("%s", "|c")
	lookup["||r"] = string.format("%s", "|r")
	lookup["%%"] = "%"


	local lookupLogic = TRB.Data.lookupLogic or {}
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

	lookupLogic["$int"] = snapshotData.attributes.intellect
	lookupLogic["$intellect"] = snapshotData.attributes.intellect
	lookupLogic["$str"] = snapshotData.attributes.strength
	lookupLogic["$strength"] = snapshotData.attributes.strength
	lookupLogic["$agi"] = snapshotData.attributes.agility
	lookupLogic["$agility"] = snapshotData.attributes.agility
	lookupLogic["$stam"] = snapshotData.attributes.stamina
	lookupLogic["$stamina"] = snapshotData.attributes.stamina

	lookupLogic["$gcd"] = _gcd
	lookupLogic["$ttd"] = _ttd
	lookupLogic["$ttdSeconds"] = _ttd
	lookupLogic["$inCombat"] = tostring(UnitAffectingCombat("player"))
	TRB.Data.lookupLogic = lookupLogic

	Global_TwintopResourceBar = {
		ttd = {
			ttd = ttd or "--",
			seconds = ttdTotalSeconds or 0
		},
		resource = {
			resource = snapshotData.attributes.resource or 0,
			casting = castingAmount
		}
	}
end

function TRB.Functions.BarText:IsTtdActive(settings)
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	if settings ~= nil and settings.displayText ~= nil then
		if string.find(settings.displayText.left.text, "$ttd") or
			string.find(settings.displayText.middle.text, "$ttd") or
			string.find(settings.displayText.right.text, "$ttd") then
			targetData.ttdIsActive = true
		else
			targetData.ttdIsActive = false
		end
	else
		targetData.ttdIsActive = false
	end
end

function TRB.Functions.BarText:BarText(settings)
	if settings ~= nil and settings.colors ~= nil and settings.colors.text ~= nil and settings.displayText ~= nil and
		settings.displayText.left ~= nil and settings.displayText.middle ~= nil and settings.displayText.right ~= nil then
		local returnText = {}
		returnText[0] = {}
		returnText[1] = {}
		returnText[2] = {}
		returnText[0].text = settings.displayText.left.text
		returnText[1].text = settings.displayText.middle.text
		returnText[2].text = settings.displayText.right.text

		returnText[0].color = string.format("|c%s", settings.colors.text.left)
		returnText[1].color = string.format("|c%s", settings.colors.text.middle)
		returnText[2].color = string.format("|c%s", settings.colors.text.right)

		return GetReturnText(returnText[0]), GetReturnText(returnText[1]), GetReturnText(returnText[2])
	else
		return "", "", ""
	end
end

function TRB.Functions.BarText:UpdateResourceBarText(settings, refreshText)
	if settings ~= nil and settings.bar ~= nil then
		TRB.Functions.BarText:RefreshLookupDataBase(settings)
		TRB.Functions.RefreshLookupData()
	
		if refreshText then
			if classIndexId == 5 then --Do this for Priests only
				---@type Frame[]
				local textFrames = TRB.Frames.textFrames
				local displayText = settings.displayText --[[@as TRB.Classes.DisplayText]]
	
				local entries = TRB.Functions.Table:Length(displayText.barText)
				if entries > 0 then
					for i = 1, entries do
						local e = displayText.barText[i]
						local color = e.color
						local fontFace = e.fontFace
						local fontSize = e.fontSize
						
						if e.useDefaultFontColor then
							color = displayText.default.color
						end

						if e.useDefaultFontFace then
							fontFace = displayText.default.fontFace
						end

						if e.useDefaultFontSize then
							fontSize = displayText.default.fontSize
						end

						local barText = {
							text = e.text,
							color = string.format("|c%s", color)
						}

						local returnText = GetReturnText(barText)

						if not pcall(TryUpdateText, textFrames[i], returnText) then
							textFrames[i].font:SetFont(fontFace, fontSize, "OUTLINE")
						end
					end
				end
			else
				local leftText, middleText, rightText = TRB.Functions.BarText:BarText(settings)
				local leftTextFrame = TRB.Frames.leftTextFrame
				local middleTextFrame = TRB.Frames.middleTextFrame
				local rightTextFrame = TRB.Frames.rightTextFrame

				if not pcall(TryUpdateText, leftTextFrame, leftText) then
					leftTextFrame.font:SetFont(settings.displayText.left.fontFace, settings.displayText.left.fontSize, "OUTLINE")
				end

				if not pcall(TryUpdateText, middleTextFrame, middleText) then
					middleTextFrame.font:SetFont(settings.displayText.left.fontFace, settings.displayText.middle.fontSize, "OUTLINE")
				end

				if not pcall(TryUpdateText, rightTextFrame, rightText) then
					rightTextFrame.font:SetFont(settings.displayText.left.fontFace, settings.displayText.right.fontSize, "OUTLINE")
				end
			end
		end
	end
end

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
	elseif var == "$ttd" or var == "$ttdSeconds" then
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		if targetData.currentTargetGuid ~= nil and UnitGUID("target") ~= nil and target ~= nil and target.timeToDie.time > 0 then
			valid = true
		end
	elseif var == "$inCombat" then
		if UnitAffectingCombat("player") then
			valid = true
		end
	end

	return valid
end

---@param settings table
function TRB.Functions.BarText:CreateBarTextFrames(settings)
	---@type Frame[]
	local textFrames = TRB.Frames.textFrames
	local displayText = settings.displayText --[[@as TRB.Classes.DisplayText]]
	
	local entries = TRB.Functions.Table:Length(displayText.barText)
	if entries > 0 then
		for i = 1, entries do
			local e = displayText.barText[i]
			local relativeTo = e.position.relativeTo
			local relativeToFrame = _G["TwintopResourceBarFrame_"..e.position.relativeToFrame]
			local fontFace = e.fontFace
			local fontSize = e.fontSize

			if e.useDefaultFontFace then
				fontFace = displayText.default.fontFace
			end

			if e.useDefaultFontSize then
				fontSize = displayText.default.fontSize
			end

			if textFrames[i] == nil then
				textFrames[i] = CreateFrame("Frame", "TwintopResourceBarFrame_TextFrame"..i, relativeToFrame)
				---@diagnostic disable-next-line: inject-field
				textFrames[i].font = TRB.Frames.textFrames[i]:CreateFontString(nil, "BACKGROUND")
			end
			
			textFrames[i]:Show()
			textFrames[i]:SetFrameStrata(TRB.Data.settings.core.strata.level)
			textFrames[i]:SetFrameLevel(TRB.Data.constants.frameLevels.barText)
			textFrames[i]:SetParent(relativeToFrame)
			textFrames[i].font:SetTextColor(255/255, 255/255, 255/255, 1.0)
			textFrames[i].font:SetJustifyH(relativeTo)
			textFrames[i].font:SetFont(fontFace, fontSize, "OUTLINE")
			textFrames[i].font:Show()

			textFrames[i]:SetAllPoints(textFrames[i].font)
			textFrames[i].font:SetPoint(relativeTo, relativeToFrame, relativeTo, e.position.xPos, e.position.yPos)
		end
	end
end