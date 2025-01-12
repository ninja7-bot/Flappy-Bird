Pipe = Class{}

local PIPE_IMG = love.graphics.newImage('pipe.png')

local PIPE_SCROLL = -60

function Pipe:init()
    self.x = VIRTUAL_WIDTH + 16
    self.y = math.random(VIRTUAL_HEIGHT/4, VIRTUAL_HEIGHT - 10)

    self.width = PIPE_IMG:getWidth()
end    

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end    

function Pipe:render()
    love.graphics.draw(PIPE_IMG, self.x, self.y)
end    