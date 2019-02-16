--[[ This is my version of the main.lua file for pong6 update.
 myPong6 :: The FPS Update.
]]

-- Importing the necessary libraries and classes.

push = require 'push'
Class = require 'class'
require 'Paddle'
require 'Ball'

window_width = 1380
window_height = 820

virtual_width = 432
virtual_height = 243

-- speed at which we move our Paddle, multiplied by dt.
paddle_speed = 200

function love.load()
    love.graphics.setFilter('nearest','nearest')

end
