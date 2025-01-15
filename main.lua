push = require 'push'
Class = require 'class'

require 'Pipe'
require 'Bird'
require 'PipePair'
require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/ScoreState'
require 'states/PlayState'
require 'states/TitleScreenState'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- images we load into memory from files to later draw onto the screen
local background = love.graphics.newImage('media/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('media/ground.png')
local groundScroll = 0

local BG_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 100

local BG_LOOP_POINT = 413
local GROUND_LOOPING_POINT = 514

local scrolling = true

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Flappy Bird! By Dark Samurai')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)


    sounds = {
        ['music'] = love.audio.newSource('media/marios_way.mp3', 'static'),
        ['jump'] = love.audio.newSource('media/jump.wav', 'static'),
        ['score'] = love.audio.newSource('media/score.wav', 'static'),
        ['explosion'] = love.audio.newSource('media/hit.wav', 'static'),
        ['hurt'] = love.audio.newSource('media/hurt.wav', 'static')

    }

    sounds['music']:setLooping(true)
    sounds['music']:play()


    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end    

function love.update(dt)
    backgroundScroll = (backgroundScroll + BG_SCROLL_SPEED * dt) % BG_LOOP_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end    


function love.draw()
    push:start()
    
    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end