--[[ This is my version of the main.lua file for pong6 update.
 Pong_Game_5 :: The class update.
 Everything in lua is a table similar to how everything in MATLAB is a matrix.
]]


-- Importing the necessary libraries and classes.
push = require 'push'
Class = require 'class'

--Instead of defining variables and writing code code in main we define entities {dimension, speed} for each obejct in their own class.
require 'Paddle'
require 'Ball'

window_width = 1380
window_height = 820

virtual_width = 432
virtual_height = 243

-- speed at which we move our Paddle, multiplied by dt.
paddle_speed = 200

function love.load()
    -- Setting default filter to "nearest" type, so that the graphics are not blurried and gives a better visual rendering to game.
    love.graphics.setDefaultFilter('nearest','nearest')

    -- random seed gereration for call. "os.time" is used as a reference staring point for generation of random seed
    -- since it needs an initiall reference point and os.time would be different each time we run the program.
    math.randomseed(os.time())
    
    love.window.setTitle('Pong')

    -- Initialize score variables, used for score keeping throught the game.
    player1Score = 0
    player2Score = 0

    -- Setting up intial screen to be rendered in a small virtual dimentions, using push library to render from original
    -- dimentions to a smaller dimenion to give a retro look to game.
    push:setupScreen(virtual_width,virtual_height,window_width,window_height,
    {fullscreen=false,resizable=false,vsync=true})

    --initial position for render of ball and paddles at the start; inputs => (x,y,W,H)
    player1 = Paddle(1,30,5,20)
    player2 = Paddle(virtual_width-6,virtual_height-40,5,20)
    
    ball = Ball(virtual_width/2,virtual_height/2,3,3)

    -- gameState variable created to transition from start to play and end states during run.
    gameState = 'start'

end

-- updates this function frame-by-frame {dt is each frame} passed in this function.
function love.update(dt)
    -- player1 and player2 movements
    if love.keyboard.isDown('w') then
        player1.dy = -paddle_speed
    elseif love.keyboard.isDown('s') then
        player1.dy = paddle_speed
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -paddle_speed
    elseif love.keyboard.isDown('down') then
        player2.dy = paddle_speed
    else
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end
 
    player1:update(dt)
    player2:update(dt)
end

-- Special keys press handling during the game.
function love.keypressed(key)
    -- keys can be acessed by string names which are already defined in love and lua
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()
        end
    end
end

-- asper function name used for drawing something on the screen, geometry of object drwan defined here.
-- called after the update function.
function love.draw()
    push:start()

    -- Creating custom new fonts to give a retro asthetic to the game.
    smallFont = love.graphics.newFont('font.ttf',8)
    scoreFont = love.graphics.newFont('font.ttf',32)

    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Welcome to Pong Game',0,10,virtual_width,'center')
    else
        love.graphics.printf("Let's play",0,10,virtual_width,'center')
    end

    love.graphcis.setFont(scoreFont)
    love.graphics.print(tostring(player1Score),virtual_width/2-30,virtual_height/3)
    love.graphics.print(tostring(player2Score),virtual_width/2+30,virtual_height/3)
    
    -- Render paddles using subsequent classes
    player1:render()
    player2:render()

    -- render ball using it's class under method
    ball:render()

    -- a simple fucntion created to display FPS on screen for references {defined at the end of code}
    displayFPS()

    push:finish()
end

-- This function simply displays FPS of current state of the game.
function displayFPS()
    love.graphics.setFont(smallFont)
    -- love.grapphics.setColor(R,G,B,opaqueness)
    love.graphics.setColor(0,255,0,255)
    love.graphics.printf('FPS' .. tostring(love.timer.getFPS()),10,10)
end