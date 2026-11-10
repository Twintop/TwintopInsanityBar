-- Checks Preview Mode: every bar that isn't Never Show goes up, each Bar Text Area writes its name, a drag saves
-- the stack's offsets against its own anchor, Edit Mode stacks are locked, and combat or Edit Mode ends it.
local desktop = _G --[[@as table<string, any>]]
local parity = desktop.require("drivers.parity")

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
	-- Brewmaster's and Evoker's ticks read these.
	desktop.UnitStagger = function() return 0 end
	desktop.UnitPartialPower = function() return 0 end
end

-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
function hooks.afterLoad(ctx)
	ctx.TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local stubs = ctx.stubs
	local errors = 0
	local function check(label, ok)
		print((ok and "PASS " or "FAIL ") .. label)
		if not ok then
			errors = errors + 1
		end
	end
	local function Drain(label)
		for i = 1, 20 do
			local _, timerFailures = stubs.fireEvents("TRB_DRAIN_" .. label .. "_" .. i, ctx.addonName)
			if timerFailures == 0 then
				return
			end
		end
	end

	TRB.Functions.Bar.UpdateHealthBar = function() end
	TRB.Functions.Class.TriggerResourceBarUpdates = function() end
	stubs.fireEvents(parity.releaseEvent, ctx.addonName)
	Drain("SETUP")

	local Preview = TRB.Functions.Preview
	local Bar = TRB.Functions.Bar
	local EditMode = TRB.Functions.EditMode
	local L = TRB.Localization
	local barGroups = TRB.Frames.barGroups
	local cache = TRB.Data.specCache[TRB.Data.character.compositeKey]
	if not TRB.Data.specSupported or barGroups == nil or barGroups.primary == nil or cache == nil then
		check("a spec without bars has nothing to preview", not Preview:IsActive())
		print(string.format("DRIVER preview-mode: %d failures", errors))
		return
	end
	local settings = cache.settings

	-- The handles are local to the module, so collect them as they are made.
	local handles = {}
	local createFrame = desktop.CreateFrame
	desktop.CreateFrame = function(frameType, ...)
		local frame = createFrame(frameType, ...)
		if frameType == "Button" then
			handles[#handles + 1] = frame
		end
		return frame
	end
	local function BarHandles()
		local byKey = {}
		for _, frame in ipairs(handles) do
			if rawget(frame, "kind") == "bar" then
				byKey[rawget(frame, "barKey")] = frame
			end
		end
		return byKey
	end

	local heard = nil
	Preview:AddListener(function(active) heard = active end)

	check("Preview Mode starts off", not Preview:IsActive() and not EditMode:IsShowingAllBars())
	Preview:SetActive(true)
	Drain("ENTER")
	Bar:HideResourceBar()
	check("turning it on is heard", Preview:IsActive() and heard == true and EditMode:IsShowingAllBars())

	local barKeyToRoot = barGroups.barKeyToRoot
	local allShown, allHandled = true, true
	local byKey = BarHandles()
	local keyCount = 0
	for barKey in pairs(barKeyToRoot) do
		keyCount = keyCount + 1
		local group = barGroups[barKey]
		local neverShow = Bar:IsBarNeverShow(settings, barKey)
		local hasNodes = barKey ~= "secondary" or (TRB.Data.character.maxResource2 or 0) > 0
		if hasNodes and group.isVisible ~= not neverShow then
			allShown = false
			print("  " .. barKey .. " visible=" .. tostring(group.isVisible) .. " neverShow=" .. tostring(neverShow))
		end
		local handle = byKey[barKey]
		if handle == nil or not handle:IsShown() or handle:GetParent() ~= group.containerFrame then
			allHandled = false
			print("  no handle on " .. barKey)
		end
	end
	check("the layout names each bar's stack", keyCount > 0)
	check("every bar shows unless it is Never Show", allShown)
	check("every bar has a handle on its container", allHandled)

	-- Bar text: each enabled area on a showing anchor reads as its name.
	TRB.Data.barTextVisibilityRefreshNeeded = true
	local textOk, textError = pcall(TRB.Functions.BarText.UpdateResourceBarText, TRB.Functions.BarText, settings, true)
	check("bar text renders in Preview Mode" .. (textOk and "" or (": " .. tostring(textError))), textOk)
	local named, misnamed = 0, 0
	for i, entry in ipairs(settings.displayText.barText) do
		local frame = TRB.Frames.textFrames[i]
		if entry.enabled and frame ~= nil and frame:IsShown() and frame.font ~= nil then
			local name = (entry.name ~= nil and entry.name ~= "") and entry.name or L["BarText"]
			local text = frame.font:GetText() or ""
			if text ~= "" then
				if text:sub(1, 2) == "|c" and text:sub(-#name) == name then
					named = named + 1
				else
					misnamed = misnamed + 1
					print("  area " .. i .. " reads " .. text)
				end
			end
		end
	end
	check("every written Bar Text Area reads as its name (" .. named .. ")", misnamed == 0)

	-- Drag a movable stack 30 right and 25 down.
	local dragHandle = nil
	for _, handle in pairs(byKey) do
		if rawget(handle, "lockReason") == nil then
			dragHandle = handle
			break
		end
	end
	check("a screen-anchored stack can be dragged", dragHandle ~= nil)
	if dragHandle ~= nil then
		local rootBarKey = rawget(dragHandle, "rootBarKey")
		local wrapper = EditMode:GetWrapperFrame(rootBarKey)
		local centerX, centerY = 400, 300
		rawset(wrapper, "GetCenter", function() return centerX, centerY end)
		-- The client re-anchors a dropped frame to the nearest screen region; the save must not read it.
		rawset(wrapper, "GetPoint", function() return "TOPRIGHT", nil, "TOPRIGHT", -777, -888 end)
		local anchor = Bar:GetBarAnchor(barGroups.layoutSettings, rootBarKey)
		local startX, startY = anchor.xOffset or 0, anchor.yOffset or 0
		local sliderX, sliderY = nil, nil
		Preview:RegisterPositionSliders(anchor, { SetValue = function(_, value) sliderX = value end }, { SetValue = function(_, value) sliderY = value end })

		dragHandle:GetScript("OnDragStart")(dragHandle)
		centerX, centerY = centerX + 30, centerY - 25
		dragHandle:GetScript("OnDragStop")(dragHandle)
		Drain("DROP")

		local saved = Bar:GetBarAnchor(barGroups.layoutSettings, rootBarKey)
		check("a drop moves the saved offsets by the distance dragged", saved == anchor and saved.xOffset == startX + 30 and saved.yOffset == startY - 25)
		check("the stack stays anchored to the screen", saved.barKey == "screen")
		check("open position sliders follow the drop", sliderX == startX + 30 and sliderY == startY - 25)
		local owner = Bar:GetBarSettings(barGroups.layoutSettings, rootBarKey)
		check("the legacy position follows the drop", owner.xPos == saved.xOffset and owner.yPos == saved.yOffset)

		-- A stack Edit Mode positions is locked.
		local isLayoutEnabled = EditMode.IsLayoutEnabled
		EditMode.IsLayoutEnabled = function() return true end
		Preview:Refresh()
		local allLocked = true
		for _, handle in pairs(BarHandles()) do
			if handle:IsShown() and rawget(handle, "lockReason") ~= L["PreviewModeEditModeTooltip"] then
				allLocked = false
			end
		end
		check("every bar of an Edit Mode stack is locked", allLocked)
		dragHandle:GetScript("OnDragStart")(dragHandle)
		centerX = centerX + 50
		dragHandle:GetScript("OnDragStop")(dragHandle)
		check("a locked stack does not move", saved.xOffset == startX + 30 and saved.yOffset == startY - 25)
		EditMode.IsLayoutEnabled = isLayoutEnabled
		Preview:Refresh()
		check("the lock lifts with Edit Mode's setting", rawget(dragHandle, "lockReason") == nil)
	end

	-- A click opens the tab that positions the bar, on Global Options when that owns its anchor.
	local Tabs = TRB.Functions.OptionsUi.Tabs
	local openBarTab = Tabs.OpenBarTab
	local opened = {}
	Tabs.OpenBarTab = function(_, classId, specId, barKey)
		opened[barKey] = { classId = classId, specId = specId }
	end
	local clicksOk = true
	for barKey, handle in pairs(BarHandles()) do
		if handle:IsShown() then
			handle:GetScript("OnMouseDown")(handle)
			handle:GetScript("OnClick")(handle)
			local coreSettings = Bar:GetBarSettings(TRB.Data.settings.core, barKey)
			local anchor = Bar:GetBarAnchor(barGroups.layoutSettings, barKey)
			local global = anchor ~= nil and coreSettings ~= nil and rawget(coreSettings, "anchor") == anchor
			local call = opened[barKey]
			if call == nil or (call.classId == nil) ~= global or (not global and call.specId ~= TRB.Data.character.specId) then
				clicksOk = false
				print("  click on " .. barKey .. " opened " .. tostring(call and call.classId))
			end
		end
	end
	check("a click opens the bar's position tab in the scope that owns it", clicksOk)
	Tabs.OpenBarTab = openBarTab
	local navOk, navError = pcall(Tabs.OpenBarTab, Tabs, TRB.Data.character.classId, TRB.Data.character.specId, "primary")
	Drain("NAV")
	check("the spec's bar tab opens" .. (navOk and "" or (": " .. tostring(navError))), navOk)

	-- Combat ends it.
	stubs.fireEvents("PLAYER_REGEN_DISABLED", ctx.addonName)
	Drain("COMBAT")
	local anyHandleShown = false
	for _, handle in pairs(BarHandles()) do
		anyHandleShown = anyHandleShown or handle:IsShown()
	end
	check("entering combat ends Preview Mode", not Preview:IsActive() and heard == false and not EditMode:IsShowingAllBars())
	check("the handles go away with it", not anyHandleShown)

	-- Edit Mode shows every bar itself.
	local isInEditMode = EditMode.IsInEditMode
	EditMode.IsInEditMode = function() return true end
	Preview:SetActive(true)
	check("Preview Mode stays off while Edit Mode is open", not Preview:IsActive())
	EditMode.IsInEditMode = isInEditMode

	Preview:SetActive(true)
	Drain("REENTER")
	EditMode:OnEditModeEnter()
	Drain("EDITMODE")
	check("opening Edit Mode ends Preview Mode", not Preview:IsActive())

	desktop.CreateFrame = createFrame
	print(string.format("DRIVER preview-mode: %d failures", errors))
end

return hooks
