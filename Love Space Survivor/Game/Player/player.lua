local playerfunctions = {}
require('Game/missile')
function playerfunctions.make(att)
	local self = {}
	setmetatable(self, {__index = playerfunctions})

	self.x = STATE.camera.width/2
	self.y = STATE.camera.height/2
	self.drawBox = rectangle.make(15,125, self) --40

	self.collisionBox = rectangle.make(10,10,self)--20

	self.Image = images.spaceship
	self.drawBox.height = self.drawBox.width/self.Image.width*self.Image.height
	self.drawBox.dy = self.drawBox.height/2

	self.missiles = {}


	--these could be initialized from a save file
	self.cash = 0
	self.score = 0
	self.kills = 0

	self.fullauto = true
	self.fireDelay = 0.1--0.5

	self.currentLevel = 1
	self.lives = 5

	self.missileSpeed = 450
	self.missileDamage = 15
	
	---------------------------------

	self.fireCountdown = self.fireDelay
	return self
end

function playerfunctions:update(dt)
	self.x,self.y = MOUSE.x,MOUSE.y

	if self.x < STATE.camera.x - STATE.camera.width/2 then
		self.x = STATE.camera.x
	elseif self.x > STATE.camera.x + STATE.camera.width/2 then
		self.x = STATE.camera.x + STATE.camera.width/2
	end

	self.fireCountdown = self.fireCountdown - dt
	if self.fireCountdown <= 0  then
		if self.fullauto then
			self:fireMissile()
			self.fireCountdown = self.fireDelay
		else
			self.fireCountdown = 0
		end
	end

end

function playerfunctions:draw(drawColBox,colBoxMode,color)
	love.graphics.setColor(255,255,255)
	--self.drawBox:draw('fill',self.x,self.y)
	love.graphics.draw(self.Image.image,self.drawBox:getLeft(),self.drawBox:getTop(),0,self.drawBox.width/self.Image.width, self.drawBox.height/self.Image.height)

	if drawColBox then
		love.graphics.setColor(color or {0,255,0,100})
		self.collisionBox:draw(colBoxMode or 'line')
	end
end

function playerfunctions:fireMissile()
	table.insert(self.missiles,missile.make{
											x=self.x-10
											,y=self.y-self.drawBox.height/2
											,speed=self.missileSpeed
											,angle=-math.pi/2
											,damage=self.missileDamage

										}
									)
	table.insert(self.missiles,missile.make{
											x=self.x+10
											,y=self.y-self.drawBox.height/2
											,speed=self.missileSpeed
											,angle=-math.pi/2
											,damage=self.missileDamage

										}
									)
	table.insert(self.missiles,missile.make{
											x=self.x
											,y=self.y-self.drawBox.height/2
											,speed=self.missileSpeed
											,angle=-math.pi/4
											,damage=self.missileDamage

										}
									)
	table.insert(self.missiles,missile.make{
											x=self.x
											,y=self.y-self.drawBox.height/2
											,speed=self.missileSpeed
											,angle=-math.pi/4*3
											,damage=self.missileDamage

										}
									)
end



function playerfunctions:keypressed(key)

end

function playerfunctions:mousepressed(x,y,button)
	if not self.fullauto and self.fireCountdown <= 0 then
		self:fireMissile()
		self.fireCountdown = self.fireDelay
	end
end

return playerfunctions