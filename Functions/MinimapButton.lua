local _, TRB = ...
local L = TRB.Localization

TRB.Functions = TRB.Functions or {}
TRB.Functions.MinimapButton = {}

local ADDON_NAME = "TwintopResourceBar"
local ICON_TEXTURE = 1386550 -- Same as ## IconTexture in TOC

local ldb = LibStub("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0")

local dataObject = ldb:NewDataObject(ADDON_NAME, {
	type = "launcher",
	text = "Twintop's Resource Bar",
	icon = ICON_TEXTURE,
	OnClick = function(_, button)
		if button == "LeftButton" then
			if InCombatLockdown() then
				print(L["CannotOpenOptionsInCombat"])
				return
			end
			TRB.Options.OptionsFrame:Show()
			if TRB.Data.barConstructedForSpec ~= nil then
				TRB.Options.OptionsFrame:SelectCategory(TRB.Data.barConstructedForSpec)
			else
				TRB.Options.OptionsFrame:SelectCategory("main")
			end
		end
	end,
	OnTooltipShow = function(tooltip)
		tooltip:AddLine(TRB.Details.addonTitle)
		tooltip:AddLine(L["MinimapTooltipLeftClick"], 1, 1, 1)
	end,
})

---Initialize the minimap button using saved settings
function TRB.Functions.MinimapButton:Initialize()
	local settings = TRB.Data.settings
	if not settings or not settings.core then
		return
	end

	-- Ensure defaults exist
	if settings.core.minimap == nil then
		settings.core.minimap = {
			hide = false,
		}
	end

	-- Migrate from old format
	if settings.core.minimap.shown ~= nil then
		settings.core.minimap.hide = not settings.core.minimap.shown
		settings.core.minimap.shown = nil
		settings.core.minimap.angle = nil
	end

	if not icon:IsRegistered(ADDON_NAME) then
		icon:Register(ADDON_NAME, dataObject, settings.core.minimap)
	end
end

---Show the minimap button and update the saved setting
function TRB.Functions.MinimapButton:Show()
	if TRB.Data.settings and TRB.Data.settings.core and TRB.Data.settings.core.minimap then
		TRB.Data.settings.core.minimap.hide = false
	end
	icon:Show(ADDON_NAME)
end

---Hide the minimap button and update the saved setting
function TRB.Functions.MinimapButton:Hide()
	if TRB.Data.settings and TRB.Data.settings.core and TRB.Data.settings.core.minimap then
		TRB.Data.settings.core.minimap.hide = true
	end
	icon:Hide(ADDON_NAME)
end

---Toggle the minimap button visibility
function TRB.Functions.MinimapButton:Toggle()
	if TRB.Data.settings and TRB.Data.settings.core and TRB.Data.settings.core.minimap then
		if TRB.Data.settings.core.minimap.hide then
			self:Show()
		else
			self:Hide()
		end
	end
end
