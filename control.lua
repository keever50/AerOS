local console = require("console")

for k, v in pairs(thread.pool) do 
    print(k)
end

old = ""
while true do
    coroutine.yield() 
    local new = thread.signal[1]
    if new == nil then new = "nil" end
    if new ~= old then print(new) end
    old = new
end