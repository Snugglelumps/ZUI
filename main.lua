local _, SnugUI = ...

SnugUISettings = SnugUISettings or {}
SnugUI.settings = SnugUISettings

---<==========================================================================================>---<<3.1 Reload Indicator
function SnugUI.functions.reloadUIRequest()
    SnugUI.settings.reloadUI = SnugUI.settings.reloadUI or false
    if SnugUI.settings.reloadUI then return end

    local reloadButton = SnugUI.buttons.reload
    if not reloadButton then return end

    if not reloadButton.reloadNote then
        local note = reloadButton:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        note:SetPoint("LEFT", reloadButton, "RIGHT", 10, 0)
        note:SetText("|cffffcc00**Reload required|r")
        reloadButton.reloadNote = note
    end

    reloadButton.reloadNote:Show()

    SnugUI.settings.reloadUI = true
end
---<=========================================================================================>---<<3.2 Anchor Dimensions
local function initAnchorDimensions()
    local panel = SnugUI.panels.general
    local UIclientWidth, UIclientHeight = UIParent:GetWidth(), UIParent:GetHeight()

    local widthInput = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    widthInput:SetSize(60, 20)
    widthInput:SetPoint("TOPLEFT", panel, "TOPLEFT", 108, -60)
    widthInput:SetAutoFocus(false)
    widthInput:SetNumeric(true)
    widthInput:SetText(tostring(SnugUI.settings.anchorWidth))
    widthInput:SetScript("OnTextChanged", function(self)
        local value = tonumber(self:GetText())
        if not value then
            return -- do nothing if input is empty or not a number
        end
        if value > math.floor(0.5 + UIclientWidth / 2) then
            SnugUI.settings.anchorWidth = math.floor(0.5 + UIclientWidth / 2)
            widthInput:SetText(tostring(SnugUI.settings.anchorWidth))
        elseif value >= 1 then
            SnugUI.settings.anchorWidth = value
        end
    end)
    local widthLabel = widthInput:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    widthLabel:SetPoint("BOTTOM", widthInput, "TOP", -4, 4)
    widthLabel:SetText("Width")

    local heightInput = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    heightInput:SetSize(60, 20)
    heightInput:SetPoint("TOPLEFT", panel, "TOPLEFT", 32, -60)
    heightInput:SetAutoFocus(false)
    heightInput:SetNumeric(true)
    heightInput:SetText(tostring(SnugUI.settings.anchorHeight))
    heightInput:SetScript("OnTextChanged", function(self)
        local value = tonumber(self:GetText())
        if not value then
            return -- do nothing if input is empty or not a number
        end
        if value > math.floor(0.5 + UIclientHeight) then
            SnugUI.settings.anchorHeight = math.floor(0.5 + UIclientHeight)
            heightInput:SetText(tostring(SnugUI.settings.anchorHeight))
        elseif value >= 1 then
            SnugUI.settings.anchorHeight = value
        end
    end)
    local heightLabel = heightInput:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heightLabel:SetPoint("BOTTOM", heightInput, "TOP", -3, 4)
    heightLabel:SetText("Height")

    if SnugUI.settings.debug then
        local pw, ph = GetPhysicalScreenSize()
        local uw, uh = UIParent:GetWidth(), UIParent:GetHeight()
        print("Physical:", pw, ph)
        print("UIParent:", uw, uh)
    end
end

---<========================================================================================>---<<3.3 Anchor Assignments
local anchorOptions = { "", "Chat", "Details!" }

local function CreateAnchorDropdown(parent, key, x, y)
    SnugUI.dropdowns = SnugUI.dropdowns or {}

    -- Dropdown
    local dropdown = CreateFrame("Frame", "SnugUIAnchorDropdown" .. key, parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPRIGHT", parent, "TOPRIGHT", x, y)
    UIDropDownMenu_SetWidth(dropdown, 90)
    SnugUI.dropdowns[key] = dropdown

    -- Label
    local label = dropdown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("BOTTOM", dropdown, "TOP", 0, 4)
    label:SetText((key == "left") and "Left Anchor" or "Right Anchor")

    -- Menu Initialization
    UIDropDownMenu_Initialize(dropdown, function(self, level)
        for _, option in ipairs(anchorOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = (option == "") and "—" or option
            info.value = option
            info.checked = (SnugUI.settings.anchorAssignments[key] == option)
            info.func = function(selfArg)
                local otherKey = (key == "left") and "right" or "left"
                if SnugUI.settings.anchorAssignments[otherKey] == selfArg.value then
                    SnugUI.settings.anchorAssignments[otherKey] = ""
                    local otherDrop = SnugUI.dropdowns[otherKey]
                    if otherDrop then
                        UIDropDownMenu_SetSelectedValue(otherDrop, "")
                        _G[otherDrop:GetName() .. "Text"]:SetText("—")
                    end
                end
                SnugUI.settings.anchorAssignments[key] = selfArg.value
                UIDropDownMenu_SetSelectedValue(dropdown, selfArg.value)
                _G[dropdown:GetName() .. "Text"]:SetText((selfArg.value == "") and "—" or selfArg.value)
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    -- Initial Value
    local value = SnugUI.settings.anchorAssignments[key]
    if not tContains(anchorOptions, value) then
        value = ""
        SnugUI.settings.anchorAssignments[key] = value
    end
    UIDropDownMenu_SetSelectedValue(dropdown, value)
    _G[dropdown:GetName() .. "Text"]:SetText((value == "") and "—" or value)

    return dropdown
end

local function initAnchorAssignments()
    CreateAnchorDropdown(SnugUI.panels.general, "left", -128, -58)
    CreateAnchorDropdown(SnugUI.panels.general, "right", -10, -58)
end

---<==========================================================================================>---<<3.4 Minimap Settings
local minimapStyleOptions = { "SnugUI", "Blizzard" }

local function initMinimapSettings()
    local panel = SnugUI.panels.general

    -- Create dropdown
    local dropdown = CreateFrame("Frame", "SnugUIMinimapStyleDropdown", panel, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", panel, "TOPLEFT", 160, -166)
    UIDropDownMenu_SetWidth(dropdown, 120)

    -- Create label above the dropdown
    local label = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("BOTTOM", dropdown, "TOP", 0, 4)
    label:SetText("Minimap Style:")

    UIDropDownMenu_Initialize(dropdown, function(self, level)
        for _, option in ipairs(minimapStyleOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = option
            info.value = option
            info.checked = (SnugUI.settings.minimapStyle == option)
            info.func = function(selfArg)
                SnugUI.settings.minimapStyle = selfArg.value
                UIDropDownMenu_SetSelectedValue(dropdown, selfArg.value)
                _G[dropdown:GetName() .. "Text"]:SetText(selfArg.value)
                SnugUI.functions.reloadUIRequest()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    local value = SnugUI.settings.minimapStyle
    if not tContains(minimapStyleOptions, value) then
        value = "SnugUI"
        SnugUI.settings.minimapStyle = value
    end
    UIDropDownMenu_SetSelectedValue(dropdown, value)
    _G[dropdown:GetName() .. "Text"]:SetText(value)
end

---<=============================================================================================>---<<3.5 Chat Settings
local tabOptions = { "SnugUI", "Blizzard" }
local function CreateTabSystemDropdown()
    local panel = SnugUI.panels.general

    local dropdown = CreateFrame("Frame", "SnugUITabSystemDropdown", panel, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -166)
    UIDropDownMenu_SetWidth(dropdown, 120)

    local label = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("BOTTOM", dropdown, "TOP", 0, 4)
    label:SetText("Chat Tab Style:")

    UIDropDownMenu_Initialize(dropdown, function(self, level)
        for _, option in ipairs(tabOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = option
            info.value = option
            info.checked = (SnugUI.settings.tabSystem == option)
            info.func = function(selfArg)
                SnugUI.settings.tabSystem = selfArg.value
                UIDropDownMenu_SetSelectedValue(dropdown, selfArg.value)
                _G[dropdown:GetName() .. "Text"]:SetText(selfArg.value)
                SnugUI.functions.reloadUIRequest()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    local value = SnugUI.settings.tabSystem
    if not tContains(tabOptions, value) then
        value = "SnugUI"
        SnugUI.settings.tabSystem = value
    end
    UIDropDownMenu_SetSelectedValue(dropdown, value)
    _G[dropdown:GetName() .. "Text"]:SetText(value)
end

---<============================================================================================>---<<3.6 Details! Panel
local panel = SnugUI.panels.details

local header = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
header:SetPoint("TOPLEFT", 16, -16)
header:SetText("Use the string below to import the SnugUI profile for Details!")

local scrollFrame = CreateFrame("ScrollFrame", "SnugUIDetailsExportScroll", panel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 16, -48)
scrollFrame:SetPoint("BOTTOMRIGHT", -32, 16)

local bg = CreateFrame("Frame", nil, scrollFrame, "BackdropTemplate")
bg:SetPoint("TOPLEFT", -4, 4)
bg:SetPoint("BOTTOMRIGHT", 4, -4)
bg:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
bg:SetBackdropColor(0, 0, 0, 0.4)
bg:SetBackdropBorderColor(1, 1, 1, 0.6)

local exportBox = CreateFrame("EditBox", "SnugUIDetailsExportBox", scrollFrame)
exportBox:SetMultiLine(true)
exportBox:SetFontObject("GameFontHighlightSmall")
exportBox:SetWidth(400)
exportBox:SetAutoFocus(false)
exportBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
exportBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
exportBox:SetScript("OnTextChanged", function(self)
    scrollFrame:UpdateScrollChildRect()
end)

scrollFrame:SetScrollChild(exportBox)
local function setDetailsExportBox()
    exportBox:SetText(Details_Profile or "No export data found.")
end
---<======================================================================================>---<<3.7 Buttons and Commands
SLASH_SnugUI1 = "/sui"
SlashCmdList["SnugUI"] = function()
    if SnugUI.frames.BG:IsShown() then
        SnugUI.frames.BG:Hide()
    else
        SnugUI.frames.BG:Show()
    end
end
SnugUI.loginTrigger(function()
    C_Timer.After(0.1, function()
        if SnugUI.settings.debug then
            SnugUI.frames.BG:Show()
        end
    end)
end)

SnugUI.buttons.apply:SetScript("OnClick", function()
    for _, func in ipairs(SnugUI.commitRegistry) do
        if type(func) == "function" then
            pcall(func)
        end
    end
end)
local function buttonTooltips()
    SnugUI.buttons.apply:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Applies layout changes immediately", 1, 1, 1)
        GameTooltip:Show()
    end)
end

SnugUI.buttons.reload:SetScript("OnClick", function()
    ReloadUI()
end)

SnugUI.buttons.close:SetScript("OnClick", function()
    SnugUI.frames.BG:Hide()
end)

---<================================================================================================>---<<3.8 About Page
local panel = SnugUI.panels.about
local function CreateAboutLine(text, font, anchorTo, offsetX, offsetY)
    local line = panel:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
    line:SetPoint("TOPLEFT", anchorTo or panel, offsetX or 16, offsetY or -16)
    line:SetJustifyH("LEFT")
    line:SetText(text)
    return line
end

-- Title
local title = CreateAboutLine("About SnugUI", "GameFontNormalLarge", nil, 16, -16)

local missionStatement = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
missionStatement:SetPoint("TOPLEFT", 16, -32)
missionStatement:SetWidth(440) -- or however wide your about panel is
missionStatement:SetJustifyH("LEFT")
missionStatement:SetJustifyV("TOP")
missionStatement:SetTextColor(1, 1, 1)
missionStatement:SetText("SnugUI is a lightweight UI style that brings everything together with minimal fuss. It aims to unify your interface visually while staying out of the way, using clean, efficient tweaks to keep things cohesive without overcomplicating.")

local recAddons = CreateAboutLine("Recommended", "GameFontNormal", nil, 32, -96)
local recAddons = CreateAboutLine("Addons", "GameFontNormal", nil, 75, -112)

local function CreateThanksEntry(parent, x, y, name, author, url)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOPLEFT", x, y)
    label:SetText("|cffffffff•|r |cff00ccff" .. name .. "|r by " .. author)

    local editBox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    editBox:SetSize(320, 18)
    editBox:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 13, 4)
    editBox:SetText(url)
    editBox:SetAutoFocus(false)
    editBox:SetScript("OnEscapePressed", editBox.ClearFocus)
    editBox:SetScript("OnEditFocusGained", function(self)
        self:HighlightText()
    end)

    editBox.Left:Hide()
    editBox.Middle:Hide()
    editBox.Right:Hide()
    editBox:SetFontObject("GameFontHighlightSmall")

    return label, editBox
end

CreateThanksEntry(panel, 148, -96, "Masque", "StormFX", "https://www.curseforge.com/wow/addons/masque")
CreateThanksEntry(panel, 148, -128, "Masque_SnugUI", "Snugglelumps", "https://www.curseforge.com/wow/addons/masque_SnugUI")
CreateThanksEntry(panel, 148, -160, "Details! Damage Meter", "Tercioo", "https://www.curseforge.com/wow/addons/details")
CreateThanksEntry(panel, 148, -192, "Prat 3.0", "sylvanaar", "https://www.curseforge.com/wow/addons/prat-3-0")

local specialThanks = CreateAboutLine("Special Thanks", "GameFontNormal", nil, 33, -232)

local function CreateSpecialEntry(parent, x, y, name, author, url)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOPLEFT", x, y)
    label:SetText("|cffffffff•|r |cff00ccff" .. name .. "|r by " .. author)

    local editBox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    editBox:SetSize(320, 18)
    editBox:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 13, 4)
    editBox:SetText(url)
    editBox:SetAutoFocus(false)
    editBox:SetScript("OnEscapePressed", editBox.ClearFocus)
    editBox:SetScript("OnEditFocusGained", function(self)
        self:HighlightText()
    end)

    editBox.Left:Hide()
    editBox.Middle:Hide()
    editBox.Right:Hide()
    editBox:SetFontObject("GameFontHighlightSmall")

    return label, editBox
end

CreateSpecialEntry(panel, 148, -232, "DevTool", "brittyazel", "https://github.com/brittyazel")
CreateSpecialEntry(panel, 148, -264, "TextureAtlasViewer", "LanceDH", "https://github.com/LanceDH")

local thankyou = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
thankyou:SetPoint("TOPLEFT", 16, -306)
thankyou:SetWidth(440) -- or however wide your about panel is
thankyou:SetJustifyH("LEFT")
thankyou:SetJustifyV("TOP")
thankyou:SetTextColor(1, 1, 1)
thankyou:SetText("And a general thanks to all of you who take the time to build something for the game you love (and leave helpful comments). This is the first time I have tried anything like this, without the vast endeavors of this community I would not have made it very far. --|cff00ccffSnugglelumps|r")

---<===========================================================================================================>---<<AUX
SnugUI.loginTrigger(function()
    -- Initialization
    initAnchorDimensions()
    initAnchorAssignments()
    initMinimapSettings()
    CreateTabSystemDropdown()
    setDetailsExportBox()
    --buttonTooltips()
end)
