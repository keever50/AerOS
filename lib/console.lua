local console = {}

console.readLine = function()
    while true do coroutine.yield() 
        
    end
end

return console