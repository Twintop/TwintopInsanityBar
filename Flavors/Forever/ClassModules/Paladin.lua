local _, TRB = ...
if TRB.Data.character.classId ~= 2 then -- Only do this if we are on a Paladin!
	return
end

-- Paladin runtime (World of Warcraft: Forever). The runtime template installs the resource, health,
-- combo point, bar text and spec-switching behavior for the archetypes declared in Classes\PaladinClasses.lua;
-- ability tracking specific to this class is layered on top of the returned runtime table.
local runtime = TRB.Forever.Templates.Runtime:Install("paladin")
