--[[ The mighty Pong Game {with a retro nostalgia}
 Everything in lua is a table similar to how everything in MATLAB is a matrix.
]]

-- Importing the necessary libraries and classes.
push = require 'push'
Class = require 'class'

--Instead of defining variables and writing code code in main we define entities {dimension, speed} for each object in their own class.
require 'Paddle'
require 'Ball'

window_width = 1280
window_height = 720

virtual_width = 435
virtual_height = 245

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
    push:setupScreen(virtual_width,virtual_height,window_width,window_height,
                    {fullscreen=false, resizable=true, vsync=true})

    --initial position for render of ball and paddles at the start; inputs => (x,y,W,H)
    player1 = Paddle(1,30,5,20)
    player2 = Paddle(virtual_width-6,virtual_height-40,5,20)
    
    ball = Ball(virtual_width/2,virtual_height/2,4,4)

    -- gameState variable created to transition from start to play and end states during run.
    gameState = 'start'
    servingPlayer = 1

    -- Customized fonts for different information display
    smallFont = love.graphics.newFont('font.ttf',8)
    largeFont = love.graphics.newFont('font.ttf',16)
    
    scoreFont = love.graphics.newFont('font.ttf',32)

    -- set the sound effects, creating a table
    sounds = {['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
            ['score'] = love.audio.newSource('sounds/score.wav','static'),
            ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static')}
    
    humanPlayers = 0
end

-- This is to enable the resizing of the screen and maintain the correct aspect ratio of the game
function love.resize(w,h)
    push:resize(w,h)
end

-- updates this function frame-by-frame {dt is each frame} passed in this function.
function love.update(dt)

    if gameState == 'serve' then
        ball.dy = math.random(-50,50)
        if servingPlayer == 1 then
            ball.dx = math.random(100,150)
        else
            ball.dx = -math.random(100,150)
        end

    elseif gameState == 'play' then
        -- detect ball collision with paddles
        if ball:collides(player1) then
            ball.dx = -ball.dx*1.03
            -- shift the ball instantly to edge of paddle on detecting collion
            ball.x = player1.x + 5
            
            -- keep velocity going but in random manner
            if ball.dy < 0 then
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
            sounds['paddle_hit']:play()
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx*1.03
            ball.x = player2.x - 5

            if ball.dy < 0 then
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
            sounds['paddle_hit']:play()
        end

        -- Detect upper and lower screen boundary collision
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        elseif ball.y >= virtual_height then
            ball.y = virtual_height
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- Keeping Score and check if ball is on extreme left or right of screen.
        if ball.x <= 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

         -- Check if player2 has won the game.
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'gameOver'
            else
                gameState = 'serve'
                ball:reset()
            end    
        
        elseif ball.x >= virtual_width then
            player1Score = player1Score + 1
            servingPlayer = 2
            sounds['score']:play()

         -- Wining check from player1.
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'gameOver'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        -- player1 and player2 movements
        if humanPlayers == 2 then
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

        elseif humanPlayers == 1 then
            if love.keyboard.isDown('w') then
                player1.dy = -paddle_speed
            elseif love.keyboard.isDown('s') then
                player1.dy = paddle_speed
            else
                player1.dy = 0
            end

            --computer play  {but it's getting a bit tought, he always returns}
            player2.y = ball.y - 5
        end
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
    end

    if key == '1' then
        gameState = 'serve'
        humanPlayers = 1
        
    elseif key == '2' then
        gameState = 'serve'
        humanPlayers = 2

    elseif key == '3' then
        gameState = 'Instructions'

    elseif key == 'enter' or key == 'return' then
        if gameState == 'serve' then
            gameState = 'play'
            -- If game is over reset the scores and ball to start a new game.
        elseif gameState == 'gameOver' then
            -- Game goes into a reset phase here, reseting score and giving serve to loosing player
            gameState = 'start'
            ball:reset()
            player1Score = 0
            player2Score = 0

            -- Giving serve to loosing player for next game.
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        elseif gameState == 'Instructions' then
            gameState = 'start'
        
        end
    end
end

-- as-per function name used for drawing something on the screen, geometry of object drawn defined here.
-- called after the update function.
function love.draw()
    push:start()
    
    --clear the screen with a specific color.
    love.graphics.clear(40, 45, 52, 0.3)

    displayScore()

    -- Creating custom new fonts to give retro asthetics to the game.
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Welcome to Pong Game!',0,10,virtual_width,'center')
        love.graphics.printf('Select number of Pong players',0,20,virtual_width,'center')
        love.graphics.printf('Press 1 : For single play',0,40,virtual_width/2,'center')
        love.graphics.printf('Press 2 : For Multiplay',virtual_width/2,40,virtual_width/2,'center')
        love.graphics.printf('Press 3 : For controls and instructions',0,60,virtual_width,'center')
    elseif gameState == 'serve' then
        love.graphics.printf('Press Enter to serve',0,10,virtual_width,'center')

    elseif gameState == 'gameOver' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player '..tostring(winningPlayer)..' wins!! :) ',0,10,virtual_width,'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to start a new game',0,40,virtual_width,'center')

    elseif gameState == 'Instructions' then
        player1 = Paddle(1,180,5,20)
        love.graphics.setFont(smallFont)
        love.graphics.printf('w : To Move paddle up',0,40,virtual_width,'left')
        love.graphics.printf('d : To Move paddle down',0,60,virtual_width,'left')
        love.graphics.printf('up key : To Move paddle up',virtual_width/2,40,virtual_width/2,'center')
        love.graphics.printf('down key : To Move paddle down',virtual_width/2,60,virtual_width/2,'center')

    end

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
    -- to concatenate string in lua we use " .. "
    love.graphics.print('FPS' .. tostring(love.timer.getFPS()),10,10)
end

-- Create a new font and display both player's score on screen
function displayScore()

    if gameState == 'Instructions' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player 1 : Controls',0,20,virtual_width,'left')
        love.graphics.printf('Player 2 : Controls',virtual_width/2,20,virtual_width/2,'center')
        love.graphics.printf('Press enter to retun',0,80,virtual_width,'center')

    else
        love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(player1Score),virtual_width/2-50,virtual_height/3)
        love.graphics.print(tostring(player2Score),virtual_width/2+30,virtual_height/3)
    end

end