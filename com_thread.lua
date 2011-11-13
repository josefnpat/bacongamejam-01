server = {}
require("server")
local http = require("socket.http")
local this_thread = love.thread.getThread()

function debug_delay(d)
  local t0 = socket.gettime()
  while socket.gettime() - t0 <= d do end
end

while true do
  local input_data = this_thread:receive("input")
  if input_data then
    local url = server.url .. "?i=" .. input_data
    server_data = http.request(url)
    --debug_delay(0.02) --add 120ms delay
    this_thread:send("output", server_data)
  end
end


