--[[
    Pause State
    Author: Aaron Ferris
    aaron.ferris@gmail.com

    Pauses the game screen, and presents a 'pause' message on the screen
    so the player can take a break, then resume playing.
]]

PauseState = Class{__includes = BaseState}

function PauseState:enter()
    sounds['music']:pause()
    scrolling = false
end

function PauseState:update(dt)
    -- return to countdown + play if p is pressed
    if love.keyboard.wasPressed('p') or love.mouse.wasPressed(2) then
        sounds['music']:play()
        scrolling = true
        gStateMachine:change('play')
    end
end

function PauseState:render()
    -- render PAUSED in the middle of the screen
    love.graphics.setFont(hugeFont)
    love.graphics.push()
    love.graphics.translate(0, VIRTUAL_HEIGHT)
    love.graphics.rotate(-math.pi/2)
    love.graphics.printf('=', 0, (VIRTUAL_WIDTH - 28) / 2, VIRTUAL_HEIGHT, 'center')
    love.graphics.pop()
end