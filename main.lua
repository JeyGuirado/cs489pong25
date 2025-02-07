-- Authors: Jeymar Guirado and Cynthia Somers

local Player = require "Player"
local Ball = require "Ball"
windowWidth = 800
windowHeight = 600

-- Called once per game, setup only
function love.load()
    love.window.setTitle("CS489 Pong")
    windowWidth, windowHeight = love.graphics.getDimensions()
    gameState = "start"

    math.randomseed(os.time()) --random seed

    scoreFont = love.graphics.newFont(56)
    mainFont = love.graphics.newFont(28)

    player1 = Player(25)
    player2 = Player(windowWidth-35)
    ball = Ball()

    soundHit = love.audio.newSource("sounds/Blip_Select.wav","static")
    soundScore = love.audio.newSource("sounds/Pickup_Coin.wav","static")
end

-- Update our variables in the game loop
function love.update(dt)
    
    if gameState == "play" then
        score1 = player1:update(dt)
        score2 = player2:update(dt)
        ball:update(dt)

        if love.keyboard.isDown("w") then
            player1:moveUp(dt)
        elseif love.keyboard.isDown("s") then
            player1:moveDown(dt)
        end
            
        if love.keyboard.isDown("up") then
            player2:moveUp(dt)
        elseif love.keyboard.isDown("down") then
            player2:moveDown(dt)
        end

        if ball.x < 0 then
            player2:scoreUp()
            ball:reset()
        elseif ball.x > windowWidth then
            player1:scoreUp()
            ball:reset()
        end

        if ball.y <= 20 then -- ball hit the top wall
            ball:flipVertDir()
        elseif ball.y >= windowHeight-20 then 
            -- ball hit bottom wall
            ball:flipVertDir()
        end

        if player1:collision(ball) then
            -- collision happened
            ball:handleCollision()
            soundHit:play()
        elseif player2:collision(ball) then
            -- collision with p2
            ball:handleCollision()
            soundHit:play()
        end
        if(score1)then
            gameState="win"
            winner = "1"
        end
        if(score2)then
            gameState="win"
            winner = "2"
        end
    end
    timer = timer + dt

end

-- Draw here
function love.draw()
    if gameState == "start" then
        love.graphics.printf("CS489 Pong",scoreFont,0,100,windowWidth,"center")
        love.graphics.printf("Press Enter to Start \n or Escape to Exit",
        mainFont,0,170,windowWidth,"center")

        
    elseif gameState == "play"then
        player1:draw()
        player2:draw()

        -- making several white lines across the middle of the screen
        love.graphics.setColor(1,1,1)
        love.graphics.setLineWidth(2)
        love.graphics.line(windowWidth/2, 0,(windowWidth/2),(1/5*windowHeight))
        love.graphics.line(windowWidth/2, (2*windowHeight/5),(windowWidth/2),(3/5*windowHeight))
        love.graphics.line(windowWidth/2, (4*windowHeight/5),(windowWidth/2),(windowHeight))
    
        -- now want to make a bunch of smaller black lines to make it look like a dashed line
        love.graphics.setColor(0,0,0)
        love.graphics.line(windowWidth/2, (windowHeight/5),(windowWidth/2),(2/5*windowHeight))
    
        love.graphics.line(windowWidth/2, (3*windowHeight/5),(windowWidth/2),(4/5*windowHeight))
    
        -- resetting color so that it draws the rest of the game in white
        love.graphics.setColor(1,1,1)

        love.graphics.setLineWidth(5)
        love.graphics.line(0, 15, windowWidth, 15)
        love.graphics.line(0,windowHeight-20,windowWidth,windowHeight-20)

        if (player1:collision(ball))then
            a = math.random()
            b = math.random()
            c = math.random()
            change = true
            colors = {a,b,c}
        end
        if (player2:collision(ball))then
            a = math.random()
            b = math.random()
            c = math.random()
            change = true
            colors = {a,b,c}
        end
        if(change == true)then
            love.graphics.setColor(colors[1], colors[2], colors[3])
            ball:draw()
            love.graphics.setColor(1,1,1)
        else
            ball:draw()
        end

        love.graphics.print(player1.score,scoreFont,windowWidth/2-140,40)
        love.graphics.print(player2.score,scoreFont,windowWidth/2+100,40)
    elseif (gameState == "win")then
        
        love.graphics.printf("Player "..winner.." Wins!!!",scoreFont,0,100,windowWidth,"center")
        love.graphics.printf("Press [return] to continue",scoreFont,0,300,windowWidth,"center")
    end

    love.graphics.setLineWidth(5)
    love.graphics.line(0, 15, windowWidth, 15)
    love.graphics.line(0,windowHeight-20,windowWidth,windowHeight-20)

end

-- User input (not depended on time)
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" and gameState=="start" then
        gameState = "play"
    elseif key == "return" and gameState=="win" then
        gameState = "start"

        -- reset scores
        player1.score = 0
        player2.score = 0

        --Reset starting position of paddles
        player1.x = 25
        player1.y = windowHeight/2-40
        player2.x = windowWidth-25
        player2.y = windowHeight/2-40
    end
end
