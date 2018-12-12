
local boot_msg = "Loading AerOS"

kernel = {}

--graphics init--
kernel.gpu = component.proxy(component.list("gpu")())
kernel.screen = component.proxy(component.list("screen")())
--gpu vars
kernel.gpu.bind(kernel.screen.address)
local x, y = kernel.gpu.getResolution()
x = x + 1
y = y + 1
--clear and reset
if kernel.gpu.maxDepth() > 1 then
    kernel.gpu.setBackground(0x000000)
else
    kernel.gpu.setBackground(0x000000)
end

kernel.gpu.fill(1,1,x,y," ")
kernel.gpu.setForeground(0x555599)

local title = function()
    kernel.gpu.fill((x/2)-(#boot_msg),0,x,(y/2)," ")
    kernel.gpu.set((x/2)-(#boot_msg/2),y/2,boot_msg)
end

--simple print--
kernel.print = function( str )
    for i in string.gmatch(str, "%C+") do
        kernel.gpu.copy(1,1,x,y,0,-1)
        kernel.gpu.set(1,y-2, tostring( i ) )
    
    end

end
print = kernel.print 

--simple error
error = function( err ) 
    kernel.print( err )  
end


--load /kernel/
title()
kernel.print("Loading kernel resources")

kernel.fs = component.proxy(computer.getBootAddress())
local files = kernel.fs.list("/kernel/")
table.sort(files)
for k, v in pairs(files) do
    if k == "n" then break end
    if v == nil then break end

    title()
    kernel.print( v )
    --load and compile
    local file = kernel.fs.open("/kernel/" .. v)
    local code = kernel.fs.read(file, math.huge)
    kernel.fs.close(file)
    local result = load(code)
    if type(result) == "string" then 
        title()
        kernel.print(result)
        break
    else
        xpcall( result, function( err )
            error( err )
            print(debug.traceback())
        end)
        
    end
end

print("Finished kernel loading\nLoading control.lua into threads")

local ctrl = thread.create( loadfile("/control.lua"), "control" )
local ctrl2 = thread.create( loadfile("/control.lua"), "control" )
local ctrl3 = thread.create( loadfile("/control.lua"), "control" )
ctrl:run()
ctrl2:run()
ctrl3:run()
kernel.startThreading()
computer.pullSignal()