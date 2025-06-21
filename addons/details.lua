------------------------------------------------------------------------
-- Details! Integration (Conditional Based on Anchor Assignment)
------------------------------------------------------------------------
local function ShouldAnchorDetails()
    return ZUISettings
        and ZUISettings.anchorAssignments
        and (
            ZUISettings.anchorAssignments.left == "Details!"
            or ZUISettings.anchorAssignments.right == "Details!"
        )
end

local function GetDetailsAnchorTarget()
    if not ZUISettings then return nil end
    if ZUISettings.anchorAssignments.left == "Details!" then
        return leftAnchor
    elseif ZUISettings.anchorAssignments.right == "Details!" then
        return rightAnchor
    end
end

local function AnchorDetailsToAssignedAnchor()
    if not (Details and Details.GetInstance and ShouldAnchorDetails()) then return end
    local instance = Details:GetInstance(1)
    if not (instance and instance.baseframe) then return end

    local targetAnchor = GetDetailsAnchorTarget()
    if not targetAnchor then return end

    local frame = instance.baseframe
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", targetAnchor, "TOPLEFT", 0, 0)
    frame:SetPoint("BOTTOMRIGHT", targetAnchor, "BOTTOMRIGHT", 0, 0)
    frame:SetSize(targetAnchor:GetWidth(), targetAnchor:GetHeight())
end

local function ApplyDetailsVisualSettings()
    if not (Details and Details.GetInstance and ZUISettings) then return end
    local instance = Details:GetInstance(1)
    if not instance or not instance.baseframe then return end

    if ZUISettings.LockDetails then
        instance:LockInstance(true)
    end

    if ZUISettings.HideDetailsTitleBar then
        if instance and instance.color then
            instance.color[4] = 0  -- Set alpha to 0
        end
    end

    if ZUISettings.HideDetailsBarArea then
        if DetailsBaseFrame1 and DetailsBaseFrame1.Center then
            DetailsBaseFrame1.Center:SetAlpha(0)
        end
        if Details_GumpFrame1 and Details_GumpFrame1.Center then
            Details_GumpFrame1.Center:SetAlpha(0)
        end
    end
    instance:SaveMainWindowPosition()
end

------------------------------------------------------------------------------------------------------------------------
--- HOOKS
------------------------------------------------------------------------------------------------------------------------
if ZUISettingsFrame then
    ZUISettingsFrame:HookScript("OnShow", function()
        AnchorDetailsToAssignedAnchor()
    end)
end

------------------------------------------------------------------------------------------------------------------------
--- Init on login
------------------------------------------------------------------------------------------------------------------------
local l = CreateFrame("Frame")
l:RegisterEvent("PLAYER_LOGIN")
l:SetScript("OnEvent", function()
    C_Timer.After(0.1, function()
        AnchorDetailsToAssignedAnchor()
        --ApplyDetailsVisualSettings()

        -- Hook resize
        local anchor = GetDetailsAnchorTarget()
        if anchor and not anchor.__details_size_hooked then
            anchor:HookScript("OnSizeChanged", AnchorDetailsToAssignedAnchor)
            anchor.__details_size_hooked = true
        end
    end)
end)

------------------------------------------------------------------------------------------------------------------------
--- ZUICommitRegistry Function Registration
------------------------------------------------------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    ZUICommitRegistry = ZUICommitRegistry or {}

    table.insert(ZUICommitRegistry, AnchorDetailsToAssignedAnchor)
end)