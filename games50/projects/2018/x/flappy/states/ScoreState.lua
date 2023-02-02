--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

function ScoreState:enter()
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- ASSIGNMENT: Award a medal to the player for their efforts.
    -- Sorry for the dodgy scaling. The images are a bit large
    awardLevel = GetAwardLevel(gScore)
    if awardLevel ~= string.empty then
        love.graphics.push()
        love.graphics.scale(0.075, 0.075)
        love.graphics.draw(medals[awardLevel],
            ((VIRTUAL_WIDTH / 2) - ((medals[awardLevel]:getWidth() * 0.075) / 2)) / 0.075, 115 / 0.075)
        love.graphics.pop()
    end

    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(gScore), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end

function GetAwardLevel(score)
    if score < 1 then
        awardLevel = string.empty
    elseif score >= 1 and score < 3 then
        awardLevel = 'bronze'
    elseif score >= 3 and score < 6 then
        awardLevel = 'silver'
    elseif score >= 6 then
        awardLevel = 'gold'
    end

    return awardLevel
end