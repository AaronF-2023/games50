--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
end

function PlayState:update(dt)
    
    if scrolling then
        -- update timer for pipe spawning
        gTimer = gTimer + dt

        -- spawn a new pipe pair every second and a half
        -- ASSIGNMENT: Randomize the interval between pipe spawns
        if gTimer > gNextPipeSpawnTime then
            -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length (90 pixels) from the bottom
            local y = math.max(-PIPE_HEIGHT + 10, 
                math.min(gLastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90))
            gLastY = y

            -- add a new pipe pair at the end of the screen at our new Y
            table.insert(gPipePairs, PipePair(y))

            -- ASSIGNMENT: Set the next time to wait before spawning the
            -- next pipe
            gNextPipeSpawnTime = math.random(175, 400) / 100
            -- reset timer
            gTimer = 0
        end

        -- for every pair of pipes..
        for k, pair in pairs(gPipePairs) do
            -- score a point if the pipe has gone past the bird to the left all the way
            -- be sure to ignore it if it's already been scored
            if not pair.scored then
                if pair.x + PIPE_WIDTH < gBird.x then
                    gScore = gScore + 1
                    pair.scored = true
                    sounds['score']:play()
                end
            end

            -- update position of pair
            pair:update(dt)
        end

        -- we need this second loop, rather than deleting in the previous loop, because
        -- modifying the table in-place without explicit keys will result in skipping the
        -- next pipe, since all implicit keys (numerical indices) are automatically shifted
        -- down after a table removal
        for k, pair in pairs(gPipePairs) do
            if pair.remove then
                table.remove(gPipePairs, k)
            end
        end

        -- simple collision between bird and all pipes in pairs
        for k, pair in pairs(gPipePairs) do
            for l, pipe in pairs(pair.pipes) do
                if gBird:collides(pipe) then
                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    gStateMachine:change('score')
                end
            end
        end

        -- update bird based on gravity and input
        gBird:update(dt)

        -- reset if we get to the ground
        if gBird.y > VIRTUAL_HEIGHT - 15 then
            sounds['explosion']:play()
            sounds['hurt']:play()

            gStateMachine:change('score')
        end
    end

    if love.keyboard.wasPressed('p') or love.mouse.wasPressed(2) then
        sounds['pause']:play()
        scrolling = false
        gStateMachine:change('pause')
    end
end

function PlayState:render()
    for k, pair in pairs(gPipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(gScore), 8, 8)

    gBird:render()
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end