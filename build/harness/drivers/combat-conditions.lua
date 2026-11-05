-- Checks the combat visibility conditions: Show Bar When In Combat and Out of Combat, and Always Hide Bar When In Combat
-- and Out of Combat, on the shared checks every bar outside the cast bars uses.
local desktop = _G --[[@as table<string, any>]]
local debug = desktop.debug
local parity = desktop.require("drivers.parity")

local hooks = {}

function hooks.afterInstall(ctx)
	parity.Install(ctx, { spec = 1, holdDeferredSetup = true })
end

function hooks.afterLoad(ctx)
	-- The News popup needs UI the stubs lack, and its error would stop the deferred setup before optionsPanelFinished.
	ctx.TRB.Functions.News.Init = function() end
end

function hooks.afterEvents(ctx)
	local TRB = ctx.TRB
	local errors = 0
	local function check(label, ok)
		print((ok and "PASS " or "FAIL ") .. label)
		if not ok then
			errors = errors + 1
		end
	end
	local function try(label, fn)
		local ok, result = xpcall(fn, function(e) return debug.traceback(tostring(e), 2) end)
		if not ok then
			errors = errors + 1
			print("DRIVER ERROR " .. label .. "\n    " .. tostring(result):gsub("\n", "\n    "))
			return nil
		end
		return result
	end

	local BarVisibility = TRB.Functions.BarVisibility
	local inCombat = TRB.Classes.BarVisibilityContext:New({ inCombat = true })
	local outOfCombat = TRB.Classes.BarVisibilityContext:New({ inCombat = false })
	local function Hidden(context, hideConditions)
		return try("ShouldForceHideBar", function()
			return BarVisibility:ShouldForceHideBar(context, { visibilitySettings = { hideConditions = hideConditions } })
		end)
	end
	local function Shown(context, conditions)
		return try("MatchesShowConditions", function()
			return BarVisibility:MatchesShowConditions(context, conditions)
		end)
	end

	local defaults = TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions()
	check("the hide defaults carry both combat keys, off", defaults.inCombat == false and defaults.outOfCombat == false)

	check("Hide In Combat hides in combat", Hidden(inCombat, { inCombat = true }) == true)
	check("and not out of combat", Hidden(outOfCombat, { inCombat = true }) == false)
	check("Hide Out of Combat hides out of combat", Hidden(outOfCombat, { outOfCombat = true }) == true)
	check("and not in combat", Hidden(inCombat, { outOfCombat = true }) == false)
	check("neither ticked hides nothing", Hidden(inCombat, defaults) == false and Hidden(outOfCombat, defaults) == false)

	check("Show Out of Combat shows out of combat", Shown(outOfCombat, { outOfCombat = true }) == true)
	check("and not in combat", Shown(inCombat, { outOfCombat = true }) == false)
	check("Show In Combat still shows in combat only", Shown(inCombat, { inCombat = true }) == true and Shown(outOfCombat, { inCombat = true }) == false)

	return errors
end

return hooks
