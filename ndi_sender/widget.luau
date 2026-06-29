-- NDI Sender — bar widget.
-- Thin presentation client: mirrors "status", drives via "command".

local state = "idle"  -- idle | pending | streaming
local available = false

local function send(action)
    noctalia.state.set("command", action)
end

local function applyStatus(status)
    if type(status) == "table" then
        state = status.state or "idle"
        available = if status.available then true else false
    end

    local hideInactive = noctalia.getConfig("hide_inactive")

    if not available then
        barWidget.setGlyph("video-off")
        barWidget.setGlyphColor("on_surface_variant")
        barWidget.setVisible(not hideInactive)
        return
    end

    if state == "streaming" then
        barWidget.setGlyph("video")
        barWidget.setGlyphColor("error")
        barWidget.setColor("error")
        barWidget.setVisible(true)
    elseif state == "pending" then
        barWidget.setGlyph("video")
        barWidget.setGlyphColor("primary")
        barWidget.setColor("primary")
        barWidget.setVisible(true)
    else
        barWidget.setGlyph("video")
        barWidget.setGlyphColor("on_surface")
        barWidget.setVisible(not hideInactive)
    end
end

function onClick()
    if available then send("toggle") end
end

applyStatus(noctalia.state.get("status"))
noctalia.state.watch("status", applyStatus)
