local Class = require "hump.class"

local Player = Class{}
function Player:init(x) --constructor
    self.x = x
    self.y = windowHeight/2-40
    self.width = 10
    self.height = 80
    self.score = 0
end

function Player:draw()
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
end

function Player:update(dt)
    if self.score >= 5 then 
        return true
    end
end

function Player:moveUp(dt)
    self.y = self.y - 300*dt
end

function Player:moveDown(dt)
    self.y = self.y + 300*dt
end

function Player:scoreUp()
    self.score = self.score+1
    soundScore:play()
end

function Player:collision(ball)
    -- (obj1.x+obj1.width) >= obj2.x AND (obj2.x+obj2.width) >= obj1.x
    if self.x+self.width >= ball.x 
       and ball.x+ball.size >= self.x 
       and self.y+self.height >= ball.y 
       and ball.y+ball.size >= self.y then
        return true
    else
        return false
    end -- end if

end -- end function

return Player