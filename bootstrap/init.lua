local _, zui = ...

ZUISettings = ZUISettings or {}
zui.settings = ZUISettings

zui.frames         = zui.frames or {}
zui.panels         = zui.panels or {}
zui.buttons        = zui.buttons or {}
zui.commitRegistry = zui.commitRegistry or {}

zui.settings.anchorAssignments = zui.settings.anchorAssignments or {}

function zui.assertSettings()
    local defaults = {
        anchorAssignments = {
            left  = "Chat",
            right = "Details!",
        },
        anchorWidth  = 420,
        anchorHeight = 200,
        tabSystem = "ZUI",
        minimapStyle = "ZUI",
    }

    local function applyDefaults(target, source)
        for key, value in pairs(source) do
            if type(value) == "table" then
                if type(target[key]) ~= "table" then
                    target[key] = {}
                end
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
f:SetScript("OnEvent", function(self, event, name)
    if name ~= "ZUI" then return end -- replace with your actual folder/addon name
    ZUISettings = ZUISettings or {}
    zui.settings = ZUISettings
    zui.assertSettings()
    if zui.settings.reloadUI then
        zui.settings.reloadUI = false
    end
    zui.settings.debug = false
end)

function zui.loginTrigger(callback)
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_LOGIN")
    f:SetScript("OnEvent", function(self)
        zui.commitRegistry = zui.commitRegistry or {}
        callback()
        self:UnregisterAllEvents()
        self:SetScript("OnEvent", nil)
    end)
end