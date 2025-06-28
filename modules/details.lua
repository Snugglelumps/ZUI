local _, zui = ...


---<<=======================================================================================═╗ Details! anchor logic╔═==
local function GetAnchorTarget()                                                          ---╚═====================═╝---
    local asgn = zui.settings.anchorAssignments
    if not asgn then return nil end

    if (asgn.left == "Details!" and zui.frames.leftAnchor) then
        return zui.frames.leftAnchor
    elseif (asgn.right == "Details!" and zui.frames.rightAnchor) then
        return zui.frames.rightAnchor end
    return nil
end

local function AnchorDetailsToAssignedAnchor()
    if not (Details and Details.GetInstance) then return end
    local instance = Details:GetInstance(1)
    if not (instance and instance.baseframe) then return end

    local targetAnchor = GetAnchorTarget()
    if not targetAnchor then return end

    local frame = instance.baseframe
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", targetAnchor, "TOPLEFT", 1, -1)
    frame:SetPoint("BOTTOMRIGHT", targetAnchor, "BOTTOMRIGHT", -1, 1)
    frame:SetSize(targetAnchor:GetWidth(), targetAnchor:GetHeight())
    if instance then
        instance:LockInstance(true)
    end
end


---<<===================================================================================================== init on login
zui.loginTrigger(function()
    AnchorDetailsToAssignedAnchor()

    -- Hook resize
    local anchor = GetAnchorTarget()
    if anchor and not anchor.care then
        anchor:HookScript("OnSizeChanged", AnchorDetailsToAssignedAnchor)
        anchor.care = true
    end
end)


---<<========================================================================== zui.commitRegistry Function Registration
zui.loginTrigger(function()
        table.insert(zui.commitRegistry, AnchorDetailsToAssignedAnchor)
end)