
function love.load()
  com = love.thread.newThread( "com", "thread.lua" )
  com:start()
  local send = "I am the main!"
  print("  main: sending \""..send.."\"")
  com:send("input", send)
end

function love.update()
  local receive = com:receive("output");
  if receive then
    print("  main: received \""..receive.."\"")
  end
  local e = com:receive("err")
  if e then
    print("  main: error:"..e)
  end
  if receive then
    love.event.push("q")
  end
end
