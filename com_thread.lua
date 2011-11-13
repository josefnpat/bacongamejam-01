local http = require("socket.http")
local this_thread = love.thread.getThread()

while true do
  local input_data = this_thread:receive("input")
  if input_data then
    this_thread:send("output", input_data)
  end
end
