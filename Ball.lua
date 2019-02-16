--[[The Ball.lua object created similar to the OOPS to be utilized in main.lua
This file contains intiailzer, geometrical discription, render and update for the Ball.
]]

--Create a Ball object for OOPS using the Class library.
Ball = Class{}

function Ball:init()
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = math.random(-50,50)
    self.dy = math.random(2) == 1 and -100 or 100
end



function Ball:reset()
    self.x = virtual_width/2
    self.y = virtual_height/2
    self.dx = math.random(-50,50)
    self.dy = math.random(2) == 1 and -100 or 100
end


function Ball:update(dt)
    self.x = self.x + self.dx*dt
    self.y = self.y + self.dy*dt
end

function Ball:render()
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
end

