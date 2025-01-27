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

end

-- Update our variables in the game loop
function love.update(dt)
    if gameState == "play" then
        player1:update(dt)
        player2:update(dt)
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
    end

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

        ball:draw()

        love.graphics.print(player1.score,scoreFont,windowWidth/2-140,40)
        love.graphics.print(player2.score,scoreFont,windowWidth/2+100,40)
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
    end
end