local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    -- Hook the default tooltip anchor behavior
    hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
        if rightAnchor and tooltip then
            tooltip:ClearAllPoints()
            tooltip:SetOwner(UIParent, "ANCHOR_NONE")
            tooltip:SetPoint("TOPRIGHT", rightAnchor, "TOPLEFT", -10, 0)
        end
    end)
end)
