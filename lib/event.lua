kernel.event = {}

--[[
event.pool = {}

event.add = function(event_name, name, func )
    local ev = {}
    ev.name = name 
    ev.func = func

    if not event.pool[event_name] then event.pool[event_name] = {} end
    event.pool[event_name][name]=ev
end

event.remove = function(event_name, name )
    event.pool[event_name][name] = nil
end

event_handler = function()
    while true do coroutine.yield()
        for k, v in pairs(event.pool) do 

        end
    end
end
local handler = thread.create(event_handler, "event_handler")
if handler then handler:run() end
]]--