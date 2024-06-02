local world = {}

AABB = function(obj1, obj2) 
    --[[
    local x1, y1, w1, h1 = obj1.position.x, obj1.position.y, obj1.size.x, obj1.size.y
    local x2, y2, w2, h2 = obj2.position.x, obj2.position.y, obj2.size.x, obj2.size.y

    return x1 < x2+w2 and
    x2 < x1+w1 and
    y1 < y2+h2 and
    y2 < y1+h1]]

    if ((obj2.position.x >= obj1.position.x + obj1.size.x) or
        (obj2.position.x + obj2.size.x <= obj1.position.x) or
        (obj2.position.y >= obj1.position.y + obj1.size.y) or
         (obj2.position.y + obj2.size.y <= obj1.position.y)) then
        return false 
    else
        return true
    end
end
    
function resolveCollision(obj)
    --how?????
end

function getUnitVetor(vec)
    local magnitude = math.sqrt(vec.x^2 + vec.y^2)
    return {x = vec.x/magnitude, y = vec.y/magnitude}
end

local box = {}
box.__index = box

function box.new()
    local self = {}
    setmetatable(self, box)

    self.position = {x = 0, y = 0}
    self.size = {x = 10, y = 10}
    self.canCollide = true

    return self
end

function box:update()
    if self.size.x ~= 50 then
        print("huh")
    end
    
end

function box:draw()
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
end

function box:destroy()
    for i, v in ipairs(world) do
        if v == self then
            table.remove(world, i)
        end
    end
end

local part = {}
part.__index = part
setmetatable(part, box)

function part.new()
    local self = box.new()
    setmetatable(self, part)

    self.velocity = {x = 0, y = 0}

    return self
end

function part:update()
    self.position.x = self.position.x + self.velocity.x
    self.position.y = self.position.y + self.velocity.y
end

local bullet = {}
bullet.__index = bullet
setmetatable(bullet, part)

function bullet.new()
    local self = part.new()
    setmetatable(self, bullet)

    self.damage = 1

    return self
end

function bullet:update()
    part.update(self)
    for i, v in ipairs(world) do
        if v ~= self and v ~= player and AABB(self, v) then
            if v.health then
                v.health = v.health - self.damage
                print(v.health)
            end
            self:destroy()
            break
        end
    end
end

function love.load()
    player = part.new()
    player.speed = 10
    table.insert(world, player)

    local newbox = box.new()
    newbox.position = {x = 500, y = 500}
    newbox.size = {x = 50, y = 50}
    newbox.health = 5
    table.insert(world, newbox)
end

function love.update(dt)
    for _, v in pairs(world) do
        v:update()
    end


    if love.keyboard.isDown("w") then
        player.velocity.y = player.velocity.y - player.speed * dt
    end
    if love.keyboard.isDown("s") then
        player.velocity.y = player.velocity.y + player.speed * dt
    end
    if love.keyboard.isDown("a") then
        player.velocity.x = player.velocity.x - player.speed * dt
    end
    if love.keyboard.isDown("d") then
        player.velocity.x = player.velocity.x + player.speed * dt
    end

    if player.velocity.x > 5 then
        player.velocity.x = 5
    end
    if player.velocity.x < -5 then
        player.velocity.x = -5
    end
    if player.velocity.y > 5 then
        player.velocity.y = 5
    end
    if player.velocity.y < -5 then
        player.velocity.y = -5
    end

    if love.keyboard.isDown("space") then
        if player.debounce then return end
        player.debounce = true
        local shotSource = love.audio.newSource("Sound/shot.wav", "static")
        shotSource:play()
        local newBullet = bullet.new()
        newBullet.position.x = player.position.x
        newBullet.position.y = player.position.y
        local unitVelocity = getUnitVetor(player.velocity)
        newBullet.velocity = {x = unitVelocity.x * 15, y = unitVelocity.y * 15}
        table.insert(world, newBullet)
    else
        --mouse is up
        player.debounce = false
    end
end

function love.draw()
    for _, v in pairs(world) do
        v:draw()
    end
end