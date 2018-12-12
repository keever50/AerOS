safe = function( f )
    xpcall(f, function( err )
        error( err )
        print(debug.traceback())       
    end)
end 

loadfile = function( path )
    local handle = kernel.fs.open( path )
    local content = kernel.fs.read(handle, math.huge)
    kernel.fs.close(handle)
    if content then 
        local program = load(content)
        if type(program) == "string" then
            error( program )
            print(debug.traceback())
        else
            return program
        end
    else 
        error( "File not found" )
    end
end

dofile = function( path )
    local handle = kernel.fs.open( path )
    local content = kernel.fs.read(handle, math.huge)
    kernel.fs.close(handle)
    if content then 
        local program = load(content)
        if type(program) == "string" then
            error( program )
            print(debug.traceback())
        else
            xpcall(program, function( err )
                error( err )
                print(debug.traceback())
            end)
        end
    else 
        error( "File not found" )
    end
end

require = function( path )
    --Relative to lib and .lua
    path = "/lib/" .. path .. ".lua"
    local handle = kernel.fs.open( path )
    local content = kernel.fs.read(handle, math.huge)
    kernel.fs.close(handle)
    if content then 
        local program = load(content)
        if type(program) == "string" then
            error( program )
            print(debug.traceback())
        else
            return program()
        end
    else 
        error( "File not found" )
    end   
end

table.pack = function(...)
    local args = {...}
    return args
end