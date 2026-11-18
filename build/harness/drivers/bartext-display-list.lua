-- Checks that a bar text pass draws exactly the enabled entries on showing anchors, through every change to the
-- entry list and to an anchor's visibility (settings in harness/README.md).
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	-- Brewmaster's and Evoker's ticks read these.
	desktop.UnitStagger = function() return 0 end
	desktop.UnitPartialPower = function() return 0 end
end

-- The News popup needs UI the stubs lack, and its error would stop the deferred setup.
function hooks.afterLoad(ctx)
	ctx.TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local errors = 0
	local function check(label, ok, detail)
		print((ok and "PASS " or "FAIL ") .. label .. ((not ok and detail) and (" (" .. tostring(detail) .. ")") or ""))
		if not ok then
			errors = errors + 1
		end
	end

	TRB.Functions.Bar.UpdateHealthBar = function() end
	TRB.Functions.Bar.IsRenderTransitionActive = function() return false end
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	for i = 1, 20 do
		local _, timerFailures = stubs.fireEvents("TRB_DRAIN_SETUP_" .. i, ctx.addonName)
		if timerFailures == 0 then
			break
		end
	end

	local BarText = TRB.Functions.BarText
	local barGroups = TRB.Frames.barGroups
	local cache = TRB.Data.specCache[TRB.Data.character.compositeKey]
	if not TRB.Data.specSupported or barGroups == nil or barGroups.primary == nil or barGroups.castbar == nil or cache == nil then
		check("the specialization has a main bar and a cast bar", false)
		print(string.format("DRIVER bartext-display-list: %d failures", errors))
		return errors
	end
	local settings = cache.settings
	local displayText = settings.displayText

	---A bar text entry showing whether the character is in combat, which the checks flip to see who redraws.
	---@param anchor string
	---@param label string
	local function Entry(anchor, label)
		local entry = TRB.Functions.Settings:LoadDefaultOtherBarTextSettings(anchor, label, "$inCombat", "CENTER", 12, true)
		entry.text = label .. "=$inCombat"
		return entry
	end
	local screenA, castbarB, screenC, resourceD = Entry("UIParent", "a"), Entry("CastBar", "b"), Entry("UIParent", "c"), Entry("Resource", "d")
	local list = { screenA, castbarB, screenC, resourceD }
	displayText.barText = list

	---Rebuilds the text frames as the options do after the entry list changes.
	local function Rebuild()
		TRB.Data.activeVariables = nil
		BarText:CreateBarTextFrames()
	end
	---@param refreshText boolean?
	local function Pass(refreshText)
		TRB.Data.lookupDirty = true
		BarText:UpdateResourceBarText(settings, refreshText ~= false)
	end
	---@param inCombat boolean
	---@param refreshText boolean?
	local function Combat(inCombat, refreshText)
		TRB.Data.character.inCombat = inCombat
		Pass(refreshText)
	end
	---@param index integer
	---@return string
	local function Text(index)
		local frame = TRB.Frames.textFrames[index]
		return frame ~= nil and frame.font ~= nil and frame.font:GetText() or ""
	end
	---Whether an entry's text frame reads its label with this combat state.
	---@param index integer
	---@param label string
	---@param inCombat boolean
	local function Reads(index, label, inCombat)
		return string.find(Text(index), label .. "=" .. tostring(inCombat), 1, true) ~= nil
	end
	---@param index integer
	local function Blank(index)
		TRB.Frames.textFrames[index].font:SetText("")
	end
	---@param groupKey string
	---@param shown boolean
	local function ShowGroup(groupKey, shown)
		local group = barGroups[groupKey]
		if shown then
			group:Show()
			group:GetNode(1):Show()
		else
			group:Hide()
		end
	end

	ShowGroup("primary", true)
	ShowGroup("castbar", false)
	Rebuild()
	Combat(false)
	check("entries on the screen and on a showing bar draw", Reads(1, "a", false) and Reads(3, "c", false) and Reads(4, "d", false),
		Text(1) .. " | " .. Text(3) .. " | " .. Text(4))
	check("an entry on a hidden bar is not drawn", Text(2) == "", Text(2))

	Combat(true)
	check("a changed value redraws every showing entry", Reads(1, "a", true) and Reads(3, "c", true) and Reads(4, "d", true))
	check("a changed value leaves the hidden bar's entry alone", Text(2) == "", Text(2))

	-- Hide and show.
	ShowGroup("castbar", true)
	Pass()
	check("a bar that shows draws its entry", Reads(2, "b", true), Text(2))
	Blank(2)
	Pass()
	check("an unchanged entry on a showing bar is not rewritten", Text(2) == "", Text(2))
	ShowGroup("castbar", false)
	Pass()
	ShowGroup("castbar", true)
	Pass()
	check("a bar that hid and shows again rewrites its entry, unchanged or not", Reads(2, "b", true), Text(2))
	ShowGroup("primary", false)
	Combat(false)
	check("a hidden main bar's entry holds its text", Reads(4, "d", true) and Reads(1, "a", false), Text(4))
	ShowGroup("primary", true)
	Pass()
	check("the main bar's entry catches up when the bar shows", Reads(4, "d", false), Text(4))

	-- A fading cast bar holds its text.
	local castbar = TRB.Functions.Castbar
	castbar.fadeOutStart = 1
	check("the cast bar reads as fading", castbar:IsFadingOut() == true)
	Combat(true)
	check("text on a fading bar holds its last value", Reads(2, "b", false) and Reads(1, "a", true), Text(2))
	castbar.fadeOutStart = nil
	Pass()
	check("text on the bar updates once the fade ends", Reads(2, "b", true), Text(2))
	-- The pass after a self-driven bar ends is forced through, so spend it before the next checks.
	Pass()

	-- Only screen text is drawn while no bar renders.
	Combat(false, false)
	check("screen text draws while no bar renders", Reads(1, "a", false) and Reads(3, "c", false))
	check("bar text waits while no bar renders", Reads(4, "d", true) and Reads(2, "b", true), Text(4) .. " | " .. Text(2))
	Pass()
	check("bar text catches up on the next rendered pass", Reads(4, "d", false) and Reads(2, "b", false))

	-- The Enabled checkbox: the options clear the active variables.
	screenC.enabled = false
	TRB.Data.activeVariables = nil
	Combat(true)
	check("a disabled entry stops drawing", Reads(3, "c", false) and Reads(1, "a", true), Text(3))
	screenC.enabled = true
	TRB.Data.activeVariables = nil
	Pass()
	check("an entry enabled again draws", Reads(3, "c", true), Text(3))

	-- Bound to Bar: the options reposition the one entry.
	ShowGroup("castbar", false)
	Pass()
	castbarB.position.relativeToFrame = "UIParent"
	check("an entry moved to the screen repositions", BarText:RepositionBarTextEntry(2) == true)
	Combat(false)
	check("an entry moved from a hidden bar to the screen draws", Reads(2, "b", false), Text(2))
	castbarB.position.relativeToFrame = "CastBar"
	BarText:RepositionBarTextEntry(2)
	Combat(true)
	check("an entry moved back to the hidden bar stops drawing", Reads(2, "b", false) and Reads(1, "a", true), Text(2))

	-- A new entry: the options rebuild the text frames.
	local screenE = Entry("UIParent", "e")
	list[#list + 1] = screenE
	Rebuild()
	Pass()
	check("an added entry draws", Reads(5, "e", true), Text(5))
	check("the entries before it draw again after the rebuild", Reads(1, "a", true) and Reads(3, "c", true) and Reads(4, "d", true))

	-- Entries reordered in place, which only the text frame rebuild announces.
	list[1], list[5] = list[5], list[1]
	BarText:CreateBarTextFrames()
	Pass()
	check("entries reordered in place draw in their new places", Reads(1, "e", true) and Reads(5, "a", true), Text(1) .. " | " .. Text(5))
	list[1], list[5] = list[5], list[1]
	Rebuild()
	Pass()

	-- Another list of the same length, as a recomposed display text is.
	local swapped = { Entry("UIParent", "v"), Entry("UIParent", "w"), Entry("UIParent", "x"), Entry("UIParent", "y"), Entry("UIParent", "z") }
	displayText.barText = swapped
	Combat(false)
	check("a replaced list of the same length draws its own entries",
		Reads(1, "v", false) and Reads(2, "w", false) and Reads(3, "x", false) and Reads(4, "y", false) and Reads(5, "z", false),
		Text(1) .. " | " .. Text(2))
	displayText.barText = list
	Rebuild()
	Pass()

	-- A reset frame cache, as a form change leaves it: every showing entry is written again.
	Blank(1)
	Blank(4)
	Pass()
	check("unchanged entries are not rewritten", Text(1) == "" and Text(4) == "")
	TRB.Data.cache.values.frame = {}
	Pass()
	check("a reset frame cache rewrites every showing entry", Reads(1, "a", false) and Reads(4, "d", false), Text(1) .. " | " .. Text(4))

	-- The width limit follows the bound bar's width on every pass.
	resourceD.constrainToParent = true
	resourceD.maxWidthPercent = 50
	Rebuild()
	local frame = TRB.Frames.textFrames[4]
	local parent = frame:GetParent()
	parent:SetWidth(200)
	Pass()
	check("a width limit takes the bound bar's width", frame.font.trbConstrainWidth == 100, frame.font.trbConstrainWidth)
	parent:SetWidth(300)
	Pass(false)
	check("a width limit follows the bar's width while no bar renders", frame.font.trbConstrainWidth == 150, frame.font.trbConstrainWidth)

	print(string.format("DRIVER bartext-display-list: %d failures", errors))
	return errors
end

return hooks
