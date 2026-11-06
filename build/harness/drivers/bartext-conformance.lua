-- Checks the bar text engine (RenderBarTextEntry) renders exactly what the legacy resolver (GetReturnText) does.
local desktop = _G --[[@as table<string, any>]]
local os, debug = desktop.os, desktop.debug
local parity = desktop.require("drivers.parity")

-- Seeded draws per text, so a failure reproduces.
local DRAWS = tonumber(os.getenv("TRB_CONFORMANCE_DRAWS") or "") or 48

-- A secret value: it formats, but ordering and arithmetic against a number raise, as on the client.
local SECRET = "\1secret\1"

local logicValues = { false, true, 0, 1, 5, 150, -3, 0.5, "true", "false", "", "abc", "10", SECRET }
local lookupValues = { "", "5", "|cFFFF0000x|r", "12.5", SECRET }
local colorCodes = { "|cFFFFFFFF", "|cFF00FF00" }

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = tonumber(os.getenv("TRB_SPEC") or ""), holdDeferredSetup = true })
end

function hooks.afterLoad(ctx)
	ctx.TRB.Functions.News.Init = function() end
end

---Finds a local function another function closes over, by name, searching its upvalues' upvalues too.
---@param fn function
---@param name string
---@return function?
local function FindUpvalue(fn, name)
	local seen = {}
	local queue = { fn }
	while #queue > 0 do
		local current = table.remove(queue, 1)
		if not seen[current] then
			seen[current] = true
			local i = 1
			while true do
				local upName, value = debug.getupvalue(current, i)
				if upName == nil then
					break
				end
				if type(value) == "function" then
					if upName == name then
						return value
					end
					queue[#queue + 1] = value
				end
				i = i + 1
			end
		end
	end
	return nil
end

---Every bar text string in a settings tree, once each.
---@param root table
---@param into table<string, boolean>
local function CollectTexts(root, into)
	local seen = {}
	local function Walk(t)
		if seen[t] then
			return
		end
		seen[t] = true
		for key, value in pairs(t) do
			if type(value) == "table" then
				if key == "barText" then
					for _, entry in pairs(value) do
						if type(entry) == "table" and type(entry.text) == "string" then
							into[entry.text] = true
						end
					end
				end
				Walk(value)
			end
		end
	end
	Walk(root)
end

function hooks.afterEvents(ctx)
	local G = desktop
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local failures = 0
	local function check(label, ok, detail)
		print((ok and "PASS " or "FAIL ") .. label .. ((not ok and detail) and (" (" .. detail .. ")") or ""))
		if not ok then
			failures = failures + 1
		end
	end

	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end

	local BarText = TRB.Functions.BarText
	local RenderBarTextEntry = FindUpvalue(BarText.UpdateResourceBarText, "RenderBarTextEntry")
	local GetReturnText = FindUpvalue(BarText.UpdateResourceBarText, "GetReturnText")
	check("found RenderBarTextEntry and GetReturnText", RenderBarTextEntry ~= nil and GetReturnText ~= nil)
	if RenderBarTextEntry == nil or GetReturnText == nil then
		return failures
	end

	-- Secrets are the sentinel; compiled signatures captured the old check, so they are dropped.
	G.issecretvalue = function(value) return value == SECRET end
	BarText:ClearBarTextCacheHash()

	-- Every variable's validator answer comes from the draw, so each class's validators are bypassed alike.
	local validatorAnswers = {}
	local Class = TRB.Functions.Class
	Class.IsValidVariableForSpec = function(_, var)
		return validatorAnswers[var] == true
	end

	-- Three real variable names, so the edge cases resolve as the corpus does.
	local names = {}
	for _, entry in ipairs(TRB.Data.barTextVariables.values) do
		if type(entry.variable) == "string" and string.match(entry.variable, "^%$[%w_]+$") then
			names[#names + 1] = entry.variable
		end
	end
	table.sort(names)
	local A, B, C = names[1] or "$a", names[2] or "$b", names[3] or "$c"

	-- The live settings, plus every profile a loaded save holds.
	local texts = {}
	CollectTexts(TRB.Data.settings, texts)
	for _, savedName in ipairs({ "TwintopInsanityBarSettings", "TwintopInsanityBarClassicSettings",
		"TwintopInsanityBarForeverSettings", "TwintopInsanityBarTBCSettings" }) do
		local saved = rawget(G, savedName)
		if type(saved) == "table" then
			CollectTexts(saved, texts)
		end
	end
	local edges = {
		"{" .. A .. " = 5}[x][y]", "{" .. A .. " == 5}[x][y]", "{" .. A .. " != 5}[x][y]", "{" .. A .. " !== 5}[x][y]",
		"{" .. A .. " ~== 5}[x][y]", "{" .. A .. " >== 5}[x][y]", "{" .. A .. " <== 5}[x][y]", "{" .. A .. " === 5}[x][y]",
		"{" .. A .. " && " .. B .. "}[x][y]", "{" .. A .. " & " .. B .. "}[x][y]", "{" .. A .. " || " .. B .. "}[x][y]",
		"{" .. A .. " | " .. B .. "}[x][y]", "{()}[x][y]", "{}[x][y]", "{" .. A .. " > }[x][y]",
		"{" .. A .. " = \"ABC\"}[x][y]", "{" .. A .. "}[x]", "{" .. A .. "}[x", "{" .. A .. "}[{" .. B .. "}[p][q]][r]",
		"{" .. A .. "}[" .. A .. "][x]ity", "100% and %%", "||n" .. A, "$notAVar " .. A, "#spell_589_ " .. A,
		"#item_6948_ " .. A, "{!" .. A .. "}[x][y]", "{" .. A .. " > 5 & !" .. B .. "}[x][y]",
		"{(" .. A .. " + 3) > 5}[x][y]", "{" .. A .. " > " .. B .. "}[" .. C .. "][" .. A .. "]",
	}
	for _, edge in ipairs(edges) do
		texts[edge] = true
	end
	-- Past the 26-conditional cap, the engine walks the tree instead of compiling it.
	local capped = {}
	for i = 1, 27 do
		capped[i] = "{" .. (i % 2 == 0 and A or B) .. "}[" .. i .. "][-]"
	end
	texts[table.concat(capped, " ")] = true
	local manyOccurrences = {}
	for i = 1, 72 do
		manyOccurrences[i] = (i % 3 == 0 and A) or (i % 3 == 1 and B) or C
	end
	texts["{" .. table.concat(manyOccurrences, " & ") .. "}[all][some]"] = true

	local ordered = {}
	for text in pairs(texts) do
		ordered[#ordered + 1] = text
	end
	table.sort(ordered)

	-- A fixed LCG, so every run draws the same environments.
	local seed = 12345
	local function Next(n)
		seed = (seed * 1103515245 + 12345) % 2147483648
		return (seed % n) + 1
	end

	local lookup = TRB.Data.lookup
	local logic = TRB.Data.lookupLogic
	local renders, mismatches, skipFailures, staleFailures = 0, 0, 0, 0
	local shown = 0
	local function Report(kind, text, detail)
		if shown < 10 then
			shown = shown + 1
			print(string.format("  %s: %q %s", kind, text, detail))
		end
	end
	local function Legacy(text, colorCode)
		local ok, out = pcall(GetReturnText, { text = text, color = colorCode })
		return ok, out
	end
	---The engine's output, or nil when it skipped; it returns rendered, output, where an older one returned the output or nil.
	local function Engine(state, text, colorCode, force)
		local ok, first, second = pcall(RenderBarTextEntry, state, text, colorCode, force)
		if not ok then
			return false, first
		elseif type(first) == "boolean" then
			return true, first and second or nil
		end
		return true, first
	end

	for _, text in ipairs(ordered) do
		local vars = {}
		local seenVars = {}
		for token in string.gmatch(text, "[%$#][%w_]+") do
			if not seenVars[token] then
				seenVars[token] = true
				vars[#vars + 1] = token
			end
		end
		local state = {}
		for draw = 1, DRAWS do
			for _, var in ipairs(vars) do
				logic[var] = logicValues[Next(#logicValues)]
				lookup[var] = lookupValues[Next(#lookupValues)]
				validatorAnswers[var] = Next(2) == 1
			end
			local colorCode = colorCodes[(draw % 4 < 2) and 1 or 2]
			-- A secret value can't be compared, so a text showing one always renders again.
			local holdsSecret = false
			for _, var in ipairs(vars) do
				if lookup[var] == SECRET then
					holdsSecret = true
				end
			end

			local okL, outL = Legacy(text, colorCode)
			local okE, outE = Engine(state, text, colorCode, true)
			renders = renders + 1
			if okL ~= okE or (okL and outL ~= outE) then
				mismatches = mismatches + 1
				Report("mismatch", text, string.format("draw %d legacy=%s engine=%s", draw, tostring(outL), tostring(outE)))
			elseif okE then
				-- Nothing changed, so an unforced render skips.
				local okS, outS = Engine(state, text, colorCode, false)
				if not okS or (outS ~= nil and not holdsSecret) or (outS ~= nil and outS ~= outE) then
					skipFailures = skipFailures + 1
					Report("unchanged render", text, string.format("draw %d returned %s", draw, tostring(outS)))
				end
				-- One value changes; an unforced render must show any change the legacy resolver does.
				if #vars > 0 then
					local var = vars[Next(#vars)]
					local before = lookup[var]
					local after = lookupValues[Next(#lookupValues)]
					if after == before then
						after = before == "5" and "6" or "5"
					end
					lookup[var] = after
					local okL2, outL2 = Legacy(text, colorCode)
					local okE2, outE2 = Engine(state, text, colorCode, false)
					if okL2 and okE2 and outL2 ~= outL and outE2 ~= outL2 then
						staleFailures = staleFailures + 1
						Report("stale render", text, string.format("draw %d legacy=%s engine=%s", draw, tostring(outL2), tostring(outE2)))
					elseif okL2 and okE2 and outL2 == outL and outE2 ~= nil and outE2 ~= outL2 then
						staleFailures = staleFailures + 1
						Report("wrong rerender", text, string.format("draw %d legacy=%s engine=%s", draw, tostring(outL2), tostring(outE2)))
					end
				end
			end
		end
		-- A cache clear mid-run, as a specialization change does, must not change any answer.
		if Next(8) == 1 then
			BarText:ClearBarTextCacheHash()
		end
	end

	check(string.format("engine matches legacy on %d renders of %d texts", renders, #ordered), mismatches == 0, mismatches .. " differ")
	check("an unforced render with nothing changed skips", skipFailures == 0, skipFailures .. " rendered")
	check("an unforced render after a change shows what legacy shows", staleFailures == 0, staleFailures .. " stale")
	return failures
end

return hooks
