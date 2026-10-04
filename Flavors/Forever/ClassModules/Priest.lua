local _, TRB = ...
if TRB.Data.character.classId ~= 5 then -- Only do this if we are on a Priest!
	return
end

-- Priest runtime (World of Warcraft: Forever). The runtime template installs the resource, health,
-- combo point, bar text and spec-switching behavior for the archetypes declared in Classes\PriestClasses.lua;
-- ability tracking specific to this class is layered on top of the returned runtime table.
local runtime = TRB.Forever.Templates.Runtime:Install("priest")
