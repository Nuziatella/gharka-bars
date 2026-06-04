local api = require("api")

local StockNametag = {}

local SETTERS = {
    { fn = "SetColorFriendly", key = "friendly" },
    { fn = "SetColorFriendlyNPC", key = "friendly_npc" },
    { fn = "SetColorNeutral", key = "neutral" },
    { fn = "SetColorParty", key = "party" },
    { fn = "SetColorRaid", key = "raid" },
    { fn = "SetColorRaidPK", key = "raid_pk" },
    { fn = "SetColorPK", key = "pk" },
    { fn = "SetColorEnemy", key = "enemy" },
    { fn = "SetColorMonster", key = "monster" },
    { fn = "SetColorPirate", key = "pirate" }
}

local DEFAULT_COLORS = {
    friendly = { 144, 206, 103, 255 },
    friendly_npc = { 255, 240, 100, 255 },
    neutral = { 255, 240, 100, 255 },
    party = { 118, 195, 196, 255 },
    raid = { 131, 203, 237, 255 },
    raid_pk = { 131, 133, 237, 255 },
    pk = { 170, 130, 240, 255 },
    enemy = { 250, 100, 100, 255 },
    monster = { 250, 100, 100, 255 },
    pirate = { 250, 120, 190, 255 }
}

local function getNametagApi()
    return type(api) == "table" and type(api.Nametag) == "table" and api.Nametag or nil
end

local function hasColorApi()
    local nametag = getNametagApi()
    if nametag == nil then
        return false
    end
    for _, item in ipairs(SETTERS) do
        if type(nametag[item.fn]) ~= "function" then
            return false
        end
    end
    return true
end

local function colorChannel(value, fallback)
    local n = tonumber(value)
    if n == nil then
        n = tonumber(fallback) or 0
    end
    n = math.floor(n + 0.5)
    if n < 0 then
        return 0
    end
    if n > 255 then
        return 255
    end
    return n
end

local function decimalColorString(rgba, fallback)
    local src = type(rgba) == "table" and rgba or fallback
    local r = colorChannel(type(src) == "table" and src[1] or nil, type(fallback) == "table" and fallback[1] or 255)
    local g = colorChannel(type(src) == "table" and src[2] or nil, type(fallback) == "table" and fallback[2] or 255)
    local b = colorChannel(type(src) == "table" and src[3] or nil, type(fallback) == "table" and fallback[3] or 255)
    return tostring((r * 65536) + (g * 256) + b)
end

local function buildColors()
    return {
        friendly = decimalColorString(DEFAULT_COLORS.friendly, DEFAULT_COLORS.friendly),
        friendly_npc = decimalColorString(DEFAULT_COLORS.friendly_npc, DEFAULT_COLORS.friendly_npc),
        neutral = decimalColorString(DEFAULT_COLORS.neutral, DEFAULT_COLORS.neutral),
        party = decimalColorString(DEFAULT_COLORS.party, DEFAULT_COLORS.party),
        raid = decimalColorString(DEFAULT_COLORS.raid, DEFAULT_COLORS.raid),
        raid_pk = decimalColorString(DEFAULT_COLORS.raid_pk, DEFAULT_COLORS.raid_pk),
        pk = decimalColorString(DEFAULT_COLORS.pk, DEFAULT_COLORS.pk),
        enemy = decimalColorString(DEFAULT_COLORS.enemy, DEFAULT_COLORS.enemy),
        monster = decimalColorString(DEFAULT_COLORS.monster, DEFAULT_COLORS.monster),
        pirate = decimalColorString(DEFAULT_COLORS.pirate, DEFAULT_COLORS.pirate)
    }
end

local STOCK_COLORS = buildColors()

local function buildColorKey(values)
    local keyParts = {}
    for _, item in ipairs(SETTERS) do
        keyParts[#keyParts + 1] = item.fn .. "=" .. tostring(values[item.key] or "")
    end
    return table.concat(keyParts, ";")
end

local function applyColors(nametag, values)
    local applied = true
    for _, item in ipairs(SETTERS) do
        local color = values[item.key]
        local setter = nametag[item.fn]
        if color ~= nil and type(setter) == "function" then
            local ok = pcall(function()
                setter(nametag, color)
            end)
            if not ok then
                applied = false
            end
        end
    end
    return applied
end

function StockNametag.Apply(_, state)
    local nametag = getNametagApi()
    if nametag == nil or not hasColorApi() then
        return false
    end

    local colorKey = buildColorKey(STOCK_COLORS)
    if type(state) == "table" and state.stock_nametag_color_key == colorKey then
        return true
    end

    local applied = applyColors(nametag, STOCK_COLORS)
    if applied and type(state) == "table" then
        state.stock_nametag_color_key = colorKey
    end
    return applied
end

return StockNametag
