local Shared = nil
do
    local ok, mod = pcall(require, "gharka-bars/shared")
    if ok then
        Shared = mod
    else
        ok, mod = pcall(require, "gharka-bars.shared")
        if ok then
            Shared = mod
        end
    end
end

local Helpers = {}

local function clamp(v, lo, hi, default)
    return Shared.Clamp(v, lo, hi, default)
end

function Helpers.SafeShow(widget, show)
    if widget ~= nil and widget.Show ~= nil then
        pcall(function()
            widget:Show(show and true or false)
        end)
    end
end

function Helpers.SafeClickable(widget, clickable)
    if widget ~= nil and widget.Clickable ~= nil then
        pcall(function()
            widget:Clickable(clickable and true or false)
        end)
    end
end

function Helpers.SafeSetText(widget, text)
    if widget ~= nil and widget.SetText ~= nil then
        pcall(function()
            widget:SetText(tostring(text or ""))
        end)
    end
end

function Helpers.SafeSetAlpha(widget, alpha01)
    if widget ~= nil and widget.SetAlpha ~= nil then
        pcall(function()
            widget:SetAlpha(clamp(alpha01, 0, 1, 1))
        end)
    end
end

function Helpers.SafeAnchor(widget, point, rel, relPoint, x, y)
    if widget == nil or widget.AddAnchor == nil then
        return
    end
    pcall(function()
        if widget.RemoveAllAnchors ~= nil then
            widget:RemoveAllAnchors()
        end
    end)
    local ok = pcall(function()
        widget:AddAnchor(point, rel, relPoint, x, y)
    end)
    if ok then
        return
    end
    pcall(function()
        widget:AddAnchor(point, rel, x, y)
    end)
end

function Helpers.SafeSetBg(frame, enabled, alpha01)
    if frame == nil or frame.bg == nil then
        return
    end
    pcall(function()
        frame.bg:Show(enabled and true or false)
    end)
    pcall(function()
        if frame.bg.SetColor ~= nil then
            frame.bg:SetColor(1, 1, 1, clamp(alpha01, 0, 1, 0.72))
        end
    end)
end

function Helpers.SafeSetDrawable(drawable, enabled, rgba255)
    if drawable == nil then
        return
    end
    pcall(function()
        if drawable.Show ~= nil then
            drawable:Show(enabled and true or false)
        elseif drawable.SetVisible ~= nil then
            drawable:SetVisible(enabled and true or false)
        end
    end)
    if type(rgba255) ~= "table" then
        return
    end
    local c = Helpers.Color01(rgba255, { 255, 255, 255, 255 })
    pcall(function()
        if drawable.SetColor ~= nil then
            drawable:SetColor(c[1], c[2], c[3], c[4])
        end
    end)
end

function Helpers.SetLabelStyle(label, fontSize, width, allowOverflow)
    if label == nil then
        return
    end
    pcall(function()
        if label.SetLimitWidth ~= nil then
            label:SetLimitWidth(not allowOverflow)
        end
        if label.SetAutoResize ~= nil then
            label:SetAutoResize(allowOverflow and true or false)
        end
        if label.SetExtent ~= nil then
            label:SetExtent(width, fontSize + 6)
        end
        if label.style ~= nil then
            if label.style.SetFontSize ~= nil then
                label.style:SetFontSize(fontSize)
            end
            if label.style.SetAlign ~= nil then
                label.style:SetAlign(ALIGN.LEFT)
            end
        end
    end)
end

function Helpers.MeasureTextWidth(label, text, fontSize, fallback)
    local width = nil
    if label ~= nil and label.style ~= nil and label.style.GetTextWidth ~= nil then
        pcall(function()
            width = label.style:GetTextWidth(tostring(text or ""))
        end)
    end
    width = tonumber(width)
    if width == nil then
        local len = string.len(tostring(text or ""))
        width = math.floor((tonumber(fontSize) or 12) * math.max(1, len) * 0.62)
    end
    if fallback ~= nil and width < fallback then
        width = fallback
    end
    return width
end

function Helpers.Color01(rgba255, fallback)
    local src = type(rgba255) == "table" and rgba255 or fallback or { 255, 255, 255, 255 }
    local r = clamp(src[1], 0, 255, 255) / 255
    local g = clamp(src[2], 0, 255, 255) / 255
    local b = clamp(src[3], 0, 255, 255) / 255
    local a = clamp(src[4], 0, 255, 255) / 255
    return { r, g, b, a }
end

function Helpers.SetLabelColor(label, rgba255, fallback)
    if label == nil then
        return
    end
    local c = Helpers.Color01(rgba255, fallback)
    pcall(function()
        if label.style ~= nil and label.style.SetColor ~= nil then
            label.style:SetColor(c[1], c[2], c[3], c[4])
        end
    end)
end

local function formatNumber(value)
    local n = tonumber(value)
    if n == nil then
        return "0"
    end
    local sign = ""
    if n < 0 then
        sign = "-"
        n = math.abs(n)
    end
    local raw = tostring(math.floor(n + 0.5))
    local parts = {}
    while #raw > 3 do
        table.insert(parts, 1, string.sub(raw, -3))
        raw = string.sub(raw, 1, #raw - 3)
    end
    table.insert(parts, 1, raw)
    return sign .. table.concat(parts, ",")
end

function Helpers.FormatValueText(mode, currentValue, maxValue)
    local currentNum = tonumber(currentValue) or 0
    local maxNum = tonumber(maxValue) or 0
    local pct = 0
    if maxNum > 0 then
        pct = math.floor(((currentNum / maxNum) * 100) + 0.5)
    end
    if mode == "current" then
        return formatNumber(currentNum)
    elseif mode == "percent" then
        return tostring(pct) .. "%"
    elseif mode == "both" then
        return string.format("%s / %s (%d%%)", formatNumber(currentNum), formatNumber(maxNum), pct)
    end
    return string.format("%s / %s", formatNumber(currentNum), formatNumber(maxNum))
end

function Helpers.ApplyStatusBarColor(statusBar, rgba)
    if statusBar == nil or type(rgba) ~= "table" then
        return
    end
    pcall(function()
        if statusBar.SetBarColor ~= nil then
            statusBar:SetBarColor(rgba[1], rgba[2], rgba[3], rgba[4])
        elseif statusBar.SetColor ~= nil then
            statusBar:SetColor(rgba[1], rgba[2], rgba[3], rgba[4])
        end
    end)
end

return Helpers
