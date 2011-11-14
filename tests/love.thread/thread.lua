print("thread: running")
local this_thread = love.thread.getThread("com")
while true do
  local input_data = this_thread:receive("input")
  if input_data then
    print("thread: received \""..input_data.."\"")
    local send = "I am the thread!"
    print("thread: sending \""..send.."\"")
    this_thread:send("output", send)
  end
end
