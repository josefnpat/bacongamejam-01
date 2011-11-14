debug = true
function debug(msg)
  if debug then
    print("[main]:"..msg)
  end
end

require("json")
server = {}
require("server")

function love.load()
  img_icon = love.graphics.newImage( "assets/icon.png" )
  love.graphics.setIcon( img_icon )
  img_bg = love.graphics.newImage( "assets/stars.gif" )
  img_player_center = love.graphics.newImage( "assets/player-center.png" )
  img_player_left = love.graphics.newImage( "assets/player-left.png" )
  img_player_right = love.graphics.newImage( "assets/player-right.png" )
  img_enemy = love.graphics.newImage( "assets/enemy.png" )
  img_bullet = {}
  img_bullet[0] = love.graphics.newImage( "assets/bullet-0.png" )
  title_font = love.graphics.newFont( "assets/octinspraypaint.ttf", 128 )
  game_font = love.graphics.newFont( "assets/graphicpixel.ttf", 64 )
  small_game_font = love.graphics.newFont( "assets/graphicpixel.ttf", 16 )
  health_on = love.graphics.newImage( "assets/health_on.png" )
  health_off = love.graphics.newImage( "assets/health_off.png" )
  state = "title_screen"
  game_name = love.graphics.getCaption( )
  menu_select_option = 0
  com = love.thread.newThread( "com", "com_thread.lua" )
  debug("Starting Thread..")
  com:start()
end

function love.draw()
  for i = 0,3 do
    for j = -1,2 do
--    bg_scroll = 0
      love.graphics.draw(img_bg,200*i,200*j+(bg_scroll%200));
    end
  end
  if state == "title_screen" then
    local options = {"Join Server","Options","Exit"}
    menu_max = #options
    game_menu(options)
  elseif state == "options" then
    local options = {"Toggle Fullscreen","Back"}
    menu_max = #options
    game_menu(options)
  elseif state == "join_server" then
    local options = {server.name,"Back"}
    menu_max = #options
    game_menu(options)
  elseif state == "game" then
    game_draw_bullets()
    game_draw_players()
    game_draw_owner()
    game_draw_enemies()
    game_draw_health()
    if game_data then
      if game_data.points and game_data.pointsum then
        style_menu()
        love.graphics.print(game_data.points.."/"..game_data.pointsum,16,48);
      end
    end
    if info then
      style_instructions()
      love.graphics.print(info,16,300);
    end
  else
    style_instructions()
    love.graphics.print("Unknown State `"..state.."`", 0, 0)
  end
  if debug then
    style_instructions()
    love.graphics.print("FPS:"..love.timer.getFPS( ),0,0);
  end
end

health = nil
maxhealth = nil
function game_draw_health()
  if health and maxhealth then
    for i = 1,maxhealth do
      if i <= health then
        love.graphics.draw(health_on,i*32-16,16)
      else
        love.graphics.draw(health_off,i*32-16,16)
      end
    end
  end
end

function game_draw_players()
  if game_data and game_data.players then
    for i,v in ipairs(game_data.players) do
      local x = v.x + v.v_x * (love.timer.getMicroTime() - game_data_time)
      local y = v.y + v.v_y * (love.timer.getMicroTime() - game_data_time)
      love.graphics.draw(determine_player_dir(v.v_x),x,y,0,1,1,64,32)
    end
  end
end
function game_draw_owner()
  if game_data and game_data.x then
    local x = game_data.x + game_data.v_x * (love.timer.getMicroTime() - game_data_time)
    local y = game_data.y + game_data.v_y * (love.timer.getMicroTime() - game_data_time)
    love.graphics.draw(determine_player_dir(game_data.v_x),x,y,0,1,1,64,32)
  end
end

function determine_player_dir(v_x)
  if v_x > 0 then
    return img_player_right
  elseif v_x < 0 then
    return img_player_left
  else
    return img_player_center
  end
end

function game_draw_enemies()
  if game_data and game_data.enemies then
    for i,v in ipairs(game_data.enemies) do
      local x = v.x + v.v_x * (love.timer.getMicroTime() - game_data_time)
      local y = v.y + v.v_y * (love.timer.getMicroTime() - game_data_time)
      love.graphics.draw(img_enemy,x,y,0,1,1,32,32)
    end
  end
end

function game_draw_bullets()
  if game_data and game_data.bullets then
    for i,v in ipairs(game_data.bullets) do
      local x = v.x + v.v_x * (love.timer.getMicroTime() - game_data_time)
      local y = v.y + v.v_y * (love.timer.getMicroTime() - game_data_time)
      love.graphics.draw(img_bullet[0],x,y,0,1,1,8,16)
    end
  end
end

function game_menu(options)
  style_title()
  local w = title_font:getWidth(game_name)
  local h = title_font:getHeight(game_name)
  local w_w = love.graphics.getWidth( )
  local x = (w_w - w ) /2
  local y = 16
  love.graphics.print(game_name, x, y)
  style_menu()
  local x_indent = 80
  local y_indent = 64
  love.graphics.draw(img_enemy,x,y + h + menu_select_option * 64 + y_indent )
  for i,v in ipairs(options) do
    love.graphics.print(v, x + x_indent, y + h + y_indent + (i - 1) * 64)  
  end
  style_instructions()
--  love.graphics.print("up | down: menu", x + x_indent, 600-80)
--  love.graphics.print("wasd: up left down right", x + x_indent, 600-64)
--  love.graphics.print("space: select | shoot", x + x_indent, 600-48)
  love.graphics.print("A josefnpat Production, bacongamejam 2011", x + x_indent, 600-32)
end

menu_max = 0
join_server_buffer = ""
game_keyb = {}
game_keyb.left = false;
game_keyb.right = false;
game_keyb.space = false;
function love.keypressed(key)
  if key == "up" then
    if menu_select_option == 0 then
      menu_select_option = menu_max - 1
    else
      menu_select_option = menu_select_option - 1
    end
  elseif key == "down" then
    if menu_select_option == menu_max - 1 then
      menu_select_option = 0
    else
      menu_select_option = menu_select_option + 1
    end
  end
  if state == "title_screen" then
    if key == "escape" then
      menu_select_option = 2
    elseif key == " " then
      if menu_select_option == 0 then
        state = "join_server"
        join_server_buffer = ""
        menu_select_option = 0
      elseif menu_select_option == 1 then
        state = "options"
        menu_select_option = 0
      else -- menu_select_option == 2
        love.event.push("q")
      end
    end
  elseif state == "options" then
    if key == "escape" then
      menu_select_option = 1
    elseif key == " " then
      if menu_select_option == 0 then
        love.graphics.toggleFullscreen( )
      else -- if menu_select_option == 1
        state = "title_screen"
        menu_select_option = 0
      end
    end
  elseif state == "join_server" then
    if key == "escape" then
      menu_select_option = 1
    elseif key == " " then
      if menu_select_option == 0 then
        state = "game"
        com_send_data.cmd = "info"
        menu_select_option = 0
      else -- if menu_select_option == 1
        state = "title_screen"
        menu_select_option = 0
      end
    end
  elseif state == "game" then
    if key == "escape" then
      state = "title_screen"
    elseif key == "left" then
      game_keyb.left = true
    elseif key == "right" then
      game_keyb.right = true
    elseif key == " " then
      game_keyb.space = true
    end
  end
end

function love.keyreleased(key)
  if state == "game" then
    if key == "left" then
      game_keyb.left = false
    elseif key == "right" then
      game_keyb.right = false
    elseif key == " " then
      game_keyb.space = false
    end
  end
end

game_data = nil
uid = nil
bg_scroll = 0
bg_scroll_dt = 0
info = nil
function love.update(dt)
  bg_scroll_dt = bg_scroll_dt + dt
  if bg_scroll_dt > 0.01 then
    bg_scroll_dt = 0
    bg_scroll = bg_scroll + 1
  end
  if state == "game" then
    if not game_data then
      info = "connecting to server "..server.name.." ["..server.url.."]"
    else
      info = nil
    end
    com_send()
    local inc = com_recieve()
    if inc and inc ~= "" then
      if not pcall (function () game_data = json.decode(inc) end) then
        print("Error: Cannot decode json [ "..inc.." ]")
      else
        game_data_time = love.timer.getMicroTime( )
        if game_data.console then
          print(game_data.console)
        end
        if game_data.uid then
          uid = game_data.uid
          print("uid:"..uid)
        end
      end
    end
    com_send_data.cmd = "pull"
    com_send_data.uid = uid
    com_send_data.left = game_keyb.left
    com_send_data.right = game_keyb.right
    com_send_data.space = game_keyb.space
    update_game_objects()
  end
end

function update_game_objects()
  if game_data then
    health = game_data.health
    maxhealth = game_data.maxhealth
--    print_r(game_data)
  end
end

com_send_data = {}
com_waiting = false
function com_send()
  if not com_waiting then
    debug("send data ["..json.encode(com_send_data).."]")
    com_waiting = true
    com:send("input",json.encode(com_send_data));
    com_send_data = {}
  end
end

function com_recieve()
  if com_waiting == true then
    local receive = com:receive("output");
    if receive then
      com_waiting = false
      debug("receive data ["..receive.."]")
      return receive
    end
  end
end

function style_title()
  love.graphics.setFont( title_font )
  love.graphics.setColor( 137, 195, 0, 255 )
end

function style_menu()
  love.graphics.setFont( game_font )
  love.graphics.setColor( 255, 255, 255, 255 )
end

function style_instructions()
  love.graphics.setFont( small_game_font )
  love.graphics.setColor( 255, 255, 255, 255 )
end

function in_table ( needle, haystack )
  for _,v in pairs(haystack) do
    if (v==needle) then
      return true
    end
  end
end

function print_r (t, indent) -- alt version, abuse to http://richard.warburton.it
  local indent=indent or ''
  for key,value in pairs(t) do
    io.write(indent,'[',tostring(key),']') 
    if type(value)=="table" then io.write(':\n') print_r(value,indent..'\t')
    else io.write(' = ',tostring(value),'\n') end
  end
end
