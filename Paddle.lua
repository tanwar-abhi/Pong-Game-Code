-- The Paddle object created using the class.lua library creating a Paddle object to be used in main.lua file.

Paddle = Class{}

-- Initialization for the values of geometric dimentions and speed of the Paddle.
-- dy being speed in Y-direction {paddles can only move up or down}
function Paddle:init(x,y,width,height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

-- "dt" is the frame rate feeded as input so that the function is updated per frame.
function Paddle:update(dt)
    -- Also setting bound for the Paddles so they don't go beyond the screen size of "virtual_height".
    if self.dy < 0 then
        self.y = math.max(0,self.y + self.dy*dt)

    else
        self.y = math.min(virtual_height-self.height, self.y + self.dy*dt)
    end
end

--To create {render} a rectangle using the user defined values
function Paddle:render()
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
end
