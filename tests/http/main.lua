local http = require("socket.http")
function love.load()
  local urls = {"http://cupm.net/test","http://google.com","http://localhost","notanaddress"}
  for i,v in ipairs(urls) do
    server_data = http.request(v)
    if server_data then
      print("[success] "..v)    
    else
      print("[failure] "..v)
    end
  end
  love.event.push("q")
end
