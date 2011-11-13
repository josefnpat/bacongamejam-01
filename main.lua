function love.load()
  img_player_center = love.graphics.newImage( "assets/player-center.png" )
  img_player_left = love.graphics.newImage( "assets/player-left.png" )
  img_player_right = love.graphics.newImage( "assets/player-right.png" )
  img_enemy = love.graphics.newImage( "assets/enemy.png" )
  img_bullet = {}
  img_bullet[0] = love.graphics.newImage( "assets/bullet-0.png" )
  title_font = love.graphics.newFont( "assets/octin_spraypaint.ttf", 128 )
  game_font = love.graphics.newFont( "assets/graphicpixel.ttf", 64 )
  state = "title_screen"
  game_name = 'Love 1942';
  title_select_option = 0
end

function love.draw()
  if state == "title_screen" then
    style_title()
    local w = title_font:getWidth(game_name)
    local h = title_font:getHeight(game_name)
    local w_w = love.graphics.getWidth( )
    local x = (w_w - w ) /2
    local y = 16
    love.graphics.print(game_name, x, y)
    style_game()
    local x_indent = 80
    local y_indent = 64
    love.graphics.draw(img_enemy,x,y + h + title_select_option * 64 + y_indent )
    love.graphics.print("join server", x + x_indent, y + h + y_indent)
    love.graphics.print("options", x + x_indent, y + h + 64 + y_indent)
    love.graphics.print("exit", x + x_indent, y + h + 128 + y_indent)
  else
    
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.push("q")
  end
  if state == "title_screen" then
    if key == "up" then
      if title_select_option == 0 then
        title_select_option = 2
      else
        title_select_option = title_select_option - 1
      end
    elseif key == "down" then
      if title_select_option == 2 then
        title_select_option = 0
      else
        title_select_option = title_select_option + 1
      end
    elseif keu == " " then
    
    end
  else
  end
end

function love.update()
  --if 
end

function style_title()
  love.graphics.setFont( title_font )
  love.graphics.setColor( 137, 195, 0, 255 )
end

function style_game()
  love.graphics.setFont( game_font )
  love.graphics.setColor( 255, 255, 255, 255 )
end
