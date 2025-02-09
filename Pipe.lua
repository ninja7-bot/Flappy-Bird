Pipe = Class{}

-- since we only want the image loaded once, not per instantation, define it externally
local PIPE_IMG = love.graphics.newImage('media/pipe.png')

-- speed at which the pipe should scroll right to left
PIPE_SPEED = 60

-- height of pipe image, globally accessible
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end 

function Pipe:update(dt)

end    

function Pipe:render()
    love.graphics.draw(PIPE_IMG, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, 1, self.orientation == 'top' and -1 or 1)
end