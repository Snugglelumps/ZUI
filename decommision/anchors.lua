local _, zui = ...

local function GetAnchorDimensions()                        --Why this exists:
    local w = tonumber(zui.settings.anchorWidth.left) or 420  --  ZUISettings is initialized by `init.lua`, but during
    local h = tonumber(zui.settings.anchorHeight.left) or 200 --  file load time (i.e., top-level scope), SavedVariables
    return w, h                                             --  might not yet be populated with user values. This
end                                                         --  function ensures we never break due to nil values by
                                                            --  providing safe defaults, which are never actually used,
                                                            --  just valid values (420x200, could be anything).
                                                            --  It should be used *anywhere* we need dimensions,
                                                            --  including inside PLAYER_LOGIN blocks where the real
local anchorWidth, anchorHeight = GetAnchorDimensions()     --  values should be present and used.

local function CreateRectangle(name, parent, x, y)
    local f = CreateFrame("Frame", name, parent or UIParent)
    f:SetSize(anchorWidth, anchorHeight)
    f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)
    f:SetFrameStrata("BACKGROUND")

    -- Background
    f.bg = f:CreateTexture(nil, "BACKGROUND")
    f.bg:SetAllPoints(true)
    f.bg:SetColorTexture(0, 0, 0, 0.25)

    -- Border (using 4 textures for 1px border)
    local borderColor = {0, 0, 0, 1}
    -- Top
    f.top = f:CreateTexture(nil, "BORDER")
    f.top:SetColorTexture(unpack(borderColor))
    f.top:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
    f.top:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
    f.top:SetHeight(1)

    -- Bottom
    f.bottom = f:CreateTexture(nil, "BORDER")
    f.bottom:SetColorTexture(unpack(borderColor))
    f.bottom:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
    f.bottom:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
    f.bottom:SetHeight(1)

    -- Left
    f.left = f:CreateTexture(nil, "BORDER")
    f.left:SetColorTexture(unpack(borderColor))
    f.left:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
    f.left:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
    f.left:SetWidth(1)

    -- Right
    f.right = f:CreateTexture(nil, "BORDER")
    f.right:SetColorTexture(unpack(borderColor))
    f.right:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
    f.right:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
    f.right:SetWidth(1)

    return f
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()

    -- Create and anchor rightAnchor (bottom right of screen)
    zui.frames.rightAnchor = CreateRectangle(nil, UIParent)
    zui.frames.rightAnchor:ClearAllPoints()
    zui.frames.rightAnchor:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -1, 1)
    zui.frames.rightAnchor:SetSize(anchorWidth, anchorHeight)

    -- Create and anchor leftAnchor (bottom left of screen)
    zui.frames.leftAnchor = CreateRectangle(nil, UIParent)
    zui.frames.leftAnchor:ClearAllPoints()
    zui.frames.leftAnchor:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 1, 1)
    zui.frames.leftAnchor:SetSize(anchorWidth, anchorHeight)

    _G["ZUI_RightAnchor"] = zui.frames.rightAnchor
    _G["ZUI_LeftAnchor"]  = zui.frames.leftAnchor
    print("ZUI_RightAnchor (global):", _G["ZUI_RightAnchor"])
    print("zui.frames.rightAnchor:", zui.frames.rightAnchor)


end)
