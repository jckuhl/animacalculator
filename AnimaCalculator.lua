local function getItemString(itemLink)
    local itemString = string.match(itemLink, "item[%-?%d:]+")
    if itemString ~= nil then
        return itemString
    end
    return "000000"
end

local function getItemFromItemString(itemLink)
    local itemString = getItemString(itemLink):match("item:%d+")
    if itemString ~= nil then
        return itemString:sub(6)
    end
    return "000000"
end

local function awaitItemLoad(itemInfo)
    local item = Item:CreateFromItemID(itemInfo)
    local spellName, spellID;
    item:ContinueOnItemLoad(function()
        spellName, spellID = GetItemSpell(itemInfo);
    end)
    return spellName, spellID
end

local function getAnimaItems()
    local inventoryAnimaItems = {}
    for bagID=0, 4 do
        for bagSlot=0, GetContainerNumSlots(bagID) do
            _, itemCount, _, _, _, _, itemLink = GetContainerItemInfo(bagID, bagSlot);
            if itemLink ~= nil then
                local itemInfo = getItemFromItemString(itemLink)
                if C_Item.IsAnimaItemByID(itemInfo) then
                    table.insert(inventoryAnimaItems,{info=itemInfo, count=itemCount})
                end
            end
        end
    end
    return inventoryAnimaItems;
end

local function calculateAnima()
    local animaSpellValues = {
        [347555] = 3,
        [345706] = 5,
        [336327] = 35,
        [336456] = 250
    }
    local inventoryAnimaItems = getAnimaItems()
    local sum = 0;
    for _, animaItem in ipairs(inventoryAnimaItems) do
        local spellName, spellID = GetItemSpell(animaItem["info"])
        --local spellName, spellID = awaitItemLoad(animaItem["info"])
        sum = sum + (animaSpellValues[spellID] * animaItem["count"])
    end
    print("Total Anima: "..tostring(sum))
end

SLASH_TEST1 = "/ac"
SlashCmdList["TEST"] = calculateAnima;