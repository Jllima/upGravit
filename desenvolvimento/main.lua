-----------------------------------------------------------------------------------------
-- main.lua
--medidas da tela 320X570
-----------------------------------------------------------------------------------------

local fisica = require("physics")
fisica.start()
fisica.setGravity(0, 8.0)
--fisica.setDrawMode("hybrid")

-- variaveis para o uso no código
local motionx = 0
local speed = 2
local obstaculos = {}
local numObstaculos = 0 -- variavel para contagem de obstaculos
local tick = 1200--1500 -- medida de tempo para cada obstaculo aparece
local w = 0 -- guarda a posição x
local tempo = 7000 -- guarda o tempo utilizado no transation
local score = 0 -- pontuação

-- plano de fundo do jogo
local fundo = display.newImage("fundo.png")
fundo.y = display.contentHeight/2

--linha de topo
local topo = display.newRect(0,-20,display.contentWidth,1)
fisica.addBody(topo,"static")
topo.myName="topo"

-- carregar personagem
local bola = display.newImage("bola.png")
bola.x = display.contentWidth/2
bola.y = 0
fisica.addBody(bola, {bounce=0.3, friction=0.5}) --radius=13
bola.myName="bola"

-- função utilizada no transation.to para retirar os obstaculos
local function some (self)
   self:removeSelf()
end

-- primeiro obstaculo para impedir que a bola caia no inicio do jogo
local obstaculo = display.newImage("obs.png")
obstaculo.x = 157
obstaculo.y = 480
transition.to(obstaculo,{x= 157,y=0, time = 7000,onComplete = some})
fisica.addBody (obstaculo, "static",{bounce = 0.3,friction=0.5})
obstaculo.myName="obstaculos"

-- Exibe pontuação
local function novoTexto()
  textScore = display.newText("Score: "..score, 240,-40, nil, 12)
  textScore:setTextColor(255,255,255)
end
local function updateTexto()
  textScore.text = "Score: "..score
end

-- carrega obstaculos em diferentes posições no jogo
local function loadObstaculos()
	numObstaculos = numObstaculos + 1
	obstaculos[numObstaculos] = display.newImage("obs.png")
	fisica.addBody (obstaculos[numObstaculos], "static",{bounce = 0.3,friction=0.5})
    local whereFrom = math.random(3)  --determinar a direção do asteróide irá aparecer
	obstaculos[numObstaculos].myName = "obstaculos"
     -- condições para os obstaculos carregarem  no jogo
     if (whereFrom == 1) then
	   w = math.random(45,120)
	   obstaculos[numObstaculos].x = w
       obstaculos[numObstaculos].y = 480
	   transition.to(obstaculos[numObstaculos],{x= w,y=0, time = tempo, onComplete = some})
     elseif (whereFrom == 2) then
	   w = math.random(157,200)
	   obstaculos[numObstaculos].x = w
       obstaculos[numObstaculos].y = 480
       transition.to(obstaculos[numObstaculos],{x= w,y=0, time = tempo, onComplete = some})
	   elseif (whereFrom == 3) then
	    w = math.random(200, 280)
	    obstaculos[numObstaculos].x = w
        obstaculos[numObstaculos].y = 480
        transition.to(obstaculos[numObstaculos],{x= w,y=0, time = tempo, onComplete = some})
     end
end


-- função pontuação
local function colisao(event)
     if((event.object1.myName=="obstaculos" and event.object2.myName=="bola")
	   or(event.object1.myName=="bola" and event.object2.myName=="obstaculos"))then
         score=score+100
		 updateTexto()
	  end
	  if((event.object1.myName=="topo" and event.object2.myName=="bola")
		or(event.object1.myName=="bola" and event.object2.myName=="topo"))then
          --event.object1:removeSelf()
          --event.object1.myName=nil


		  local lose = display.newText("GAME OVER!!", 30, 150, nil, 36)
           lose:setTextColor(255,255,255)
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

-- movimenta o personagem
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
   if score > 1000 then
	   tempo = 6000
       print("ok")
	end
	if score > 3000 then
       tempo = 5000
	 end
	if score > 5000 then
	   tempo = 4000
	 end
    --[[elseif score> 10000 and tick > 250 then
       tick = 250
    elseif score > 15000 and tick > 200 then
       tick = 200
    elseif score > 20000 and tick > 150 then
       tick = 150
    elseif score > 25000 and tick > 100 then
       tick = 100
    end]]
end
novoTexto()
-- chama em tempo de execução o metodo colisao, especificando que é uma colisão entre dois objetos
Runtime:addEventListener("collision", colisao)
-- metodo que define o delay para surgimento dos obstaculos
timer.performWithDelay(tick,loop ,0)

