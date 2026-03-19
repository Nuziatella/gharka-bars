local function eachSlider(list, fn)
    for index, item in ipairs(list or {}) do
        fn(index, item)
    end
end

local Pages = {}

local function bindGlobalToggle(ctx, item, cb)
    cb:SetHandler("OnClick", function()
        local settings = ctx.Shared.EnsureSettings()
        settings[item.key] = not (settings[item.key] and true or false)
        ctx.applyChanges()
        ctx.refreshControls()
    end)
end

local function bindGlobalChoice(ctx, item, button)
    button:SetHandler("OnClick", function()
        local settings = ctx.Shared.EnsureSettings()
        settings[item.key] = ctx.nextOptionValue(item, settings[item.key])
        ctx.applyChanges()
        ctx.refreshControls()
    end)
end

local function bindStyleToggle(ctx, item, cb)
    cb:SetHandler("OnClick", function()
        local style = ctx.Shared.GetStyleSettings()
        style[item.key] = not (style[item.key] and true or false)
        ctx.applyChanges()
        ctx.refreshControls()
    end)
end

local function bindStyleChoice(ctx, item, button)
    button:SetHandler("OnClick", function()
        local style = ctx.Shared.GetStyleSettings()
        style[item.key] = ctx.nextOptionValue(item, style[item.key])
        ctx.applyChanges()
        ctx.refreshControls()
    end)
end

local function bindStyleSlider(ctx, item, slider, value)
    if slider == nil or slider.SetHandler == nil then
        return
    end
    slider:SetHandler("OnSliderChanged", function(_, raw)
        local n = tonumber(raw) or 0
        ctx.Shared.GetStyleSettings()[item.key] = n
        if value ~= nil and value.SetText ~= nil then
            value:SetText(tostring(math.floor(n + 0.5)))
        end
        ctx.applyChanges()
    end)
end

local function bindColorSlider(ctx, colorKey, channelIndex, slider, value)
    if slider == nil or slider.SetHandler == nil then
        return
    end
    slider:SetHandler("OnSliderChanged", function(_, raw)
        local style = ctx.Shared.GetStyleSettings()
        if type(style[colorKey]) ~= "table" then
            style[colorKey] = { 255, 255, 255, 255 }
        end
        local n = math.floor((tonumber(raw) or 0) + 0.5)
        style[colorKey][channelIndex] = n
        if value ~= nil and value.SetText ~= nil then
            value:SetText(tostring(n))
        end
        ctx.applyChanges()
    end)
end

function Pages.BuildGeneralPage(ctx, wnd)
    ctx.addPageWidget("general", ctx.createLabel("ghbGeneralTitle", wnd, "Global Behavior", 24, 98, 16, 220))
    ctx.addPageWidget("general", ctx.createLabel("ghbGeneralHint", wnd, "Tracking toggles, click behavior, and draw priority for overhead bars.", 24, 122, 12, 620))
    local leftX, rightX, startY, rowGap = 24, 500, 164, 42
    for index, item in ipairs(ctx.Schema.GLOBAL_TOGGLES) do
        local colX = index <= 5 and leftX or rightX
        local rowY = startY + (((index - 1) % 5) * rowGap)
        local cb = ctx.createCheckbox("ghbGlobal" .. item.key, wnd, item.label, colX, rowY, 260)
        ctx.addPageWidget("general", cb.button)
        ctx.addPageWidget("general", cb.label)
        ctx.SettingsUi.controls["global_" .. item.key] = cb
        bindGlobalToggle(ctx, item, cb)
    end
    local choiceY = 386
    for _, item in ipairs(ctx.Schema.GLOBAL_CHOICES or {}) do
        local label, btn = ctx.createChoiceRow("ghbGlobalChoice" .. item.key, wnd, item.label, 24, choiceY, 180)
        ctx.addPageWidget("general", label)
        ctx.addPageWidget("general", btn)
        ctx.SettingsUi.controls["global_choice_" .. item.key] = btn
        bindGlobalChoice(ctx, item, btn)
        choiceY = choiceY + 38
    end
end

function Pages.BuildLayoutPage(ctx, wnd)
    ctx.addPageWidget("layout", ctx.createLabel("ghbLayoutTitle", wnd, "Layout", 24, 98, 16, 220))
    ctx.addPageWidget("layout", ctx.createLabel("ghbLayoutHint", wnd, "Bar size, visibility, spacing, and overall placement.", 24, 122, 12, 520))

    local toggleLeftX, toggleRightX, toggleY, toggleGap = 24, 500, 164, 40
    for index, item in ipairs(ctx.Schema.STYLE_TOGGLES) do
        local colX = index <= 4 and toggleLeftX or toggleRightX
        local rowY = toggleY + (((index - 1) % 4) * toggleGap)
        local cb = ctx.createCheckbox("ghbStyleToggle" .. item.key, wnd, item.label, colX, rowY, 240)
        ctx.addPageWidget("layout", cb.button)
        ctx.addPageWidget("layout", cb.label)
        ctx.SettingsUi.controls["style_toggle_" .. item.key] = cb
        bindStyleToggle(ctx, item, cb)
    end

    local choiceY = 340
    for _, item in ipairs(ctx.Schema.STYLE_CHOICES) do
        local label, btn = ctx.createChoiceRow("ghbChoice" .. item.key, wnd, item.label, 24, choiceY, 190)
        ctx.addPageWidget("layout", label)
        ctx.addPageWidget("layout", btn)
        ctx.SettingsUi.controls["style_choice_" .. item.key] = btn
        bindStyleChoice(ctx, item, btn)
        choiceY = choiceY + 38
    end

    ctx.addPageWidget("layout", ctx.createLabel("ghbLayoutSliders", wnd, "Dimensions and Anchoring", 24, 424, 15, 260))
    eachSlider(ctx.Schema.LAYOUT_SLIDERS, function(index, item)
        local colX = index <= 5 and 24 or 500
        local localIndex = index <= 5 and index or (index - 5)
        local rowY = 458 + ((localIndex - 1) * 34)
        local label, slider, value = ctx.createSlider("ghbLayoutSlider" .. item.key, wnd, item.label, colX, rowY, item.min, item.max)
        ctx.addPageWidget("layout", label)
        ctx.addPageWidget("layout", slider)
        ctx.addPageWidget("layout", value)
        ctx.SettingsUi.controls["style_slider_" .. item.key] = slider
        ctx.SettingsUi.controls["style_slider_val_" .. item.key] = value
        bindStyleSlider(ctx, item, slider, value)
    end)
end

function Pages.BuildTextPage(ctx, wnd)
    ctx.addPageWidget("text", ctx.createLabel("ghbTextTitle", wnd, "Text", 24, 98, 16, 220))
    ctx.addPageWidget("text", ctx.createLabel("ghbTextHint", wnd, "Font families are client-limited. Set max chars to 0 for full names, and use the shared HP/MP text offsets to move both values together.", 24, 122, 12, 760))

    eachSlider(ctx.Schema.TEXT_SLIDERS, function(index, item)
        local colX = index <= 9 and 24 or 500
        local localIndex = index <= 9 and index or (index - 9)
        local rowY = 168 + ((localIndex - 1) * 38)
        local label, slider, value = ctx.createSlider("ghbTextSlider" .. item.key, wnd, item.label, colX, rowY, item.min, item.max)
        ctx.addPageWidget("text", label)
        ctx.addPageWidget("text", slider)
        ctx.addPageWidget("text", value)
        ctx.SettingsUi.controls["style_slider_" .. item.key] = slider
        ctx.SettingsUi.controls["style_slider_val_" .. item.key] = value
        bindStyleSlider(ctx, item, slider, value)
    end)
end

function Pages.BuildColorsPage(ctx, wnd)
    ctx.addPageWidget("colors", ctx.createLabel("ghbColorTitle", wnd, "Colors", 24, 98, 16, 220))
    ctx.addPageWidget("colors", ctx.createLabel("ghbColorHint", wnd, "Tune HP/MP bars and text colors. Role colors use built-in tank/healer/melee/ranged/magic colors.", 24, 122, 12, 640))

    for index, group in ipairs(ctx.Schema.COLOR_GROUPS) do
        local colX = index <= 3 and 24 or 500
        local localIndex = index <= 3 and index or (index - 3)
        local baseY = 170 + ((localIndex - 1) * 180)
        ctx.addPageWidget("colors", ctx.createLabel("ghbColorGroup" .. group.key, wnd, group.label, colX, baseY, 15, 220))
        local channels = {
            { suffix = "R", index = 1, label = "Red" },
            { suffix = "G", index = 2, label = "Green" },
            { suffix = "B", index = 3, label = "Blue" }
        }
        for channelOffset, channel in ipairs(channels) do
            local y = baseY + 32 + ((channelOffset - 1) * 38)
            local item = { key = group.key .. "_" .. channel.suffix, label = channel.label, min = 0, max = 255 }
            local label, slider, value = ctx.createSlider("ghbColorSlider" .. group.key .. channel.suffix, wnd, item.label, colX, y, 0, 255)
            ctx.addPageWidget("colors", label)
            ctx.addPageWidget("colors", slider)
            ctx.addPageWidget("colors", value)
            ctx.SettingsUi.controls["color_slider_" .. group.key .. "_" .. channel.index] = slider
            ctx.SettingsUi.controls["color_slider_val_" .. group.key .. "_" .. channel.index] = value
            bindColorSlider(ctx, group.key, channel.index, slider, value)
        end
    end
end

return Pages
