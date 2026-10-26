local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.OptionsUi = TRB.Classes.OptionsUi or {}

---A label that hover badges can sit beside (Primitives' Attach*BadgeToText).
---@class TRB.Classes.OptionsUi.BadgedText : FontString
---@field public trbBadges table<string, TRB.Classes.OptionsUi.Badge>? # Badges by kind
---@field public trbBadgeBox { width: number, height: number }? # Fixed label box, so badges wrap the text instead of running off the panel

---A short colored badge that explains itself on hover.
---@class TRB.Classes.OptionsUi.Badge : Frame
---@field public font FontString
---@field public trbTooltip { header: string, text: string, r: number, g: number, b: number }

---A section header from Primitives:BuildSectionHeader.
---@class TRB.Classes.OptionsUi.SectionHeader : Frame
---@field public font FontString

---@class TRB.Classes.OptionsUi.BackdropEditBox : EditBox, BackdropTemplate

---A slider from Primitives:BuildSlider or BuildPercentageSlider, with its value box, step buttons, and labels.
---@class TRB.Classes.OptionsUi.Slider : Slider, BackdropTemplate
---@field public EditBox TRB.Classes.OptionsUi.BackdropEditBox
---@field public MinLabel FontString
---@field public MaxLabel FontString
---@field public Title FontString
---@field public Thumb Texture
---@field public Plus Button
---@field public Minus Button

---The Bar Text tab's variables flyout, from BarTextVariables:CreateVariablesSidePanel.
---@class TRB.Classes.OptionsUi.BarTextVariablesPanel : Frame, BackdropTemplate
---@field public variablesTable table # LibScrollingTable instance
---@field public allData table[] # Flat row list the table displays
---@field public BuildDataTable fun(barTextVariables: table)
---@field public descLabel FontString
---@field public descText FontString
---@field public searchBox EditBox

---A panel's scrollable content frame; the Bar Text tab's also carries its variables flyout.
---@class TRB.Classes.OptionsUi.ScrollChild : Frame
---@field public barTextVariablesPanel TRB.Classes.OptionsUi.BarTextVariablesPanel?

---A scroll frame from Tabs:CreateScrollFrameContainer.
---@class TRB.Classes.OptionsUi.ScrollContainer : ScrollFrame
---@field public scrollChild TRB.Classes.OptionsUi.ScrollChild

---A tab's content frame from Tabs:CreateTabFrameContainer.
---@class TRB.Classes.OptionsUi.TabSheet : Frame, BackdropTemplate
---@field public visibilityHeader Frame? # Pinned header above the scroll frame
---@field public scrollFrame TRB.Classes.OptionsUi.ScrollContainer? # Absent on tabs that scroll themselves
---@field public constructorFrame Frame # Where the tab's lazy constructor builds its controls
---@field public selected boolean?

---A tab button from Tabs:CreateTab.
---@class TRB.Classes.OptionsUi.Tab : Button, BackdropTemplate
---@field public id string
---@field public bottomCover Texture # Hides the bottom border so the selected tab joins its sheet
---@field public Text FontString
---@field public isBarDisabled boolean? # The tab's bar is set to Never Show

---A frame holding a tab strip and its sheets, from Tabs:BuildTabGroup.
---@class TRB.Classes.OptionsUi.TabbedPanel : Frame
---@field public tabs table<string, TRB.Classes.OptionsUi.Tab>
---@field public tabsheets table<string, TRB.Classes.OptionsUi.TabSheet>
---@field public lastTab TRB.Classes.OptionsUi.TabSheet
---@field public lastTabId string
---@field public tabOrder string[]
---@field public tabConstructors table<string, function> # Built on first show

---An audio cue editor config control: a checkbox, a labeled dropdown, or a slider.
---@class TRB.Classes.OptionsUi.CueConfigControl : Frame
---@field public isSlider boolean
---@field public isDropdown boolean
---@field public label TRB.Classes.OptionsUi.SectionHeader? # Dropdowns only
---@field public tooltip string? # Checkboxes only, shown by their template's OnEnter

---A section's "Use Global" checkbox, with what follows its clicks.
---@class TRB.Classes.OptionsUi.UseGlobalCheckbox : ChatConfigCheckButtonTemplate
---@field public useGlobalLinked { header: TRB.Classes.OptionsUi.SectionHeader, tooltip: string, cover: Frame? }[]? # Covers and header badges shown while it is checked
---@field public useGlobalLink TRB.Classes.OptionsUi.UseGlobalLink? # Shortcut beside it to the global settings

---The shortcut beside a Use Global checkbox that opens the global settings.
---@class TRB.Classes.OptionsUi.UseGlobalLink : Button
---@field public tooltip string?
---@field public coverButtonText string # Label of the Open button on the section's cover
---@field public OpenGlobalTab fun(tabKey: string?) # Opens the global category on its own tab, or on tabKey

---A Global panel toggle that sets one section's Use Global flag on every spec.
---@class TRB.Classes.OptionsUi.BulkGlobalToggle : ChatConfigCheckButtonTemplate
---@field public settingKey string
---@field public specCount FontString # How many specs use the section's global settings

---An options navigation button.
---@class TRB.Classes.OptionsUi.NavButton : Button
---@field public selectedTexture Texture
---@field public icon Texture?
---@field public label FontString
---@field public arrow Texture? # Class headers only

---An EditBox with Ctrl+Z / Ctrl+Y history, from BarTextInput:AttachUndoRedo.
---@class TRB.Classes.OptionsUi.UndoEditBox : EditBox
---@field public undoHistory string[] # Text snapshots, oldest first
---@field public undoCursors integer[] # Cursor position for each snapshot
---@field public undoIndex integer # The snapshot currently shown
---@field public undoSuppress boolean # True while the text is being set programmatically
---@field public undoTimer FunctionContainer? # The pending debounced snapshot
---@field public ResetUndoHistory fun(self: TRB.Classes.OptionsUi.UndoEditBox, initialText: string?)

---A dropdown that keeps its menu generator, so the menu can be rebuilt after its choices change.
---@class TRB.Classes.OptionsUi.RegeneratingDropdown : WowStyle1DropdownTemplate
---@field public GeneratorFunction fun(owner: any, rootDescription: table)

---A LibSharedMedia texture dropdown, which checks the radio of the saved name it was last pointed at.
---@class TRB.Classes.OptionsUi.LsmDropdown : TRB.Classes.OptionsUi.RegeneratingDropdown
---@field public label table
---@field public lsmType string
---@field public selectedName string?

---The profile picker, which relabels itself with the active profile.
---@class TRB.Classes.OptionsUi.ProfileDropdown : TRB.Classes.OptionsUi.RegeneratingDropdown
---@field public UpdateButtonText fun(self: TRB.Classes.OptionsUi.ProfileDropdown?)

---A dropdown from Primitives:BuildDropdown, with its optional section label.
---@class TRB.Classes.OptionsUi.Dropdown : WowStyle1DropdownTemplate
---@field public label TRB.Classes.OptionsUi.SectionHeader?

---A color swatch button.
---@class TRB.Classes.OptionsUi.ColorSwatch : Button, BackdropTemplate
---@field public Texture Texture # The swatch fill

---A labeled color swatch from ColorPickers:BuildColorPicker.
---@class TRB.Classes.OptionsUi.ColorPicker : TRB.Classes.OptionsUi.ColorSwatch
---@field public Font TRB.Classes.OptionsUi.BadgedText

---The gradient direction cycle button beside a gradient picker's swatches.
---@class TRB.Classes.OptionsUi.GradientDirectionButton : Button, BackdropTemplate
---@field public Font FontString

---A two-swatch gradient picker from ColorPickers:BuildGradientColorPicker.
---@class TRB.Classes.OptionsUi.GradientColorPicker : Frame
---@field public Swatch1 TRB.Classes.OptionsUi.ColorSwatch
---@field public Swatch2 TRB.Classes.OptionsUi.ColorSwatch
---@field public DirectionButton TRB.Classes.OptionsUi.GradientDirectionButton
---@field public Font TRB.Classes.OptionsUi.BadgedText
---@field public Texture Texture # Swatch1's fill, for callers that treat both picker kinds alike
---@field public UpdateSwatch2State fun() # Dims the second swatch while the gradient is disabled
---@field public readOnlyTooltip string? # Set while ColorPickers:SetGradientColorPickerReadOnly locks it: where its color comes from
---@field public readOnlyHooked boolean? # The first swatch's read-only tooltip hooks are installed

---@class TRB.Classes.OptionsUi.Color
---@field public name string
---@field public colorLocalization string
---@field public colorScript function?
---@field public hasEnabledCheckbox boolean?
---@field public enabledCheckboxLocalization string?
---@field public enabledCheckboxTooltipLocalization string?

---A single flat or gradient indicator definition for the Indicator Colors panel.
---@class TRB.Classes.OptionsUi.IndicatorDef
---@field public key string Indicator key matching the entry in colors.shared.indicatorColors
---@field public label string Localized checkbox/dropdown display name
---@field public tooltip string Localized tooltip text (bar-agnostic)
---@field public colorLabel string Localized color picker label (bar-agnostic)
---@field public cdm TRB.CdmDependency? Declared Cooldown Manager reliance, shown as a badge on the row. Options-panel only; nothing branches on it at runtime.
---@field public barKeys string[]? The only bars its target menu offers; every bar when nil
---@field public custom boolean? A user-defined indicator, built from colors.shared rather than spec code

---An element of a bar that an indicator can recolor.
---@class TRB.Classes.OptionsUi.BarElementDef
---@field public key string Element key, matching the key in that bar's color settings (e.g. "bar", "border", "channel", "tick")
---@field public label string Localized element display name

---A bar target that indicators can be assigned to.
---@class TRB.Classes.OptionsUi.BarTargetDef
---@field public key string Bar key (e.g., "furyBar", "insanityBar", "manaBar")
---@field public label string Localized bar display name
---@field public elements TRB.Classes.OptionsUi.BarElementDef[]? Elements this bar offers; defaults to bar/border/background
---@field public gradientExcluded table<string, boolean>? Elements of this bar that cannot take a gradient indicator's color curve (e.g. a fill already driven by another curve, or a drawn texture rather than a node color)

---End-of-buff configuration for a single buff tracked by the Indicator Colors panel.
---@class TRB.Classes.OptionsUi.EndOfConfig
---@field public endOfKey string Key matching endOf.* in spec settings
---@field public sectionHeader string Localized section header text
---@field public gcdRadioLabel string Localized label for the GCD radio button
---@field public gcdSliderLabel string Localized label for the GCD slider
---@field public timeRadioLabel string Localized label for the time radio button
---@field public timeSliderLabel string Localized label for the time slider

---Minimum-stacks configuration for a single stacking buff tracked by the Indicator Colors panel.
---@class TRB.Classes.OptionsUi.StacksConfig
---@field public stacksKey string Key matching stacks.* in spec settings
---@field public sectionHeader string Localized section header text
---@field public sliderLabel string Localized label for the minimum stacks slider
---@field public sliderMin integer? Lowest selectable stack count (default: 1)
---@field public sliderMax integer Highest selectable stack count

---Overcap configuration for the Indicator Colors panel.
---@class TRB.Classes.OptionsUi.OvercapConfig
---@field public primaryResourceString string Localized primary resource name (e.g., L["ResourceFury"])
---@field public primaryResourceMax number Maximum value of the primary resource

---Configuration for GenerateIndicatorColorsPanel.
---@class TRB.Classes.OptionsUi.IndicatorColorsPanelConfig
---@field public indicatorDefs TRB.Classes.OptionsUi.IndicatorDef[] Flat indicator definitions
---@field public gradientDefs TRB.Classes.OptionsUi.IndicatorDef[]? Gradient indicator definitions (default: {})
---@field public barTargetDefs TRB.Classes.OptionsUi.BarTargetDef[] Bar targets
---@field public excludedElements table<string, table<string, boolean>>? Map of barKey -> { elementKey = true } to exclude from ALL indicator dropdowns (flat and gradient)
---@field public gradientExcludedElements table<string, table<string, boolean>>? Map of barKey -> { elementKey = true } to exclude from gradient dropdowns only
---@field public ddNamePrefix string Unique prefix for dropdown frame names (e.g., "TwintopResourceBar_Priest_Shadow")
---@field public endOfConfigs TRB.Classes.OptionsUi.EndOfConfig[]? List of EndOf configuration entries
---@field public stacksConfigs TRB.Classes.OptionsUi.StacksConfig[]? List of minimum-stacks configuration entries
---@field public overcapConfig TRB.Classes.OptionsUi.OvercapConfig? Overcap configuration
---@field public thresholdLabels table<string, string>? The Thresholds tab's names by settingKey, for the Threshold Line menu; unnamed lines use the spell's name
TRB.Classes.OptionsUi.IndicatorColorsPanelConfig = {}
TRB.Classes.OptionsUi.IndicatorColorsPanelConfig.__index = TRB.Classes.OptionsUi.IndicatorColorsPanelConfig

---Creates a new IndicatorColorsPanelConfig.
---@param data TRB.Classes.OptionsUi.IndicatorColorsPanelConfig
---@return TRB.Classes.OptionsUi.IndicatorColorsPanelConfig
function TRB.Classes.OptionsUi.IndicatorColorsPanelConfig:New(data)
	local obj = setmetatable({}, TRB.Classes.OptionsUi.IndicatorColorsPanelConfig)
	obj.indicatorDefs = data.indicatorDefs
	obj.gradientDefs = data.gradientDefs
	obj.barTargetDefs = data.barTargetDefs
	obj.excludedElements = data.excludedElements
	obj.gradientExcludedElements = data.gradientExcludedElements
	obj.ddNamePrefix = data.ddNamePrefix
	obj.endOfConfigs = data.endOfConfigs
	obj.stacksConfigs = data.stacksConfigs
	obj.overcapConfig = data.overcapConfig
	obj.thresholdLabels = data.thresholdLabels
	return obj
end