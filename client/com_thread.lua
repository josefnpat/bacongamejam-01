debug_messages = false
function debug(msg)
  if debug_messages then
    print("[com_thread]:"..msg)
  end
end
debug("running")
require("love.filesystem")
server = {}
require("server")
local http = require("socket.http")
local this_thread = love.thread.getThread("com")

function debug_delay(d)
  local t0 = socket.gettime()
  while socket.gettime() - t0 <= d do end
end
while true do
  local input_data = this_thread:get("input")
  if input_data then
    local url = server.url .. "?i=" .. input_data
    debug("receive data from ["..url.."]")
    server_data = http.request(url)
    --debug_delay(0.02) --add 120ms delay
    debug("send data ["..server_data.."]")
    this_thread:set("output", server_data)
  end
end


