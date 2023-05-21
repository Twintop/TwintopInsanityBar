---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.News = {}
local LMD = LibStub("LibMarkdown-1.0")
local oUi = TRB.Data.constants.optionsUi

local content = [====[
----

# 10.1.0.4-release (2023-05-22)
## General

- [#317 - REFACTOR](#317) Overhauled how targets and debuff tracking works to make it more modular and generic.

## Monk
### Windwalker

- [#318 - FIX](#318) Fix an issue where Mark of the Crane wouldn't be properly tracked from Blackout Kick with the Shadowboxing Treads talent.

## Priest
### Shadow

- [#315 - PR - st-htmn](#317) Add support for Idol of Yogg-Saron.
<br/>&emsp;&ensp;- Thanks go out to *st-htmn* for adding this functionality!
<br/>&emsp;&ensp;- Tracks the current stacks and time remaining on the Idol of Yogg-Saron buff and the time left on Thing From Beyond once spawned.
<br/>&emsp;&ensp;- New bar text icons and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#ys` or `#idolOfYoggSaron` -- Idol of Yogg-Saron buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `#tfb` or `#thingFromBeyond` -- Thing From Beyond buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$ysTime` -- time remaining on the Idol of Yogg-Saron buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$ysStacks` -- stacks on the Idol of Yogg-Saron buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$ysRemainingStacks ` -- stacks required for Idol of Yogg-Saron to spawn a Thing From Beyond
<br/>&emsp;&ensp;&emsp;&ensp;- `$tfbTime` -- time remaining on a spawned Thing From Beyond

## Rogue
### Assassination

- [#319 - FIX](#319) Update the debuff ID for Serrated Bone Spike.

### Outlaw

- [#320 - FIX](#320) Correct some issues with bar text for poisons.

## Shaman
### Enhancement

- [#283 - FIX](#283) Hide the Maelstrom UI when switching from Enhancemnt to Elemental or Restoration.

----

# 10.1.0.3-release (2023-05-16)
## General

- [#311 - NEW](#311) Add Time To Die overrides for The Lost Dwarves in Uldaman: Legacy of Tyr 
<br/>&emsp;&ensp;- Olaf, Baelog, and Eric "The Swift" -- 10%

## Druid
### Balance

- [#310 - HOTFIX](#310) T29 4P adjustment: Entering Eclipse makes your next Starsurge or Starfall cost 10 less Astral Power (was 5).

## Priest
### Shadow

- [#315 - FIX](#315) Use the correct Pandemic refresh time for Shadow Word: Pain when Misery is talented.

----

# 10.1.0.2-release (2023-05-09)
## Druid
### Balance

- [#310 - HOTFIX](#310) Wrath Astral Power generation reduced to 8 (was 10).

## Monk
### Mistweaver

- [#305 - NEW](#305) Add support for Vivacious Vivification.
<br/>&emsp;&ensp;- Optional bar color change when the effect is active, denoting that Vivify can be cast instantly.
- [#306 - NEW](#306) Add support for Mana Tea.
<br/>&emsp;&ensp;- Optional bar border color change when the buff is up.
<br/>&emsp;&ensp;- New bar text icon and variable:
<br/>&emsp;&ensp;&emsp;&ensp;- `#manaTea` -- buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$mtTime` or `$manaTeaTime` -- total time remaining on the buff

## Windwalker

- [#275 - FIX](#275) Only show Detox's threshold as on cooldown when Detox actually removes a disease or poison.

## Priest
### Shadow

- [#302 - NEW](#302) Add an optional audio cue for when you gain a Deathspeaker proc.
- [#309 - FIX](#309) Ensure Mind Spike: Insanity shows incoming casting Insanity.

----

# 10.1.0.1-release (2023-05-04)
## General

- [#307 - FIX](#307) Fix `$overcap` (and various spec-specific aliases) bar text to pull from the current character's specialization settings.

## Priest
### Holy

- [#308 - FIX](#308) Fix passive incoming mana regen from Shadowfiend not displaying.

----

# 10.1.0.0-release (2023-05-02)
## General

- [#292 - UPDATE](#292) Add `IconTexture` to TOC. This shows the addon's icon/logo in the AddOn List menu in game.
- [#298 - FIX](#298) Fix an issue where PvP ability threshold lines would show up when enabled even if you weren't talented in to the associated PvP Talent.
<br/>&emsp;&ensp;- This fix applies to: Devastation Evokers, Beast Mastery Hunters, Marksmanship Hunters, Assassination Rogues, and Outlaw Rogues.
- [#300 - UPDATE](#300) Greatly improve resource overcap support and customization.
<br/>&emsp;&ensp;- In addition to the existing "fixed" mode, an additional configuration option to set the overcap amount relative to your maximum resource has been added and set as the default behavior.
<br/>&emsp;&ensp;- Bar border and resource text will not change to the overcap color while out of combat.
- [#301 - UPDATE](#301) Update the options UI for all specs to split bar color and bar border color in to separate sections. Relocate some enabling toggles to these sections from elsewhere in the options menus.

### Healers

- [#303 - NEW](#303) Add support for the new trinket *Rashok's Molten Heart* and the proc effect, *Molten Radiance*'s, mana regen.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#mr`, `#moltenRadiance` -- spell icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$mrTime` -- total time remaining on the proc
<br/>&emsp;&ensp;&emsp;&ensp;- `$mrMana` -- total remaining incoming mana from the proc

## Druid
### Balance

- [#292 - UPDATE](#292) 10.1.0 changes:
<br/>&emsp;&ensp;- Update the Astral Power generation of New Moon, Half Moon, and Full Moon.
<br/>&emsp;&ensp;- Baseline Astral Power adjustments for Wrath, Starfire, and Stellar Flare.
<br/>&emsp;&ensp;- Soul of the Forest only increases Wrath's incoming Astral Power by 50%.
<br/>&emsp;&ensp;- Nature's Balance passive Astral Power generation values updated.
<br/>&emsp;&ensp;- Elune's Guidance Astral Power reduction to Starsurge and Starfall updated.
- [#294 - UPDATE](#294) Adjust how Touch the Cosmos (T29 4P bonus) is implemented to match changes in 10.1.0.

### Feral

- [#292 - UPDATE](#292) 10.1.0 changes:
<br/>&emsp;&ensp;- Relentless Predator's Energy modifier for Ferocious Bite updated to 80% (was 60%).
- [#292 - NEW] Add support for Berserking / Incarnation: Avatar of Ashamane passively generating Combo Points.
<br/>&emsp;&ensp;- While the buff is active, show the progress towards the next Combo Point as a filling bar on the next available Combo Point.
- [#292 - NEW](#292) Add support for Predator Revealed (T30 4P).
<br/>&emsp;&ensp;- When a proc occurs, show the progress towards the next Combo Point as a filling bar on the next available Combo Point.
<br/>&emsp;&ensp;- Custom color available to denote which Combo Points are incoming from this proc.
<br/>&emsp;&ensp;- When Berserking / Incarnation: Avatar of Ashamane is active, the order of filling Combo Points will be from soonest to last.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#predatorRevealed` -- spell icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$predatorRevealedTime` -- total time remaining on the buff
<br/>&emsp;&ensp;&emsp;&ensp;- `$predatorRevealedTicks` -- total remaining ticks / Combo Points to be generated
<br/>&emsp;&ensp;&emsp;&ensp;- `$predatorRevealedTickTime` -- time until the next tick occurs / Combo Point is generated

## Hunter
### Beast Mastery

- [#299 - NEW](#299) Add support for Beast Cleave.
<br/>&emsp;&ensp;- Change the bar's border color when the Beast Cleave effect is active either via Beast Cleave, or, Call of the Wild with Bloody Frenzy also talented.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#beastCleave` -- ability icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$beastCleaveTime` -- total time remaining on the effect (Beast Cleave or Call of the Wild w/Bloody Frenzy, whichever is greater)
- (FIX) Fix Beastial Wrath being usable border color change notification.

## Monk
### Mistweaver

- [#292 - NEW](#292) Add support for Mistweaver's T30 2P proc effect, *Soulfang Infusion*, which gives passive mana regeneration.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#si`, `#soulfangInfusion` -- spell icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$siTime` -- total time remaining on the proc
<br/>&emsp;&ensp;&emsp;&ensp;- `$siTicks` -- total remaining ticks of mana regen from the proc
<br/>&emsp;&ensp;&emsp;&ensp;- `$siMana` -- total remaining incoming mana from the proc

## Priest
### Shadow

- [#292 - UPDATE](#292) 10.1.0 changes:
<br/>&emsp;&ensp;- Remove old spells/abilities: Dark Void, Mind Sear, Surge of Darkness, Piercing Shadows, Death and Madness (incoming over time).
<br/>&emsp;&ensp;- Baseline Insanity adjustments for Void Torrent, Mind Flay: Insanity, Auspicious Spirits, Void Bolt, Shadowfiend (swing), Mindbender (swing), Void Tendril (tick), and Void Lasher (tick).
<br/>&emsp;&ensp;- Remove Mind Melt from granting an instant Mind Blast.
<br/>&emsp;&ensp;- Remove "spending" bar color config.
<br/>&emsp;&ensp;- Remove all references to Mind Sear.
<br/>&emsp;&ensp;- Add support for Devouring Plague's Insanity cost being modified by Distorted Reality and Mind's Eye.
<br/>&emsp;&ensp;- Voidtouched support works automagically, allowing maximum Insanity to be 150.
<br/>&emsp;&ensp;- Update Auspicious Spirits predicted incoming Insanity to match the formula in SimulationCraft.
- [#292 - NEW](#292) Added extra threshold lines for Devouring Plague, similar to Starsurge threshold lines for Balance Druids. These are separately toggleable at 2x and 3x the cost with an additional option to only show the next available threshold line.
- [#292 - NEW](#292) Mind Flay: Insanity tracking has been extended to include Mind Spike: Insanity and keep track of stacks of the buff.
<br/>&emsp;&ensp;- New bar text variable:
<br/>&emsp;&ensp;&emsp;&ensp;- `$mfiStacks` -- number of stacks of the buff
- [#302 - NEW](#302) Add support for tracking Deathspeaker procs:
<br/>&emsp;&ensp;- Optional bar border color change when the buff is up. This superceeds the Mind Flay: Insanity / Mind Spike: Insanity border color change.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#swd`, `#shadowWordDeath`, `#deathspeaker` -- buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$deathspeakerTime` -- total time remaining on the buff

## Shaman
### Elemental

- [#292 - NEW](#292) Added support for Primal Fracture (T30 4P bonus):
<br/>&emsp;&ensp;- Optional bar border color change when the buff is up.
<br/>&emsp;&ensp;- New bar text icon and variables:
<br/>&emsp;&ensp;&emsp;&ensp;- `#primalFracture` - buff icon
<br/>&emsp;&ensp;&emsp;&ensp;- `$pfTime` -- total time remaining on the buff

----
# 10.0.7.2-release (2023-04-15)
## General

- [#278 - UPDATE](#278) Added clickable links to each of the issue numbers in the news dialog.

## Hunter

- (FIX) Re-add `$serpentSting` logic variable that had gone missing.

### Marksmanship

- (FIX) Change Barrage's Focus cost to 30.
- (FIX) Update Steady Focus to use the correct TalentID.

----
# 10.0.7.1-release (2023-03-26)
## Demon Hunter
### Havoc

- [#296 - FIX](#296) Restore access to Havoc's options menu.
# 10.1.0.0-beta04 (2023-03-27)
## General

----
# 10.0.7.0-release (2023-03-22)
## General

- (FIX) Correct a number of default advanced bar text that would render improperly.

## Druid
### Balance
- [#294 - NEW](#294) Add support for Touch of Cosmos (T29 4P bonus). Starfall and Starsurge will now show as usable when first entering Eclispe, regardless of Astral Power.
- (FIX) Fix Elune's Guidance modifying the threshold for Starsurge and Starfall.

## Priest
### Shadow

- [#273 - UPDATE](#273) Auspicious Spirits once again generate Insanity on hit instead of on spawn. Support for the passive Insanity generation has been re-enabled.

----
# 10.0.5.9-release (2023-03-11)
## General

- [#219 - UPDATE](#219) Add detection support for the first boss of Mogu'shan Palace -- Kuai the Brute, Ming the Cunning, and Haiyan the Unstoppable @ 10% each.

## Priest
### Shadow

- [#288 - UPDATE](#288) Add an option to disable bar color change when Mind Blast can be instantly cast.
- (FIX) Update Mind Flay: Insanity bar text icon detection.
- (UPDATE) Do some minor rearranging of the options menu for bar colors. This layout change (or one like it) will be applied to other option screens and more configurations will be added soon (tm)!

----
# 10.0.5.8-release (2023-03-05)
## General

- [#278 - NEW](#278) Add a news popup to be shown whenever a new version of the bar is released. This will contain (predominantly) the release notes for new versions of the bar.<br/><br/>
- [#219 - UPDATE](#219) Add an alternate detection method for the poisoning of the Flask of Solemn Night in Court of Stars.

## Druid
### Restoration

- [#291 - NEW](#291) Add support for Incarnation: Tree of Life bar color change. This works similarly to other bar color changes via buffs (e.g. Voidform, Trueshot, Eclipse, etc.) with colors for both when it is active and when it is close to ending, and configuration of when to show the close to ending color.
<br/>&emsp;&ensp;- New bar text variable: `$incarnationTime`
<br/>&emsp;&ensp;- New bar text icon: `#incarnation`<br/><br/>
- [#291 - NEW](#291) Add Reforestation tracking.
<br/>&emsp;&ensp;- New bar text variable: `$reforestationStacks`
<br/>&emsp;&ensp;- New bar text icon: `#reforestation`

## Priest
### Shadow

- [#288 - NEW](#288) Add a bar color change while Mind Blast is instant cast either via a Shadowy Insight proc or having two stacks of Mind Melt. This will only change the bar color if you can currently cast Mind Blast (it isn't completely on cooldown).
<br/>&emsp;&ensp;- New bar text variables: `$mmTime`, `$mmStacks`, `$siTime`, `$mindBlastCharges`, `$mindBlastMaxCharges`
<br/>&emsp;&ensp;- New bar text icons: `#mm`/`#mindMelt`, `#si`/`#shadowyInsight`

----
# 10.0.5.7-release (2023-02-28)
## General

- [#219 - NEW](#219) For targets that are "defeated" at a health other than 0% can now have an override "death" percent to provide more accurate time to die estimates. For current content this includes:
<br/>&emsp;&ensp;- Shadowmoon Burrial Grounds: Carrion Worm (trash/before Bonemaw) -- 20%
<br/>&emsp;&ensp;- Court of Stars: Patrol Captain Gerdo (if Flask of the Solemn Night is poisoned) -- 25%
<br/>&emsp;&ensp;- Trial of Valor: Hymdall -- 10%; Fenryr (phase 1) -- 60%; Odyn -- 80%
<br/>&emsp;&ensp;- Brackenhide Hollow: Decatriarch Wratheye -- 4.5%

## Healers

- [#265 - UPDATE](#265) Add an option to hide the threshold line of Conjured Chillglobe while it is on cooldown.
## Healers

- [#265 - UPDATE](#265) Add an option to hide the threshold line of Conjured Chillglobe while it is on cooldown.

## Priest
### Holy

- [#282 - NEW](#282) Add threshold line showing how much mana would be gained by using Shadowfiend. This is separate and in addition to the passive threshold line that shows when Shadowfiend is actively attacking and regenerating mana. This also includes an option to hide the threshold line while Shadowfiend is on cooldown.<br/>
- [#282 - FIX](#282) Adjust the logic around detecting Shadowfiend swings for Holy to get more accurate predictions.

## Shaman
### Elemental

- [#290 - HOTFIX](#290) Frost Shocks that are buffed by Icefury now generate 14 Maelstrom.

----
# 10.0.5.6-release (2023-02-24)
## General

- (FIX) Correct the layout for bar text instructions.

## Druid
### Feral

- [#286 - NEW](#286) Add a new bar border color change and bar text variable, `$inStealth`, for when you are in stealth or have a proc/effect that allows you to act as if you were stealthed.

## Priest
### Shadow

- [#284 - FIX](#284) Update Insanity generated per tick from Void Lashers and Void Tentacles to 2 Insanity.

## Rogue
### Assassination

- [#286 - NEW](#286) Add a new bar border color change and bar text variable, `$inStealth`, for when you are in stealth or have a proc/effect that allows you to act as if you were stealthed.

### Outlaw

- [#286 - NEW](#286) Add a new bar border color change and bar text variable, `$inStealth`, for when you are in stealth or have a proc/effect that allows you to act as if you were stealthed.

## Shaman
### Elemental

- [#287 - FIX](#287) Only play the audio cue for Earth Shock once instead of forever. Dingdingindingdingdingnindging!

## Warrior
### Arms

- [#289 - FIX](#289) Prevent LUA errors from sometimes triggering when Deep Wounds is applied.

----
# 10.0.5.5-release (2023-02-21)
## General

- [#283 - EXPERIMENTAL](#283) Experimental/minimal support for Enhancement Shaman.<br/>
- [#87 - REFACTOR](#87) Lots of under the hood changes in preparation for future bar text and layout improvements. Stay tuned! 

## Shaman
### Enhancement

- This feature is EXPERIMENTAL and is not enabled by default. To enable Enhancement Shaman support, go to the main "General" options menu for Twintop's Resource Bar and check "Enhancement Shaman support" under the "Experimental Features" section then reload your UI!<br/>
- [#283 - EXPERIMENTAL](#283) Minimalist implementation for Enhancement Shaman, tracking Maelstrom Weapon stacks and Mana (to a much lesser extent). Presently displays Maelstrom Weapon in a similar fashion as Combo Points or Chi, tracks Ascendance (with mana bar color changing), and Flame Shock target count/duration.

----
# 10.0.5.4-release (2023-02-02)
## Evoker
### Preservation

- (FIX) Remove spammy debug prints from chat window.

----
# 10.0.5.3-release (2023-02-01)
## General

- (FIX) Prevent invalid bar border sizes from being allowed via options UI.

## Evoker

- (FIX) Fix LUA errors related to options menus.

----
# 10.0.5.2-release (2023-02-01)
## General

- [#259 - EXPERIMENTAL](#259) Experimental/minimal support for Devastation Evoker.<br/>
- [#280 - EXPERIMENTAL](#280) Experimental support for Preservation Evoker.<br/>
- (FIX) Change how resetting specialization configuration to defaults work. Previously, some configuration resets were not reliably resetting to default values.

## Druid
### Balance

- (FIX) Ensure Starsurge and Starfall threshold lines adjust correctly when Rattle the Stars is up.

## Evoker
### Devastation

- This feature is EXPERIMENTAL and is not enabled by default. To enable Devastation Evoker support, go to the main "General" options menu for Twintop's Resource Bar and check "Devastation Evoker support" under the "Experimental Features" section.<br/>
- [#259 - EXPERIMENTAL](#259) Minimalist implementation for Devastation Evoker, tracking Essence and Mana (to a much lesser extent). Presently displays Essence in a similar fashion as Combo Points or Chi, but shows the refill status in the currently regenerating node.

### Preservation

- This feature is EXPERIMENTAL and is not enabled by default. To enable Devastation Evoker support, go to the main "General" options menu for Twintop's Resource Bar and check "Devastation Evoker support" under the "Experimental Features" section.<br/>
- [#280 - EXPERIMENTAL](#280) Experimental implementation for Devastation Evoker, tracking Essence and Mana. Currently supports the same generic healer tracking capabilities as the other supported healing specializations: Innervate, Mana Tide Totem, Symbol of Hope, mana potions, Chillglobe, etc. Additional support has been added for mana regeneration via Emerald Communion.

## Shaman
### Elemental

- (FIX) Prevent a LUA error when switching to Elemental from another specialization.

----
# 10.0.5.1-release (2023-01-28)
## General
### DPS

- [#194 - NEW](#194) Abilities which are unusable due to being out of range now have a new optional threshold line color. 

### Healing

- [#277 - NEW](#277) For supported healing specs: add new bar border color change, passive incoming (regen) mana, and bar text ($potionOfChilledClarityTime and $potionOfChilledClarityMana) when Potion of Chilled Clarity has been used. This behaves almost exactly like Innervate's implementation and superceeds it in priority.<br/>
- (UPDATE) Fix some issues with Innervate bar text variables and logic checks.

## Demon Hunter

- [#274 - NEW](#274) Add a new special threshold line color change to Chaos Strike/Annihilation when the Chaos Theory buff is active.

## Hunter
### General

- (UPDATE) Removed Pandemic DoT color for Serpent Sting as this DoT does not follow traditional Pandemic refresh rules.

### Beast Mastery

- [#248 - NEW](#248) Add support for multiple Kill Command charges via the class talent Alpha Predator.<br/>
- [#248 - NEW](#248) Add support for the PvP talent Dire Beast: Basilisk. This has an additional threshold line which will only show up when actively engaged in PvP, warmode is on, or in an arena or battleground.<br/>
- [#248 - NEW](#248) Add support for the PvP talent Dire Beast: Hawk. This has an additional threshold line which will only show up when actively engaged in PvP, warmode is on, or in an arena or battleground.

### Marksmanship

- [#249 - NEW](#249) Add support for multiple Kill Command charges via Alpha Predator.<br/>
- [#249 - NEW](#249) Add support for the PvP talent Sniper Shot. This has an additional threshold line which will only show up when actively engaged in PvP, warmode is on, or in an arena or battleground.

----
# 10.0.5.0-release (2023-01-25)
## General

- [#271 - NEW](#271) Threshold icons can now have the option to be shown as desaturated when an the associated ability is not usable.<br/>
- [#264 - UPDATE](#264) Adjust existing and add new interactions for the changes in patch 10.0.5.<br/>
- [#271 - UPDATE](#271) Under the hood refactoring to threshold lines. Behavior should be identical to before but if there are any regressions or changes please open an issue on GitHub!

## Druid
### Balance

- [#264 - UPDATE](#264) Remove Circle of Life and Death.

### Feral

- [#264 - UPDATE](#264) Change Rip, Thrash, and Swipe's baseline/talent/ability statuses.<br/>
- [#264 - UPDATE](#264) Update Relentless Predator's to reduce the cost of associated abilities by 40%.

## Priest
### Shadow

- [#264 - UPDATE](#264) Mindgames and Halo both generate 10 Insanity on cast.<br/>
- [#272 - BUG](#272) When talented in to Auspicious Spirits, update Mind Blast's incoming Insanity value to include the number of Auspicious Spirits it will spawn and produce Insanity. This is due to a bug (?) in 10.0.x where Auspicious Spirits are granting Insanity on spawn rather than the intended (historical back to 5.x?) on hit.

## Rogue
### Assassination

- [#253 - NEW](#253) Add Tight Spender support.<br/>
- [#253 - NEW](#253) Add Lightweight Shiv support.<br/>
- [#253 - NEW](#253) Add Improved Garrote support. There is a new "special" threshold line color configuration option that will be used when Improved Garrote's effect is active.<br/>
- [#270 - NEW](#270) Add option to use the same background for all unfilled combo points instead of ability-specific (e.g. Echoing Reprimand) background coloring.<br/>
- [#264 - UPDATE](#264) Feint is now a baseline ability and not a talent.<br/>
- [#264 - UPDATE](#264) Update Sepsis behavior and associated stealth ability usage.

### Outlaw

- [#254 - NEW](#254) Add Tight Spender support.<br/>
- [#270 - NEW](#270) Add option to use the same background for all unfilled combo points instead of ability-specific (e.g. Echoing Reprimand) background coloring.<br/>
- [#264 - UPDATE](#264) Feint is now a baseline ability and not a talent.<br/>
- [#264 - UPDATE](#264) Update Sepsis behavior and associated stealth ability usage.

## Warrior
### Arms

- [#264 - NEW](#264) Add Ignore Pain threshold line.<br/>
- [#264 - UPDATE](#264) Storm of Swords now increases Whirlwind's Rage cost by 20.

### Fury

- [#264 - UPDATE](#264) Storm of Steel now increases Ravager's Rage generation by 20.

----
# 10.0.2.7-release (2023-01-17)
## Demon Hunter
### Havoc

- [#243 - UPDATE](#243) Change Prepared's logic to be related to Tactical Retreat instead.<br/>
- [#243 - FIX](#243) Restore icon listing to bar text flyout in options.<br/>
- [#243 - FIX](#243) Adjust Furious Throws behavior.

## Druid
### Balance

- [#245 - FIX](#245) Fix LUA errors associated with Primordial Arcanic Pulsar bar text.

## Hunter
### Beast Mastery

- [#248 - NEW](#248) Add Aspect of the Wild support for reducing the Focus cost of Cobra Shot.<br/>
- [#248 - NEW](#248) Add Dire Pack support for reducing the Focus cost of Kill Command (needs testing/verification).<br/>
- [#248 - FIX](#248) Update the spell id associated with Cobra Sting's buff.

## Priest
### Holy

- [#266 - NEW](#266) Add passive mana regen from Shadowfiend.

## Shaman
### Elemental

- [#255 - NEW](#255) Add Ascendance bar color change and bar text variables. As with other major cooldown-related bar colors, configuration options exist to give a different warning color when the buff is close to expiring.

### Restoration

- [#256 - NEW](#256) Add Ascendance bar color change and bar text variables. As with other major cooldown-related bar colors, configuration options exist to give a different warning color when the buff is close to expiring.

## Warrior
### Arms

- [#257 - NEW](#257) Add Bloodletting support for bleed pandemic timings.<br/>
- [#257 - NEW](#257) Add support for Battlelord reducing Rage costs for Mortal Strike and Cleave.

### Fury

- [#258 - NEW](#258) Support Storm of Steel increasing Ravager's Rage generation.<br/>
- [#258 - UPDATE](#258) Improve Execute implementation by supporting Sudden Death and Improved Execute; re-add threshold lines.

----
# 10.0.2.6-release (2023-01-11)
## General

- [#267 - NEW](#267) Added $inCombat as a bar text variable that is TRUE when you are currently enaged in combat.<br/>
- [#265 - UPDATE](#265) Update what bonus ids are used to detect Conjured Chillglobe versions.<br/>
- (UPDATE) The listing of currently supported specs has been corrected.

## Druid
### Balance

- [#245 - NEW](#245) Add Circle of Life and Death support for showing pandemic range for DoTs.

### Feral

- [#246 - FIX](#246) Restore overcapping border color picker to options menu.

## Monk
### Mistweaver

- [#251 - NEW](#251) Add Soothing Mist mana cost per tick.

----
# 10.0.2.5-release (2023-01-08)
## General

- [#265 - NEW](#265) Add support for Conjured Chillglobe via threshold line and configuration option for supported healing specs.<br/>
- (FIX) Fixed an issue with some not (!) logic in bar text returning invalid results.<br/>
- (FIX) Correct various typos and layout issues in settings.<br/>
- (UPDATE) Adjust how item icons are accessed and loaded.

## Druid
### Balance

- [#245 - NEW](#245) Add Circle of Life and Death support for calculating pandemic timings for DoTs.

### Feral

- [#246 - NEW](#246) Add Relentless Predator support for Ferocious Bite energy cost calculations.

### Restoration

- [#265 - NEW](#265) Add support for Conjured Chillglobe via threshold line and configuration option.

## Monk
### Mistweaver

- [#265 - NEW](#265) Add support for Conjured Chillglobe via threshold line and configuration option.

## Priest
### Holy

- [#242 - NEW](#242) Add support for T30 2P affecting Holy Word reductions.<br/>
- [#265 - NEW](#265) Add support for Conjured Chillglobe via threshold line and configuration option.<br/>
- [#242 - FIX](#242) Fix logic errors with new bar text variables.

### Shadow

- [#241 - NEW](#241) Mind Flay: Insanity now has an optional border color change when the buff is active.<br/>
- [#241 - NEW](#241) Add Devoured Despair (Idol of Y'Shaarj) passive insanity generation to Mindbender/Shadowfiend.<br/>
- [#241 - FIX](#241) Add Idol of C'Thun icons back in.<br/>
- [#241 - FIX](#241) Death and Madness generates 7.5 Insanity per tick, not 10 Insanity per tick.<br/>
- [#241 - FIX](#241) Correct Auspicious Spirits enable/disable option.<br/>
- [#241 - FIX](#241) Properly track Mind Sear channeling cost, including with a Devouring Plague proc.<br/>
- [#241 - UPDATE](#241) Modify default advanced bar text to include Mind Flay: Insanity

## Shaman
### Restoration

- [#265 - NEW](#265) Add support for Conjured Chillglobe via threshold line and configuration option.

----
# 10.0.2.4-release (2022-12-14)
## Priest
### Holy

- [#242 - FIX](#242) Fix logic errors with new bar text variables.

----
# 10.0.2.3-release (2022-12-14)
## Priest
### Holy

- [#242 - NEW](#242) Add Lightweaver support. This includes bar text variables for stacks and time remaining, border color change when you have any stacks, and an audio cue for when you go from 0 -> 1 stacks.<br/>
- [#242 - UPDATE](#242) Change the priority ordering of bar border color changes for procs to be: Lightweaver < Resonant Words < Surge of Light (1 Stack) < Surge of Light (2 Stacks) < Innervate.

----
# 10.0.2.2-release (2022-12-14)
## General

- (FIX) Options tabs for all specs have had their UI updated.<br/>
- [#263 - UPDATE](#263) Update mana potions for healing specs to use Dragonflight potions instead of Shadowlands. Different ranks are options but rank 3 is selected by default for both Aerated Mana Potion and Potion of Frozen Focus.

## Druid
### Feral

- [#246 - FIX](#246) Update Apex Predator's Craving proc detection.

### Restoration

- [#263 - UPDATE](#263) Update mana potions for Dragonflight.<br/>
- [#247 - UPDATE](#247) Separate logic between border color changes and audio cues when gaining Innervate.

## Monk
### Mistweaver

- [#263 - UPDATE](#263) Update mana potions for Dragonflight.<br/>
- [#251 - UPDATE](#251) Separate logic between border color changes and audio cues when gaining Innervate.

## Priest
### Holy

- [#242 - NEW](#242) Add Resonant Words support: bar border color change, bar text variable for time remaining, and audio cue for proc.<br/>
- [#242 - FIX](#242) Correct Holy Word: Sanctuary cooldown reduction bar color change behavior.<br/>
- [#242 - UPDATE](#242) Add logic to prevent bar color change for Holy Word cooldowns if the associated Holy Word is not talented. <br/>
- [#263 - UPDATE](#263) Update mana potions for Dragonflight.<br/>
- [#242 - UPDATE](#242) Separate logic between border color changes and audio cues when gaining Innervate, Surge of Light procs (1 or 2 stacks), or Resonant Words.

## Rogue
### Assassination

- [#253 - NEW](#253) Add configuration option to disable unfilled Combo Point color for Serrated Bone Spike.

## Shaman
### Restoration

- [#263 - UPDATE](#263) Update mana potions for Dragonflight.<br/>
- [#256 - UPDATE](#256) Separate logic between border color changes and audio cues when gaining Innervate.

----
# 10.0.2.1-release (2022/12/01)
## Priest
### Shadow

- [#241 - FIX](#241) Fix Voidform time remaining to be more accurate and includ extentions due to spent Insanity.

----
# 10.0.2.0-release (2022/11/28)
## General

- (CLEANUP) Removed remaining support for Shadowlands systems: legendaries, covenants, soulbinds, Torghast powers, Sanctum of Domination powers, and M+ affixes <br/>
- [#260, #262 - FIX](#260) Avoid running bar code when a specialization switch has just occurred; add some extra validation for what spec is currently active.

## Hunter
### Beast Mastery

- (FIX) Correct options menu layout.

## Priest

- [#262 - FIX](#262) Stop LUA errors from occurring as Discipline.

## Rogue
### Assassination

- [#261 - FIX](#261) Correct Gouge thresholdline logic to stop crashing when talented.

----
# 10.0.0.15-release (2022/11/18)
## Druid

- (FIX) Remove old options that caused crashes for new bar users.

----
# 10.0.0.14-release (2022/11/11)
## Rogue
### Assassanation

- [#253 - FIX](#253) Fix LUA errors when switching specs with poisons applied.

### Outlaw

- [#260 - FIX](#260) Fix Atrophic Poison related LUA errors.<br/>
- [#260 - FIX](#260) Remove debug prints of current combo points.<br/>
- [#254 - FIX](#254) Fix LUA errors when switching specs with poisons applied.

----
# 10.0.0.13-release (2022/11/11)
## Druid
### Balance

- [#245 - UPDATE](#245) Change Wrath's Astral Power generation to 8 to match hotfixes.

----
# 10.0.0.12-release (2022/11/08)
## Druid
### Balance

- [#245 - FIX](#245) Stop Combo Points from attempting to render and causing LUA errors.

### Feral

- [#246 - FIX](#246) Fix Carnivorous Instinct LUA errors.<br/>
- [#246 - FIX](#246) Add Primal Wrath threshold line toggle to options.

### Restoration

- [#247 - FIX](#247) Stop Combo Points from attempting to render and causing LUA errors.

## Hunter
### Marksmanship

- [#249 - FIX](#249) Fix Steady Shot and Improved Steady Shot's Focus generation amounts causing LUA errors.

## Monk
### Mistweaver

- [#251 - FIX](#251) Stop Chi from attempting to render and causing LUA errors.

### Windwalker

- [#252 - FIX](#252) Fix Strike of the Windlord.

## Priest

- [#241 - FIX](#241) Fix Mind Devourer proc detection and bar UI notifications related to using Devouring Plague or Mind Sear.<br/>
- [#241 - FIX](#241) Prevent Mind Sear from showing a cost or active Insanity drain amount  when used with a Mind Devourer proc.

## Rogue
### Assassination

- [#253 - FIX](#253) Fix Slice and Dice and Echoing Reprimand LUA errors relating to having a possible 7 Combo Points.

### Outlaw

- [#254 - FIX](#254) Fix Slice and Dice and Echoing Reprimand LUA errors relating to having a possible 7 Combo Points.

## Shaman
### Elemental

- [#255 - FIX](#255) Fix LUA errors when switching specs.

----
# 10.0.0.11-release (2022/10/27)
## General

- (FIX) Prevent LUA errors causing bar initialization crashing due to invalid texture layers.

----
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
            if link=="window:close" then  
                TRB.Functions.News:Hide()
                --f:GetParent():Hide() 
            elseif link:match("https?://") then
                StaticPopup_Show("LIBMARKDOWNDEMOFRAME_URL", nil, nil, { title = text, url = link })
            elseif link:match("^#%d+$") then
                local issueId = string.sub(link, 2)
                local url = "https://github.com/Twintop/TwintopInsanityBar/issues/" .. issueId
                local titleText = "view issue " .. link .. " on GitHub"
                StaticPopup_Show("LIBMARKDOWNDEMOFRAME_URL", nil, nil, { title = titleText, url = url })
            end 
        end)

    simpleHtml:SetScript("OnHyperlinkEnter", function(f) SetCursor("Interface\\CURSOR\\vehichleCursor.PNG") end)
    simpleHtml:SetScript("OnHyperlinkLeave", function(f) SetCursor(nil)                                     end)

    simpleHtml:SetText(LMD:ToHTML(content))
    -- ... and this is the popup it opens.
    StaticPopupDialogs["LIBMARKDOWNDEMOFRAME_URL"] = {
        OnShow = function(self, data)
			self:SetWidth(450)
            self.text:SetFormattedText("Here's a link to " .. data.title)
            self.editBox:SetText(data.url)
            self.editBox:SetAutoFocus(true)
            self.editBox:HighlightText()
        end,
        OnAccept = function(self)
            self:Hide()
        end,
        EditBoxOnEnterPressed = function(self)
			self:GetParent():Hide()
        end,
        EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
        end,
        text = "",
        button1 = "OK",
        hasEditBox = true,
        hasWideEditBox = true,
        editBoxWidth = 400,
        timeout = 60,
		whileDead = true,
        closeButton = true,
        hideOnEscape = true
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