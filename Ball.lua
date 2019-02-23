--[[The Ball.lua object created similar to the OOPS to be utilized in main.lua
This file contains intiailzer, geometrical discription, render and update for the Ball.
]]

--Create a Ball object for OOPS using the Class library.
Ball = Class{}

-- Initialization of the geometry, dimensions and speed. x,y,W,H are to be defined in main file for subsequent Paddle object.
-- Here x,y,W,H are to be defined in main file for subsequent object Ball.
function Ball:init(x,y,width,height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = math.random(-50,50)
    self.dy = math.random(2) == 1 and -100 or 100
    -- the above line of code is similar to the ternary operator used in C++
end

-- Reset the ball to ceter of the screen
function Ball:reset()
    self.x = virtual_width/2
    self.y = virtual_height/2
    self.dx = math.random(-50,50)
    self.dy = math.random(2) == 1 and -100 or 100
end

function Ball:collides(paddle)
    -- checks weither the right, left edge of either is farther.
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end
    -- checks the bottom egdes of both for collison/contact
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end
    return true
end

-- Update's the ball's position frame-by-frame.
function Ball:update(dt)
    self.x = self.x + self.dx*dt
    self.y = self.y + self.dy*dt
end

-- Ball is simply rendered as a rectangle.
function Ball:render()
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
end
