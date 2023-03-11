---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.News = {}
local LMD = LibStub("LibMarkdown-1.0")
local oUi = TRB.Data.constants.optionsUi

local content = [====[
# 10.1.0.0-beta01 (2023-03-11)
## General

- (#292 - UPDATE) Updates to the bar to make it usable. Not all modifications are complete / this is a work in progress!

## Druid
### Balance
- (#292 - UPDATE) 10.1.0 changes:
<br/>&emsp;&ensp;- Baseline Astral Power adjustments for Wrath, Starfire, and Stellar Flare.
<br/>&emsp;&ensp;- Soul of the Forest only increases Wrath's incoming Astral Power by 50%. *Starfire support TBD.*
<br/>&emsp;&ensp;- Nature's Balance passive Astral Power generation values updated. *Bar may not hide properly in all situations.*
<br/>&emsp;&ensp;- Elune's Guidance Astral Power reduction to Starsurge and Starfall updated.

### Feral

- (#292 - UPDATE) 10.1.0 changes:
<br/>&emsp;&ensp;- Relentless Predator's Energy modifier for Ferocious Bite updated to 80% (was 60%).

## Priest
### Shadow

- (#292 - UPDATE) 10.1.0 changes:
<br/>&emsp;&ensp;- Remove old spells/abilities: Dark Void, Mind Sear, Surge of Darkness, and Piercing Shadows.
<br/>&emsp;&ensp;- Baseline Insanity adjustments for Void Torrent, Mind Flay: Insanity, Auspicious Spirits, and Void Tendril + Void Lasher.
<br/>&emsp;&ensp;- Remove Mind Melt from granting an instant Mind Blast.
<br/>&emsp;&ensp;- Remove "spending" bar color config.
<br/>&emsp;&ensp;- Remove all references to Mind Sear.
<br/>&emsp;&ensp;- Voidtouched support works automagically, allowing maximum Insanity to be 150.
<br/>&emsp;&ensp;- Add Mind's Eye support, reducing Devouring Plague's cost from 50 -> 45.
<br/>&emsp;&ensp;- Add Mind Spike: Insanity support.


<br/>
# 10.0.7.0-release (2023-03-21)
## Priest
### Shadow

- (#273 - UPDATE) Auspicious Spirits once again generate Insanity on hit instead of on spawn.

# 10.0.5.9-release (2023-03-11)
## General

- (#219 - UPDATE) Add detection support for the first boss of Mogu'shan Palace -- Kuai the Brute, Ming the Cunning, and Haiyan the Unstoppable @ 10% each.

## Priest
### Shadow

- (#288 - UPDATE) Add an option to disable bar color change when Mind Blast can be instantly cast.
- (FIX) Update Mind Flay: Insanity bar text icon detection.
- (UPDATE) Do some minor rearranging of the options menu for bar colors. This layout change (or one like it) will be applied to other option screens and more configurations will be added soon (tm)!

<br/>
# 10.0.5.8-release (2023-03-05)
## General

- (#278 - NEW) Add a news popup to be shown whenever a new version of the bar is released. This will contain (predominantly) the release notes for new versions of the bar.<br/><br/>
- (#219 - UPDATE) Add an alternate detection method for the poisoning of the Flask of Solemn Night in Court of Stars.

## Druid
### Restoration

- (#291 - NEW) Add support for Incarnation: Tree of Life bar color change. This works similarly to other bar color changes via buffs (e.g. Voidform, Trueshot, Eclipse, etc.) with colors for both when it is active and when it is close to ending, and configuration of when to show the close to ending color.
<br/>&emsp;&ensp;- New bar text variable: `$incarnationTime`
<br/>&emsp;&ensp;- New bar text icon: `#incarnation`<br/><br/>
- (#291 - NEW) Add Reforestation tracking.
<br/>&emsp;&ensp;- New bar text variable: `$reforestationStacks`
<br/>&emsp;&ensp;- New bar text icon: `#reforestation`

## Priest
### Shadow

- (#288 - NEW) Add a bar color change while Mind Blast is instant cast either via a Shadowy Insight proc or having two stacks of Mind Melt. This will only change the bar color if you can currently cast Mind Blast (it isn't completely on cooldown).
<br/>&emsp;&ensp;- New bar text variables: `$mmTime`, `$mmStacks`, `$siTime`, `$mindBlastCharges`, `$mindBlastMaxCharges`
<br/>&emsp;&ensp;- New bar text icons: `#mm`/`#mindMelt`, `#si`/`#shadowyInsight`

<br/>
# 10.0.5.7-release (2023-02-28)
## General

- (#219 - NEW) For targets that are "defeated" at a health other than 0% can now have an override "death" percent to provide more accurate time to die estimates. For current content this includes:
<br/>&emsp;&ensp;- Shadowmoon Burrial Grounds: Carrion Worm (trash/before Bonemaw) -- 20%
<br/>&emsp;&ensp;- Court of Stars: Patrol Captain Gerdo (if Flask of the Solemn Night is poisoned) -- 25%
<br/>&emsp;&ensp;- Trial of Valor: Hymdall -- 10%; Fenryr (phase 1) -- 60%; Odyn -- 80%
<br/>&emsp;&ensp;- Brackenhide Hollow: Decatriarch Wratheye -- 4.5%

## Healers<br/>
- (#265 - UPDATE) Add an option to hide the threshold line of Conjured Chillglobe while it is on cooldown.

## Priest
### Holy

- (#282 - NEW) Add threshold line showing how much mana would be gained by using Shadowfiend. This is separate and in addition to the passive threshold line that shows when Shadowfiend is actively attacking and regenerating mana. This also includes an option to hide the threshold line while Shadowfiend is on cooldown.<br/>
- (#282 - FIX) Adjust the logic around detecting Shadowfiend swings for Holy to get more accurate predictions.

## Shaman
### Elemental

- (#290 - HOTFIX) Frost Shocks that are buffed by Icefury now generate 14 Maelstrom.

<br/>
# 10.0.5.6-release (2023-02-24)
## General

- (FIX) Correct the layout for bar text instructions.

## Druid
### Feral

- (#286 - NEW) Add a new bar border color change and bar text variable, `$inStealth`, for when you are in stealth or have a proc/effect that allows you to act as if you were stealthed.

## Priest
### Shadow

- (#284 - FIX) Update Insanity generated per tick from Void Lashers and Void Tentacles to 2 Insanity.

## Rogue
### Assassination

- (#286 - NEW) Add a new bar border color change and bar text variable, `$inStealth`, for when you are in stealth or have a proc/effect that allows you to act as if you were stealthed.

### Outlaw

- (#286 - NEW) Add a new bar border color change and bar text variable, `$inStealth`, for when you are in stealth or have a proc/effect that allows you to act as if you were stealthed.

## Shaman
### Elemental

- (#287 - FIX) Only play the audio cue for Earth Shock once instead of forever. Dingdingindingdingdingnindging!

## Warrior
### Arms

- (#289 - FIX) Prevent LUA errors from sometimes triggering when Deep Wounds is applied.

<br/>
# 10.0.5.5-release (2023-02-21)
## General

- (#283 - EXPERIMENTAL) Experimental/minimal support for Enhancement Shaman.<br/>
- (#87 - REFACTOR) Lots of under the hood changes in preparation for future bar text and layout improvements. Stay tuned! 

## Shaman
### Enhancement

- This feature is EXPERIMENTAL and is not enabled by default. To enable Enhancement Shaman support, go to the main "General" options menu for Twintop's Resource Bar and check "Enhancement Shaman support" under the "Experimental Features" section then reload your UI!<br/>
- (#283 - EXPERIMENTAL) Minimalist implementation for Enhancement Shaman, tracking Maelstrom Weapon stacks and Mana (to a much lesser extent). Presently displays Maelstrom Weapon in a similar fashion as Combo Points or Chi, tracks Ascendance (with mana bar color changing), and Flame Shock target count/duration.

<br/>
# 10.0.5.4-release (2023-02-02)
## Evoker
### Preservation

- (FIX) Remove spammy debug prints from chat window.

<br/>
# 10.0.5.3-release (2023-02-01)
## General

- (FIX) Prevent invalid bar border sizes from being allowed via options UI.

## Evoker

- (FIX) Fix LUA errors related to options menus.

<br/>
# 10.0.5.2-release (2023-02-01)
## General

- (#259 - EXPERIMENTAL) Experimental/minimal support for Devastation Evoker.<br/>
- (#280 - EXPERIMENTAL) Experimental support for Preservation Evoker.<br/>
- (FIX) Change how resetting specialization configuration to defaults work. Previously, some configuration resets were not reliably resetting to default values.

## Druid
### Balance

- (FIX) Ensure Starsurge and Starfall threshold lines adjust correctly when Rattle the Stars is up.

## Evoker
### Devastation

- This feature is EXPERIMENTAL and is not enabled by default. To enable Devastation Evoker support, go to the main "General" options menu for Twintop's Resource Bar and check "Devastation Evoker support" under the "Experimental Features" section.<br/>
- (#259 - EXPERIMENTAL) Minimalist implementation for Devastation Evoker, tracking Essence and Mana (to a much lesser extent). Presently displays Essence in a similar fashion as Combo Points or Chi, but shows the refill status in the currently regenerating node.

### Preservation

- This feature is EXPERIMENTAL and is not enabled by default. To enable Devastation Evoker support, go to the main "General" options menu for Twintop's Resource Bar and check "Devastation Evoker support" under the "Experimental Features" section.<br/>
- (#280 - EXPERIMENTAL) Experimental implementation for Devastation Evoker, tracking Essence and Mana. Currently supports the same generic healer tracking capabilities as the other supported healing specializations: Innervate, Mana Tide Totem, Symbol of Hope, mana potions, Chillglobe, etc. Additional support has been added for mana regeneration via Emerald Communion.

## Shaman
### Elemental

- (FIX) Prevent a LUA error when switching to Elemental from another specialization.

<br/>
# 10.0.5.1-release (2023-01-28)
## General
### DPS

- (#194 - NEW) Abilities which are unusable due to being out of range now have a new optional threshold line color. 

### Healing

- (#277 - NEW) For supported healing specs: add new bar border color change, passive incoming (regen) mana, and bar text ($potionOfChilledClarityTime and $potionOfChilledClarityMana) when Potion of Chilled Clarity has been used. This behaves almost exactly like Innervate's implementation and superceeds it in priority.<br/>
- (UPDATE) Fix some issues with Innervate bar text variables and logic checks.

## Demon Hunter

- (#274 - NEW) Add a new special threshold line color change to Chaos Strike/Annihilation when the Chaos Theory buff is active.

## Hunter
### General

- (UPDATE) Removed Pandemic DoT color for Serpent Sting as this DoT does not follow traditional Pandemic refresh rules.

### Beast Mastery

- (#248 - NEW) Add support for multiple Kill Command charges via the class talent Alpha Predator.<br/>
- (#248 - NEW) Add support for the PvP talent Dire Beast: Basilisk. This has an additional threshold line which will only show up when actively engaged in PvP, warmode is on, or in an arena or battleground.<br/>
- (#248 - NEW) Add support for the PvP talent Dire Beast: Hawk. This has an additional threshold line which will only show up when actively engaged in PvP, warmode is on, or in an arena or battleground.

### Marksmanship

- (#249 - NEW) Add support for multiple Kill Command charges via Alpha Predator.<br/>
- (#249 - NEW) Add support for the PvP talent Sniper Shot. This has an additional threshold line which will only show up when actively engaged in PvP, warmode is on, or in an arena or battleground.

<br/>
# 10.0.5.0-release (2023-01-25)
## General

- (#271 - NEW) Threshold icons can now have the option to be shown as desaturated when an the associated ability is not usable.<br/>
- (#264 - UPDATE) Adjust existing and add new interactions for the changes in patch 10.0.5.<br/>
- (#271 - UPDATE) Under the hood refactoring to threshold lines. Behavior should be identical to before but if there are any regressions or changes please open an issue on GitHub!

## Druid
### Balance

- (#264 - UPDATE) Remove Circle of Life and Death.

### Feral

- (#264 - UPDATE) Change Rip, Thrash, and Swipe's baseline/talent/ability statuses.<br/>
- (#264 - UPDATE) Update Relentless Predator's to reduce the cost of associated abilities by 40%.

## Priest
### Shadow

- (#264 - UPDATE) Mindgames and Halo both generate 10 Insanity on cast.<br/>
- (#272 - BUG) When talented in to Auspicious Spirits, update Mind Blast's incoming Insanity value to include the number of Auspicious Spirits it will spawn and produce Insanity. This is due to a bug (?) in 10.0.x where Auspicious Spirits are granting Insanity on spawn rather than the intended (historical back to 5.x?) on hit.

## Rogue
### Assassination

- (#253 - NEW) Add Tight Spender support.<br/>
- (#253 - NEW) Add Lightweight Shiv support.<br/>
- (#253 - NEW) Add Improved Garrote support. There is a new "special" threshold line color configuration option that will be used when Improved Garrote's effect is active.<br/>
- (#270 - NEW) Add option to use the same background for all unfilled combo points instead of ability-specific (e.g. Echoing Reprimand) background coloring.<br/>
- (#264 - UPDATE) Feint is now a baseline ability and not a talent.<br/>
- (#264 - UPDATE) Update Sepsis behavior and associated stealth ability usage.

### Outlaw

- (#254 - NEW) Add Tight Spender support.<br/>
- (#270 - NEW) Add option to use the same background for all unfilled combo points instead of ability-specific (e.g. Echoing Reprimand) background coloring.<br/>
- (#264 - UPDATE) Feint is now a baseline ability and not a talent.<br/>
- (#264 - UPDATE) Update Sepsis behavior and associated stealth ability usage.

## Warrior
### Arms

- (#264 - NEW) Add Ignore Pain threshold line.<br/>
- (#264 - UPDATE) Storm of Swords now increases Whirlwind's Rage cost by 20.

### Fury

- (#264 - UPDATE) Storm of Steel now increases Ravager's Rage generation by 20.

<br/>
# 10.0.2.7-release (2023-01-17)
## Demon Hunter
### Havoc

- (#243 - UPDATE) Change Prepared's logic to be related to Tactical Retreat instead.<br/>
- (#243 - FIX) Restore icon listing to bar text flyout in options.<br/>
- (#243 - FIX) Adjust Furious Throws behavior.

## Druid
### Balance

- (#245 - FIX) Fix LUA errors associated with Primordial Arcanic Pulsar bar text.

## Hunter
### Beast Mastery

- (#248 - NEW) Add Aspect of the Wild support for reducing the Focus cost of Cobra Shot.<br/>
- (#248 - NEW) Add Dire Pack support for reducing the Focus cost of Kill Command (needs testing/verification).<br/>
- (#248 - FIX) Update the spell id associated with Cobra Sting's buff.

## Priest
### Holy

- (#266 - NEW) Add passive mana regen from Shadowfiend.

## Shaman
### Elemental

- (#255 - NEW) Add Ascendance bar color change and bar text variables. As with other major cooldown-related bar colors, configuration options exist to give a different warning color when the buff is close to expiring.

### Restoration

- (#256 - NEW) Add Ascendance bar color change and bar text variables. As with other major cooldown-related bar colors, configuration options exist to give a different warning color when the buff is close to expiring.

## Warrior
### Arms

- (#257 - NEW) Add Bloodletting support for bleed pandemic timings.<br/>
- (#257 - NEW) Add support for Battlelord reducing Rage costs for Mortal Strike and Cleave.

### Fury

- (#258 - NEW) Support Storm of Steel increasing Ravager's Rage generation.<br/>
- (#258 - UPDATE) Improve Execute implementation by supporting Sudden Death and Improved Execute; re-add threshold lines.

<br/>
# 10.0.2.6-release (2023-01-11)
## General

- (#267 - NEW) Added $inCombat as a bar text variable that is TRUE when you are currently enaged in combat.<br/>
- (#265 - UPDATE) Update what bonus ids are used to detect Conjured Chillglobe versions.<br/>
- (UPDATE) The listing of currently supported specs has been corrected.

## Druid
### Balance

- (#245 - NEW) Add Circle of Life and Death support for showing pandemic range for DoTs.

### Feral

- (#246 - FIX) Restore overcapping border color picker to options menu.

## Monk
### Mistweaver

- (#251 - NEW) Add Soothing Mist mana cost per tick.

<br/>
# 10.0.2.5-release (2023-01-08)
## General

- (#265 - NEW) Add support for Conjured Chillglobe via threshold line and configuration option for supported healing specs.<br/>
- (FIX) Fixed an issue with some not (!) logic in bar text returning invalid results.<br/>
- (FIX) Correct various typos and layout issues in settings.<br/>
- (UPDATE) Adjust how item icons are accessed and loaded.

## Druid
### Balance

- (#245 - NEW) Add Circle of Life and Death support for calculating pandemic timings for DoTs.

### Feral

- (#246 - NEW) Add Relentless Predator support for Ferocious Bite energy cost calculations.

### Restoration

- (#265 - NEW) Add support for Conjured Chillglobe via threshold line and configuration option.

## Monk
### Mistweaver

- (#265 - NEW) Add support for Conjured Chillglobe via threshold line and configuration option.

## Priest
### Holy

- (#242 - NEW) Add support for T30 2P affecting Holy Word reductions.<br/>
- (#265 - NEW) Add support for Conjured Chillglobe via threshold line and configuration option.<br/>
- (#242 - FIX) Fix logic errors with new bar text variables.

### Shadow

- (#241 - NEW) Mind Flay: Insanity now has an optional border color change when the buff is active.<br/>
- (#241 - NEW) Add Devoured Despair (Idol of Y'Shaarj) passive insanity generation to Mindbender/Shadowfiend.<br/>
- (#241 - FIX) Add Idol of C'Thun icons back in.<br/>
- (#241 - FIX) Death and Madness generates 7.5 Insanity per tick, not 10 Insanity per tick.<br/>
- (#241 - FIX) Correct Auspicious Spirits enable/disable option.<br/>
- (#241 - FIX) Properly track Mind Sear channeling cost, including with a Devouring Plague proc.<br/>
- (#241 - UPDATE) Modify default advanced bar text to include Mind Flay: Insanity

## Shaman
### Restoration

- (#265 - NEW) Add support for Conjured Chillglobe via threshold line and configuration option.

<br/>
# 10.0.2.4-release (2022-12-14)
## Priest
### Holy

- (#242 - FIX) Fix logic errors with new bar text variables.

<br/>
# 10.0.2.3-release (2022-12-14)
## Priest
### Holy

- (#242 - NEW) Add Lightweaver support. This includes bar text variables for stacks and time remaining, border color change when you have any stacks, and an audio cue for when you go from 0 -> 1 stacks.<br/>
- (#242 - UPDATE) Change the priority ordering of bar border color changes for procs to be: Lightweaver < Resonant Words < Surge of Light (1 Stack) < Surge of Light (2 Stacks) < Innervate.

<br/>
# 10.0.2.2-release (2022-12-14)
## General

- (FIX) Options tabs for all specs have had their UI updated.<br/>
- (#263 - UPDATE) Update mana potions for healing specs to use Dragonflight potions instead of Shadowlands. Different ranks are options but rank 3 is selected by default for both Aerated Mana Potion and Potion of Frozen Focus.

## Druid
### Feral

- (#246 - FIX) Update Apex Predator's Craving proc detection.

### Restoration

- (#263 - UPDATE) Update mana potions for Dragonflight.<br/>
- (#247 - UPDATE) Separate logic between border color changes and audio cues when gaining Innervate.

## Monk
### Mistweaver

- (#263 - UPDATE) Update mana potions for Dragonflight.<br/>
- (#251 - UPDATE) Separate logic between border color changes and audio cues when gaining Innervate.

## Priest
### Holy

- (#242 - NEW) Add Resonant Words support: bar border color change, bar text variable for time remaining, and audio cue for proc.<br/>
- (#242 - FIX) Correct Holy Word: Sanctuary cooldown reduction bar color change behavior.<br/>
- (#242 - UPDATE) Add logic to prevent bar color change for Holy Word cooldowns if the associated Holy Word is not talented. <br/>
- (#263 - UPDATE) Update mana potions for Dragonflight.<br/>
- (#242 - UPDATE) Separate logic between border color changes and audio cues when gaining Innervate, Surge of Light procs (1 or 2 stacks), or Resonant Words.

## Rogue
### Assassination

- (#253 - NEW) Add configuration option to disable unfilled Combo Point color for Serrated Bone Spike.

## Shaman
### Restoration

- (#263 - UPDATE) Update mana potions for Dragonflight.<br/>
- (#256 - UPDATE) Separate logic between border color changes and audio cues when gaining Innervate.

<br/>
# 10.0.2.1-release (2022/12/01)
## Priest
### Shadow

- (#241 - FIX) Fix Voidform time remaining to be more accurate and includ extentions due to spent Insanity.

<br/>
# 10.0.2.0-release (2022/11/28)
## General

- (CLEANUP) Removed remaining support for Shadowlands systems: legendaries, covenants, soulbinds, Torghast powers, Sanctum of Domination powers, and M+ affixes <br/>
- (#260, #262 - FIX) Avoid running bar code when a specialization switch has just occurred; add some extra validation for what spec is currently active.

## Hunter
### Beast Mastery

- (FIX) Correct options menu layout.

## Priest

- (#262 - FIX) Stop LUA errors from occurring as Discipline.

## Rogue
### Assassination

- (#261 - FIX) Correct Gouge thresholdline logic to stop crashing when talented.

<br/>
# 10.0.0.15-release (2022/11/18)
## Druid

- (FIX) Remove old options that caused crashes for new bar users.

<br/>
# 10.0.0.14-release (2022/11/11)
## Rogue
### Assassanation

- (#253 - FIX) Fix LUA errors when switching specs with poisons applied.

### Outlaw

- (#260 - FIX) Fix Atrophic Poison related LUA errors.<br/>
- (#260 - FIX) Remove debug prints of current combo points.<br/>
- (#254 - FIX) Fix LUA errors when switching specs with poisons applied.

<br/>
# 10.0.0.13-release (2022/11/11)
## Druid
### Balance

- (#245 - UPDATE) Change Wrath's Astral Power generation to 8 to match hotfixes.

<br/>
# 10.0.0.12-release (2022/11/08)
## Druid
### Balance

- (#245 - FIX) Stop Combo Points from attempting to render and causing LUA errors.

### Feral

- (#246 - FIX) Fix Carnivorous Instinct LUA errors.<br/>
- (#246 - FIX) Add Primal Wrath threshold line toggle to options.

### Restoration

- (#247 - FIX) Stop Combo Points from attempting to render and causing LUA errors.

## Hunter
### Marksmanship

- (#249 - FIX) Fix Steady Shot and Improved Steady Shot's Focus generation amounts causing LUA errors.

## Monk
### Mistweaver

- (#251 - FIX) Stop Chi from attempting to render and causing LUA errors.

### Windwalker

- (#252 - FIX) Fix Strike of the Windlord.

## Priest

- (#241 - FIX) Fix Mind Devourer proc detection and bar UI notifications related to using Devouring Plague or Mind Sear.<br/>
- (#241 - FIX) Prevent Mind Sear from showing a cost or active Insanity drain amount  when used with a Mind Devourer proc.

## Rogue
### Assassination

- (#253 - FIX) Fix Slice and Dice and Echoing Reprimand LUA errors relating to having a possible 7 Combo Points.

### Outlaw

- (#254 - FIX) Fix Slice and Dice and Echoing Reprimand LUA errors relating to having a possible 7 Combo Points.

## Shaman
### Elemental

- (#255 - FIX) Fix LUA errors when switching specs.

<br/>
# 10.0.0.11-release (2022/10/27)
## General

- (FIX) Prevent LUA errors causing bar initialization crashing due to invalid texture layers.

<br/>
# 10.0.0.10-release (2022/10/26)

## General

- Updated for Dragonflight prepatch.

]====]

local newsFrame = CreateFrame("Frame", "TRB_News_Frame", UIParent, "BackdropTemplate")
newsFrame:SetFrameStrata("DIALOG")
local isConstructed = false

function TRB.Functions.News:BuildNewsPopup()
    isConstructed = true
    TRB.Functions.News:Hide()
	newsFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile =  "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0,
		}
	})
	newsFrame:SetBackdropColor(0, 0, 0, 0.5)
	newsFrame:SetWidth(650)
	newsFrame:SetHeight(480)
	newsFrame:SetPoint("CENTER", UIParent)

	local newsPanelParent = TRB.Functions.OptionsUi:CreateTabFrameContainer("TRB_News_Frame_Panel", newsFrame, 640, 410)
	local newsPanel = newsPanelParent.scrollFrame.scrollChild
	newsPanelParent:SetBackdropColor(0, 0, 0, 1)
	newsPanelParent:ClearAllPoints()
	newsPanelParent:SetPoint("TOPLEFT", 5, -30)
	--newsPanelParent:SetPoint("BOTTOMRIGHT", 300, -500)
	--return newsPanel]]

	TRB.Functions.OptionsUi:BuildSectionHeader(newsFrame, "Twintop's Resource Bar Updates", oUi.xCoord, 0)
    local closeButton = TRB.Functions.OptionsUi:BuildButton(newsFrame, "Close", 510, -10, 100, 25)
	closeButton:ClearAllPoints()
	closeButton:SetPoint("BOTTOMRIGHT", -5, 5)
    closeButton:SetScript("OnClick", function(self, ...)
        TRB.Functions.News:Hide()
    end)

    local showAgainCheckbox = CreateFrame("CheckButton", "TwintopResourceBar_News_ShowAgain", newsFrame, "ChatConfigCheckButtonTemplate")
    local f = showAgainCheckbox
    f:SetPoint("BOTTOMLEFT", 5, 5)
    getglobal(f:GetName() .. 'Text'):SetText("Show on new version release")
    f.tooltip = "Show this update popup whenever a new version of Twintop's Resource Bar is released."
    f:SetChecked(TRB.Data.settings.core.news.enabled)
    f:SetScript("OnClick", function(self, ...)
        TRB.Data.settings.core.news.enabled = self:GetChecked()
    end)

    local simpleHtml = CreateFrame("SimpleHTML", "TRB_News_HTML_Frame", newsPanel)
	simpleHtml:SetPoint("TOPLEFT", newsPanel, "TOPLEFT", 5, -5)
    simpleHtml:SetPoint("BOTTOMRIGHT", newsPanel, "BOTTOMRIGHT", 5, -35)
	simpleHtml:SetWidth(600)
    
    simpleHtml:SetFontObject("h1", "SubzoneTextFont")
    simpleHtml:SetTextColor("h1", 0, 0.6, 1, 1)

    simpleHtml:SetFontObject("h2", "Fancy22Font")
    simpleHtml:SetTextColor("h2", 0, 1, 0, 1)

    simpleHtml:SetFontObject("h3", "NumberFontNormalLarge")
    simpleHtml:SetTextColor("h3", 0, 0.8, 0.4, 1)

    simpleHtml:SetFontObject("p", "GameFontNormal")
    simpleHtml:SetTextColor("p", 1, 1, 1, 1)

    simpleHtml:SetHyperlinkFormat("[|cff3399ff|H%s|h%s|h|r]")

    simpleHtml:SetScript("OnHyperlinkClick", 
        function(f, link, text, ...) 
            if     link=="window:close" 
            then   TRB.Functions.News:Hide()
                --f:GetParent():Hide() 
            elseif link:match("https?://")
            then
                   StaticPopup_Show("LIBMARKDOWNDEMOFRAME_URL", nil, nil, { title = text, url = link })
            end 
        end)

    simpleHtml:SetScript("OnHyperlinkEnter", function(f) SetCursor("Interface\\CURSOR\\vehichleCursor.PNG") end)
    simpleHtml:SetScript("OnHyperlinkLeave", function(f) SetCursor(nil)                                     end)

    simpleHtml:SetText(LMD:ToHTML(content))
    -- ... and this is the popup it opens.
    --
    StaticPopupDialogs["LIBMARKDOWNDEMOFRAME_URL"] = 
    { OnShow = 
        function(self, data)
        self.text:SetFormattedText("Here's a link to " .. data.title)
        self.editBox:SetText(data.url)
        self.editBox:SetAutoFocus(true)
        self.editBox:HighlightText()
        end,
    text         = "",
    wide         = true,
    closeButton  = true,
    button1      = "OK",
    timeout      = 60,
    hasEditBox   = true,
    hideOnEscape = true,
    OnAccept               = function(self) self:Hide() end,
    EditBoxOnEnterPressed  = function(self) self:Hide() end,
    EditBoxOnEscapePressed = function(self) self:Hide() end 
    }
end

function TRB.Functions.News:Hide()
    newsFrame:Hide()
end

function TRB.Functions.News:Show()
    if not isConstructed then
        TRB.Functions.News:BuildNewsPopup()
    end

    if TRB.Data.settings.core.news.lastUpdate ~= TRB.Details.addonVersion then
        TRB.Data.settings.core.news.lastUpdate = TRB.Details.addonVersion
    end
    newsFrame:Show()
end

function TRB.Functions.News:Init()
    if TRB.Data.settings.core.news.enabled and TRB.Data.settings.core.news.lastUpdate ~= TRB.Details.addonVersion then
        TRB.Functions.News:Show()
    end
end