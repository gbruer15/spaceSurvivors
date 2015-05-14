local state = {}

local enemy = require('Game/Enemy/enemy')
function state.load()
	state.player = require("Game/Player/player").make()
	state.camera = require("1stPartyLib/display/camera").make()

	state.playerMissiles = {}
	state.enemyMissiles = {}
	state.enemies = {}
end

function state.update(dt)
	state.player:update(dt)
	for i=#state.player.missiles, 1, -1 do
		table.insert(state.playerMissiles, table.remove(state.player.missiles))
	end


	for i=#state.playerMissiles,1,-1 do
		local missile = state.playerMissiles[i]
		missile:update(dt)
		if state.camera.isOffscreen(missile.x, missile.y) and state.camera.isOffscreen(missile.endX, missile.endY) then
			table.remove(state.playerMissiles,i)
		else
			for j,e in ipairs(state.enemies) do
				if missile:isHittingRectangle(e.collisionBox:getRect()) then
					e.health = e.health - missile.damage
					table.remove(state.playerMissiles,i)
					break
				end
			end
		end
	end
	for i=#state.enemies,1,-1 do
		local v = state.enemies[i]
		v:update(dt)
		for j=#v.missiles, 1, -1 do
			table.insert(state.enemyMissiles, table.remove(v.missiles))
		end
		if v.drawBox:getTop() >= state.camera.y + state.camera.height/2 then
			table.remove(state.enemies,i)
		elseif v.health <= 0 then
			state.player.cash = state.player.cash + v.loot
			state.player.score = state.player.score + v.points
			state.player.kills = state.player.kills + 1
			state.level.enemiesKilled = state.level.enemiesKilled + 1
			table.remove(state.enemies,i)
		elseif state.player.collisionBox:collideRectangle(v.collisionBox) then
			state.player.dead = true
		end
	end

	if not state.player.dead then
		for i,missile in ipairs(state.enemyMissiles) do
			missile:update(dt)
			if missile:isHittingRectangle(state.player.collisionBox:getRect()) then
				state.player.dead = true
			end
		end
	end
end

function state.draw()
	state.player:draw()

	love.graphics.setColor(255,255,0)
	for i,v in ipairs(state.enemyMissiles) do
		v:draw()
	end

	for i,v in ipairs(state.enemies) do
		v:draw()
	end

	love.graphics.setColor(255,0,0)
	for i,v in ipairs(state.playerMissiles) do
		v:draw()
	end
end

function state.keypressed(key)

end

function state.mousepressed(x,y,button)
	state.player:mousepressed(x,y,button)
	table.insert(state.enemies, enemy.make{x=math.random(100,500),health = 1,y=-80})
end

return state