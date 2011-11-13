server = {}
require("servers")

function love.load()
  img_player_center = love.graphics.newImage( "assets/player-center.png" )
  img_player_left = love.graphics.newImage( "assets/player-left.png" )
  img_player_right = love.graphics.newImage( "assets/player-right.png" )
  img_enemy = love.graphics.newImage( "assets/enemy.png" )
  img_bullet = {}
  img_bullet[0] = love.graphics.newImage( "assets/bullet-0.png" )
  title_font = love.graphics.newFont( "assets/octin_spraypaint.ttf", 128 )
  game_font = love.graphics.newFont( "assets/graphicpixel.ttf", 64 )
  small_game_font = love.graphics.newFont( "assets/graphicpixel.ttf", 16 )
  state = "title_screen"
  game_name = 'Love 1942';
  menu_select_option = 0
end

function love.draw()
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
  else
    style_instructions()
    love.graphics.print("Unknown State `"..state.."`", 0, 0)
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
  love.graphics.print("up | down: menu", x + x_indent, 600-80)
  love.graphics.print("wasd: up left down right", x + x_indent, 600-64)
  love.graphics.print("space: select | shoot", x + x_indent, 600-48)
  love.graphics.print("A josefnpat Production, bacongamejam 2011", x + x_indent, 600-32)
end

menu_max = 0
join_server_buffer = ""
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
    if key == " " then
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
    if key == " " then
      if menu_select_option == 0 then
        love.graphics.toggleFullscreen( )
      else -- if menu_select_option == 1
        state = "title_screen"
        menu_select_option = 0
      end
    end
  elseif state == "join_server" then
    if in_table(key,{"0","1","2","3","4","5","6","7","8","9"}) then
      join_server_buffer = join_server_buffer .. key
    elseif key == " " then
      if menu_select_option == 0 then
        
      else -- if menu_select_option == 1
        state = "title_screen"
        menu_select_option = 0
      end
    end
  end
end

function love.update()
  --if 
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
