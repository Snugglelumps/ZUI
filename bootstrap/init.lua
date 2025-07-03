local _, SnugUI = ...

---<=======================================================================================>---<<1.1 Tables and Settings
---<===================================================================================[Initializes tables and settings]
-- Ensure SavedVariables table exists
SnugUISettings = SnugUISettings or {}
SnugUI.settings = SnugUISettings

SnugUI.frames         = SnugUI.frames or {} -- mostly background frames
SnugUI.panels         = SnugUI.panels or {} -- content panels for settings UI
SnugUI.buttons        = SnugUI.buttons or {}
SnugUI.commitRegistry = SnugUI.commitRegistry or {}
SnugUI.settings.anchorAssignments = SnugUI.settings.anchorAssignments or {}

SnugUI.settings.anchors      =SnugUI.settings.anchors or {}
SnugUI.settings.minimap      =SnugUI.settings.minimap or {}
SnugUI.functions             =SnugUI.functions or {}


-- Define settings assertion and apply via the ADDON_LOADED handler
local function initializeSettings()
    local defaults = {
        anchorAssignments = { left = "Chat", right = "Details!" },
        anchorWidth       = 420,
        anchorHeight      = 200,
        tabSystem         = "SnugUI",
        minimapStyle      = "SnugUI",
    }

    local function applyDefaults(target, source)
        for key, value in pairs(source) do
            if type(value) == "table" then
                if type(target[key]) ~= "table" then target[key] = {} end
                applyDefaults(target[key], value)
            elseif target[key] == nil then
                target[key] = value
            end
        end
    end

    applyDefaults(SnugUI.settings, defaults)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
    if name ~= "SnugUI" then return end
    SnugUISettings = SnugUISettings or {}
    SnugUI.settings = SnugUISettings
    initializeSettings()
    if SnugUI.settings.reloadUI then SnugUI.settings.reloadUI = false end
    SnugUI.settings.debug = false
end)

local loginQueue = {}

function SnugUI.loginTrigger(callback)
    table.insert(loginQueue, callback)
end

local loginFrame = CreateFrame("Frame")
loginFrame:RegisterEvent("PLAYER_LOGIN")
loginFrame:SetScript("OnEvent", function(self)
    for _, fn in ipairs(loginQueue) do
        pcall(fn)
    end
    wipe(loginQueue)
    self:UnregisterAllEvents()
    self:SetScript("OnEvent", nil)
end)
