-- NDI Sender — control-center quick tile.
-- Thin presentation: mirrors "status", drives via "command".

local active = false
local available = false
local ACTIVE_STATES = { "streaming", "pending" }

local function applyStatus(status)
    local hasStatus = type(status) == "table"
    local st = if hasStatus then status.state or "idle" else "idle"
    available = if hasStatus and status.available then true else false
    active = table.find(ACTIVE_STATES, st) ~= nil

    shortcut.setLabel(if active then "NDI broadcasting" else "NDI sender")
    shortcut.setIcon("video", "video-off")
    shortcut.setActive(active)
    shortcut.setEnabled(available)
end

applyStatus(noctalia.state.get("status"))
noctalia.state.watch("status", applyStatus)

function onClick()
    noctalia.state.set("command", "toggle")
end
