local _, SnugUI = ...

SnugUI.loginTrigger(function() --probably too cautious
    -- Anchors the tooltip to the rightAnchor frame
    hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip)
        if SnugUI.frames.rightAnchor and tooltip then
            tooltip:ClearAllPoints()
            tooltip:SetOwner(UIParent, "ANCHOR_NONE")
            tooltip:SetPoint("TOPRIGHT", SnugUI.frames.rightAnchor, "TOPLEFT", -10, 0)
        end
    end)
end)