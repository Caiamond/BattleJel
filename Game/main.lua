local world = {}

local player = {
    position = {x = 50, y = 50},

    speed = 5
}

local enemy = {
    position = {x = 500, y = 500},

    speed = 3
}

table.insert(world, player)
table.insert(world, enemy)

function love.load()

end

function love.update()
    if love.keyboard.isDown("w") then
        player.position.y = player.position.y - player.speed
    end
    if love.keyboard.isDown("a") then
        player.position.x = player.position.x - player.speed
    end
    if love.keyboard.isDown("s") then
        player.position.y = player.position.y + player.speed
    end
    if love.keyboard.isDown("d") then
        player.position.x = player.position.x + player.speed
    end
    

    local magnitude = math.sqrt(player.position.x^2 - enemy.position.x^2 + player.position.y^2 - enemy.position.y^2)

    local unit = {}
    unit.x = math.sqrt(player.position.x^2 - enemy.position.x^2)
    unit.y = math.sqrt(player.position.y^2 - enemy.position.y^2)


    enemy.position.x = enemy.position.x + (player.position.x - enemy.position.x)/magnitude * 2
    enemy.position.y = enemy.position.y + (player.position.y - enemy.position.y)/magnitude * 2
end

function love.draw()
    for k, v in pairs(world) do
        love.graphics.rectangle("line", v.position.x, v.position.y, 50, 50)
    end
    
end