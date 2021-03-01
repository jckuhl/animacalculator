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
        --print(animaItem)
        --print(GetItemSpell(animaItem["info"]))
        local spellName, spellID = GetItemSpell(animaItem["info"])
        --print(animaSpellValues[spellID])
        sum = sum + (animaSpellValues[spellID] * animaItem["count"])
    end
    print("Total Anima: "..tostring(sum))
end

SLASH_TEST1 = "/ac"
SlashCmdList["TEST"] = calculateAnima;

-- texture 
-- String - the texture for the item in the specified bag slot
-- itemCount 
-- Number - the number of items in the specified bag slot
-- locked 
-- Boolean - 1 if the item is locked by the server, nil otherwise.
-- quality 
-- Number - the numeric quality of the item
-- readable 
-- Boolean - 1 if the item can be "read" (as in a book)
-- lootable 
-- Boolean - 1 if the item is a temporary container containing items that can be looted; otherwise nil.
-- itemLink 
-- a hyperlink for the item.