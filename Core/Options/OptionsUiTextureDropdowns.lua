local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.TextureDropdowns = TRB.Functions.OptionsUi.TextureDropdowns or {}
local oUi = TRB.Data.constants.optionsUi

-- ============================================================================
-- LibSharedMedia texture dropdown helpers
-- ============================================================================
local lsm = TRB.Details.addonData.libs.SharedMedia

-- Each texture type's entries as { name, path }. Refilled in place, so built dropdowns see new media.
local texturePairs = { statusbar = {}, background = {}, border = {} }

---Fills one texture type's entries from LibSharedMedia.
---@param lsmType string
local function FillTexturePairs(lsmType)
	local list = texturePairs[lsmType]
	wipe(list)
	local paths = lsm:HashTable(lsmType)
	for _, name in ipairs(lsm:List(lsmType)) do
		list[#list + 1] = { name, paths[name] }
	end
end

---One texture type's entries, filled the first time they are needed.
---@param lsmType string
---@return table
local function GetTexturePairs(lsmType)
	if #texturePairs[lsmType] == 0 then
		FillTexturePairs(lsmType)
	end
	return texturePairs[lsmType]
end

---Refills the texture entries already built, after more media registers.
function TRB.Functions.OptionsUi.TextureDropdowns:RefreshCaches()
	for lsmType, list in pairs(texturePairs) do
		if #list > 0 then
			FillTexturePairs(lsmType)
		end
	end
end

---Refreshes a WowStyle1DropdownTemplate control by re-invoking its stored GeneratorFunction.
---@param control TRB.Classes.OptionsUi.RegeneratingDropdown # The dropdown control with a GeneratorFunction field
local function DropdownSetupMenuWrapper(control)
	if control == nil then
		return
	end

	control:SetupMenu(control.GeneratorFunction)
end

local function SetDropdownDisplayText(control, text)
	if control == nil or text == nil then
		return
	end

	if type(control.SetDefaultText) == "function" then
		control:SetDefaultText(text)
	end
	if type(control.SetText) == "function" then
		control:SetText(text)
	elseif control.Text ~= nil and type(control.Text.SetText) == "function" then
		control.Text:SetText(text)
	end
end

---Points a texture dropdown at a saved name: the radio it checks, and its label, marked while the name isn't loaded.
---@param control TRB.Classes.OptionsUi.LsmDropdown?
---@param name string?
local function RefreshLsmDropdown(control, name)
	if control == nil then
		return
	end

	control.selectedName = name
	DropdownSetupMenuWrapper(control)
	SetDropdownDisplayText(control, TRB.Functions.LibSharedMedia:GetDisplayName(control.lsmType, name))
end

---@param control TRB.Classes.OptionsUi.LsmDropdown? # The dropdown control to refresh
---@param name string? # The saved texture name the dropdown shows and checks
function TRB.Functions.OptionsUi.TextureDropdowns:RefreshLsmDropdown(control, name)
	RefreshLsmDropdown(control, name)
end

---Creates a LibSharedMedia dropdown for selecting a statusbar, background, or border texture.
---@param parent Frame # The parent frame
---@param dropDowns table # Table to store the created dropdown control
---@param section table # The settings table containing the current texture selection (e.g., spec.textures)
---@param classId integer # The WoW class ID
---@param specId integer # The WoW specialization ID
---@param xCoord number # X position for the dropdown
---@param yCoord number # Y position for the dropdown label
---@param lsmType string # The LibSharedMedia type ("statusbar", "background", or "border")
---@param varName string # The key in the section table for this texture setting
---@param sectionHeaderText string # Label text displayed above the dropdown
---@param dropdownInfoText string # Informational text for the dropdown (unused in current implementation)
---@param setSelectedFunc fun(path: string, name: string) # Callback invoked when a new texture is selected
---@param namePrefix string? # Frame name prefix; defaults to the class and specialization, which tabs listing the same bar must not share
function TRB.Functions.OptionsUi.TextureDropdowns:CreateLsmDropdown(parent, dropDowns, section, classId, specId, xCoord, yCoord, lsmType, varName, sectionHeaderText, dropdownInfoText, setSelectedFunc, namePrefix)
	if namePrefix == nil then
		local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
		namePrefix = className .. "_" .. specName
	end

	local lsmPairs = GetTexturePairs(lsmType)

	local dropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. varName .. "_" .. lsmType, parent, "WowStyle1DropdownTemplate") --[[@as TRB.Classes.OptionsUi.LsmDropdown]]
	dropDowns[varName] = dropdown
	dropdown:SetWidth(oUi.sliderWidth)
	dropdown.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, sectionHeaderText, xCoord, yCoord)
	dropdown.label.font:SetFontObject(GameFontNormal)
	dropdown.lsmType = lsmType
	dropdown.selectedName = section[varName .. "Name"]

	-- By name, since a saved path can be stale and several names can share one file.
	local function IsSelected(pair)
		return pair[1] == dropdown.selectedName
	end

	local function SetSelected(pair)
		dropdown.selectedName = pair[1]
		setSelectedFunc(pair[2], pair[1])
	end

	local function Generator(_, rootDescription)
		for _, v in ipairs(lsmPairs) do
			local radio = rootDescription:CreateRadio(v[1], IsSelected, SetSelected, v)
			radio:AddInitializer(function(button, description, menu)
				local rightTexture = button:AttachTexture()
				rightTexture:SetSize(1, 18)
				rightTexture:SetPoint("RIGHT")
				local fontString = button.fontString

				local bgTexture = button:AttachTexture()
				bgTexture:SetTexture(v[2])
				bgTexture:SetDrawLayer("BACKGROUND")
				bgTexture:SetPoint("LEFT", button.fontString, "LEFT")
				bgTexture:SetPoint("RIGHT", rightTexture, "LEFT")
				bgTexture:SetSize(button.fontString:GetUnboundedStringWidth(), 16)

				-- Ensure text is drawn on top of the texture
				fontString:SetDrawLayer("OVERLAY")

				-- Manual calculation required to accomodate aligned text.
				local pad = 0
				local width = pad + fontString:GetUnboundedStringWidth() + rightTexture:GetWidth()
				local height = 20
				return width, height
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	dropdown.GeneratorFunction = Generator
	dropdown:SetupMenu(Generator)
	SetDropdownDisplayText(dropdown, TRB.Functions.LibSharedMedia:GetDisplayName(lsmType, dropdown.selectedName) or dropdownInfoText)
	dropdown:SetPoint("TOPLEFT", xCoord, yCoord-30)
end
