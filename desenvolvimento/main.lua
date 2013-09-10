-----------------------------------------------------------------------------------------
-- main.lua
--medidas da tela 320X570
-----------------------------------------------------------------------------------------
-- Your code here
local fisica = require("physics")
fisica.start()
fisica.setGravity(0, 8.0)
-- plano de fundo do jogo
local fundo = display.newImage("fundo.png")
fundo.y = display.contentHeight/2
-- carregar personagem
local bola = display.newImage("bola.png")
bola.x = display.contentWidth/2
bola.y = 0
fisica.addBody(bola, {bounce=0.3, friction=1.0})
-- primeiro obstaculo para impedir de bola cair no inicio do jogo
obstaculo = display.newImage("obs.png")
obstaculo.x = 157
obstaculo.y = 480
transition.to(obstaculo,{x= 157,y=-40, time = 7000})
fisica.addBody (obstaculo, "static",{bounce = 0.3,friction=1.0})
-- variaveis para o uso no código
local motionx = 0
local speed = 2
local obstaculos = {}
local numObstaculos = 0 -- variavel para contagem de obstaculos
local tick = 1500 -- medida de tempo para cada obstaculo aparecer
local w = 0
-- carregar obstaculos no jogo
local function loadObstaculos()
    numObstaculos = numObstaculos + 1
	obstaculos[numObstaculos] = display.newImage("obs.png")
	fisica.addBody (obstaculos[numObstaculos], "static",{bounce = 0.3,friction=1.0})
    local whereFrom = math.random(3)  --determinar a direção do asteróide irá aparecer
	obstaculos[numObstaculos].myName = "obstaculos"
     -- condições para os obstaculos surgirem no jogo
     if (whereFrom == 1) then
	   w = math.random(45,120)
	   obstaculos[numObstaculos].x = w
       obstaculos[numObstaculos].y = 480
	   transition.to(obstaculos[numObstaculos],{x= w,y=-40, time = 7000})
     elseif (whereFrom == 2) then
	   w = math.random(157,200)
	   obstaculos[numObstaculos].x = w
       obstaculos[numObstaculos].y = 480
       transition.to(obstaculos[numObstaculos],{x= w,y=-40, time = 7000})
	   elseif (whereFrom == 3) then
	    w = math.random(200, 280)
	    obstaculos[numObstaculos].x = w
        obstaculos[numObstaculos].y = 480
        transition.to(obstaculos[numObstaculos],{x= w,y=-40, time = 7000})
     end
end
-- função para parada do personagem
local function stop (event)
	if event.phase =="ended" then
		motionx = 0;
	end
end
Runtime:addEventListener("touch", stop )
-- direcional esquerdo
local setaEsq = display.newImage("seta.png")
setaEsq.x = 45; setaEsq.y = 500;
setaEsq.rotation = 180;
-- direcional direito
local setaDir = display.newImage("seta.png")
setaDir.x = 280; setaDir.y = 500;
-- movimenta a bola
local function moveBola (event)
	bola.x = bola.x + motionx;
end
Runtime:addEventListener("enterFrame", moveBola)
--mover seta esquerda
function setaEsq:touch()
	motionx = -speed;
end
setaEsq:addEventListener("touch",left)
-- mover seta direita
function setaDir:touch()
	motionx = speed;
end
setaDir:addEventListener("touch",right)
-- loop do jogo
local function loop()
   loadObstaculos()
   for i=1,table.getn(obstaculos) do
	if(obstaculos[i].myName~= nil) then
       obstaculos[i]:removeSelf()
       obstaculos[i].myName=nil
    end
   end
end
-- metodo que define o delay para surgimento dos obstaculos
timer.performWithDelay(tick,loop ,0)
