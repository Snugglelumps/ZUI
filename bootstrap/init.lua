local _, zui = ...

---<=======================================================================================>---<<1.1 Tables and Settings
---<===================================================================================[Initializes tables and settings]
-- Ensure SavedVariables table exists
ZUISettings = ZUISettings or {}
zui.settings = ZUISettings

zui.frames         = zui.frames or {}
zui.panels         = zui.panels or {}
zui.buttons        = zui.buttons or {}
zui.commitRegistry = zui.commitRegistry or {}
zui.settings.anchorAssignments = zui.settings.anchorAssignments or {}

-- Define settings assertion and apply via the ADDON_LOADED handler
function zui.assertSettings()
    local defaults = {
        anchorAssignments = { left = "Chat", right = "Details!" },
        anchorWidth       = 420,
        anchorHeight      = 200,
        tabSystem         = "ZUI",
        minimapStyle      = "ZUI",
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

    applyDefaults(zui.settings, defaults)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
    if name ~= "ZUI" then return end
    ZUISettings = ZUISettings or {}
    zui.settings = ZUISettings
    zui.assertSettings()
    if zui.settings.reloadUI then zui.settings.reloadUI = false end
    zui.settings.debug = true
end)

local loginQueue = {}

function zui.loginTrigger(callback)
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
