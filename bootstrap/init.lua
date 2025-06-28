ZUISettings = ZUISettings or {}
zui.settings = ZUISettings

zui.frames         = zui.frames or {}
zui.panels         = zui.panels or {}
zui.buttons        = zui.buttons or {}
zui.commitRegistry = zui.commitRegistry or {}

ZUISettings.anchorAssignments = ZUISettings.anchorAssignments or {}
ZUISettings.anchorAssignments.left = ZUISettings.anchorAssignments.left
ZUISettings.anchorAssignments.right = ZUISettings.anchorAssignments.right

ZUISettings.leftAnchorWidth = ZUISettings.leftAnchorWidth
ZUISettings.leftAnchorHeight = ZUISettings.leftAnchorHeight

ZUISettings.DebugMode = ZUISettings.DebugMode

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    -- ✅ Enable debug mode manually
    ZUISettings.DebugMode = true
end)

C_Timer.After(0, function()
    if ZUISettings and ZUISettings.DebugMode then
        print("Init Loaded")
        print("ZUISettings contents at init.lua load:")
        for k, v in pairs(ZUISettings or {}) do
            print("  ", k, "=", tostring(v))
        end
    print("ZUI Debug: Registered ZUICommitRegistry functions:")
    if type(ZUICommitRegistry) == "table" then
        for i, fn in ipairs(ZUICommitRegistry) do
            print(string.format("  [%d] %s", i, tostring(fn)))
        end
    else
        print("  ZUICommitRegistry not initialized or not a table.")
    end
       print("Left Anchor Assignment:", ZUISettings.anchorAssignments.left)
       print("Right Anchor Assignment:", ZUISettings.anchorAssignments.right)
    end
end)



--fairly certain I didn't need an init.lua, it was just easier to build things out with this, I might integrate it later
--I just wanted it for settings, but because wow is wow and loading takes time I have to wrap everything in some kind of
--event, so its like... why even bother doing things cleanly