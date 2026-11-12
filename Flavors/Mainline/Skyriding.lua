local _, TRB = ...

-- Mainline's skyriding spells, by the role Core's Skyriding bars track them in. Loads after Core's spell classes and
-- before Core\Functions\Skyriding.lua reads them.

TRB.Flavor.skyriding.spells = {
	-- Skyward Ascent spends the same charges.
	surgeForward = TRB.Classes.SpellBase:New({
		id = 372608,
		hasCharges = true,
		ignoreGcdLock = true
	}),
	secondWind = TRB.Classes.SpellBase:New({
		id = 425782,
		hasCharges = true,
		ignoreGcdLock = true
	}),
	whirlingSurge = TRB.Classes.SpellBase:New({
		id = 361584,
		hasCooldown = true,
		ignoreGcdLock = true
	}),
	-- Its choice node swaps it in for Whirling Surge.
	lightningRush = TRB.Classes.SpellBase:New({
		id = 418592,
		hasCooldown = true,
		ignoreGcdLock = true
	}),
	thrillOfTheSkies = TRB.Classes.SpellBase:New({
		id = 377234,
		isBuff = true
	}),
	-- The copy that the second Skyriding aura (1227904) swaps in.
	thrillOfTheSkiesAlt = TRB.Classes.SpellBase:New({
		id = 1227961,
		isBuff = true
	}),
	groundSkimming = TRB.Classes.SpellBase:New({
		id = 404184,
		isBuff = true
	}),
	-- Lightning Rush needs a full stack of Static Charge.
	staticCharge = TRB.Classes.SpellBase:New({
		id = 418590,
		isBuff = true,
		maxStacks = 10
	}),
}
