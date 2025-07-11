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
--SnugUI.settings.anchorAssignments = SnugUI.settings.anchorAssignments or {}

SnugUI.settings.anchors         = SnugUI.settings.anchors or {}
SnugUI.settings.chat            = SnugUI.settings.chat or {}
SnugUI.settings.minimap         = SnugUI.settings.minimap or {}
SnugUI.settings.qol             = SnugUI.settings.qol or {}

SnugUI.functions                = SnugUI.functions or {}

-- Define settings assertion and apply via the ADDON_LOADED handler
local function initializeSettings()
    local defaults = {
        --tabSystem         = "SnugUI",
        chat = {
            tabstyle = "SnugUI",
        },
        minimapStyle      = "SnugUI", --old defaults end
        anchors = {
            width = 420,
            height = 200,
            leftAssignment = "Chat",
            rightAssignment = "Details!",
        },
        minimap = {
            style = "SnugUI",
            scale = 1,
            lockTracker = true,
            hideWorldMapButton = true,
        },
        qol ={
            questButton = true,
            questHotkey = "G",
        },
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

--solitary use of ADDON_LOADED for settings initialization, if used elsewhere consider C_Timer.After in conjunction
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
    if name ~= "SnugUI" then return end
    SnugUISettings = SnugUISettings or {}
    SnugUI.settings = SnugUISettings
    initializeSettings()
    if SnugUI.settings.reloadUI then SnugUI.settings.reloadUI = false end
    SnugUI.settings.debug = true
end)

local loginQueue = {}

function SnugUI.loginTrigger(callback)
    table.insert(loginQueue, callback)
end

--initiates a table for a queue of functions that will init on login
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

function SnugUI.functions.debugNamespace()
    if not SnugUI.settings or not SnugUI.settings.debug then return end

    print("=========== SnugUI Namespace ===========")

    for key, value in pairs(SnugUI) do
        local valueType = type(value)
        if valueType == "function" then
            print("🧠 function:", key)
        elseif valueType == "table" then
            print("📦 table:", key)
        else
            print("🔹", key, "=", tostring(value))
        end
    end

    print("=========== end ===========")
end

SnugUI.loginTrigger(function()
    C_Timer.After(3, function()
        SnugUI.functions.debugNamespace()
    end)
end)
