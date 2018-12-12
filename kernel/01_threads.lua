thread = {}

thread.pool = {}

thread.create = function( func, name )
    if not thread.pool[name] then
        local thr = {}
        thr.co = coroutine.create( function() safe(func) end )
        thr.name = name
        thr.run = function(this, ...)
            thread.pool[this.name] = this
            thread.pool[this.name].args = {...}
        end
        return thr
    else 
        return nil
    end
end

kernel.startThreading = function()
    print("Kernel has started threads")
    while true do     
        thread.signal = table.pack(computer.pullSignal(0))--temporary
        --for i=1,200,1 do
            for k, v in pairs( thread.pool ) do
                if coroutine.status(v.co) ~= "suspended" then thread.pool[k] = nil  goto continue end
                coroutine.resume( v.co )
                ::continue::
            end
        --end
    end
end