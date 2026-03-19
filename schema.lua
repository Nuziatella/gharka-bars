local Schema = {}

Schema.GLOBAL_TOGGLES = {
    { key = "enabled", label = "Addon enabled" },
    { key = "anchor_to_nametag", label = "Anchor to name tag" },
    { key = "click_target", label = "Click to target" },
    { key = "click_through_shift", label = "Ignore clicks with Shift" },
    { key = "click_through_ctrl", label = "Ignore clicks with Ctrl" },
    { key = "show_player", label = "Show player" },
    { key = "show_target", label = "Show target" },
    { key = "show_watchtarget", label = "Show watchtarget" },
    { key = "show_raid_party", label = "Show raid / party" },
    { key = "show_mount", label = "Show mount / pet" }
}

Schema.GLOBAL_CHOICES = {
    {
        key = "frame_layer_mode",
        label = "Draw layer",
        options = {
            { value = "default", label = "Default" },
            { value = "normal", label = "Normal" },
            { value = "hud", label = "HUD" },
            { value = "tooltip", label = "Tooltip" },
            { value = "dialog", label = "Dialog" },
            { value = "system", label = "System" },
            { value = "questdirecting", label = "Quest Directing" },
            { value = "game", label = "Game" },
            { value = "background", label = "Background" }
        }
    }
}

Schema.STYLE_TOGGLES = {
    { key = "show_name", label = "Show name" },
    { key = "show_guild", label = "Show guild" },
    { key = "show_role", label = "Show role" },
    { key = "show_hp_text", label = "Show HP text" },
    { key = "show_mp_text", label = "Show MP text" },
    { key = "show_mp_bar", label = "Show MP bar" },
    { key = "show_distance", label = "Show distance" },
    { key = "show_background", label = "Show background" }
}

Schema.LAYOUT_SLIDERS = {
    { key = "width", label = "Bar width", min = 80, max = 320, factor = 1 },
    { key = "hp_height", label = "HP bar height", min = 8, max = 56, factor = 1 },
    { key = "mp_height", label = "MP bar height", min = 0, max = 26, factor = 1 },
    { key = "bar_gap", label = "Bar gap", min = 0, max = 10, factor = 1 },
    { key = "alpha_pct", label = "Frame alpha", min = 10, max = 100, factor = 1 },
    { key = "bg_alpha_pct", label = "BG alpha", min = 0, max = 100, factor = 1 },
    { key = "max_distance", label = "Max distance", min = 10, max = 300, factor = 1 },
    { key = "x_offset", label = "Frame offset X", min = -500, max = 500, factor = 1 },
    { key = "y_offset", label = "Frame offset Y", min = -200, max = 200, factor = 1 }
}

Schema.TEXT_SLIDERS = {
    { key = "name_font_size", label = "Name font", min = 8, max = 30, factor = 1 },
    { key = "name_max_chars", label = "Name max chars (0=full)", min = 0, max = 64, factor = 1 },
    { key = "guild_font_size", label = "Guild font", min = 8, max = 24, factor = 1 },
    { key = "guild_max_chars", label = "Guild max chars (0=full)", min = 0, max = 64, factor = 1 },
    { key = "role_font_size", label = "Role font", min = 8, max = 24, factor = 1 },
    { key = "value_font_size", label = "Value font", min = 8, max = 24, factor = 1 },
    { key = "value_offset_x", label = "HP/MP text offset X", min = -80, max = 80, factor = 1 },
    { key = "value_offset_y", label = "HP/MP text offset Y", min = -40, max = 40, factor = 1 },
    { key = "distance_font_size", label = "Distance font", min = 8, max = 22, factor = 1 },
    { key = "name_offset_x", label = "Name offset X", min = -80, max = 80, factor = 1 },
    { key = "name_offset_y", label = "Name offset Y", min = -80, max = 80, factor = 1 },
    { key = "guild_offset_x", label = "Guild offset X", min = -80, max = 80, factor = 1 },
    { key = "guild_offset_y", label = "Guild offset Y", min = -80, max = 80, factor = 1 },
    { key = "role_offset_x", label = "Role offset X", min = -80, max = 80, factor = 1 },
    { key = "role_offset_y", label = "Role offset Y", min = -80, max = 80, factor = 1 },
    { key = "distance_offset_x", label = "Distance offset X", min = -120, max = 120, factor = 1 },
    { key = "distance_offset_y", label = "Distance offset Y", min = -120, max = 120, factor = 1 }
}

Schema.COLOR_GROUPS = {
    { key = "hp_bar_color", label = "HP bar" },
    { key = "mp_bar_color", label = "MP bar" },
    { key = "bloodlust_team_color", label = "Bloodlust team" },
    { key = "bloodlust_target_color", label = "Bloodlust target" },
    { key = "name_color", label = "Name text" },
    { key = "guild_color", label = "Guild text" },
    { key = "value_color", label = "HP/MP text" },
    { key = "distance_color", label = "Distance text" }
}

Schema.STYLE_CHOICES = {
    {
        key = "value_mode",
        label = "HP/MP text mode",
        options = {
            { value = "current", label = "Current" },
            { value = "current_max", label = "Current / Max" },
            { value = "percent", label = "Percent" },
            { value = "both", label = "Both" }
        }
    },
    {
        key = "name_layout",
        label = "Name/Guild layout",
        options = {
            { value = "vertical", label = "Vertical" },
            { value = "horizontal", label = "Horizontal" }
        }
    }
}

return Schema
