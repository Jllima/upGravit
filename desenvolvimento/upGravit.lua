---------------------------------------------------------------------------------
--
-- scene2.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local   fisica = require("physics")
fisica.start(); fisica.pause()
fisica.setGravity(0, 9.0)
--fisica.setDrawMode("hybrid")


local fundo,textScore,memTimer,bola,speed,obstaculos,numObstaculos,
	   obstaculo,tick,w,tempo,score,setaEsq,setaDir--,somDeImpacto,somDeGameOver
somDeImpacto = audio.loadSound("sounds/impacto.wav")
somDeGameOver = audio.loadSound("sounds/destructe.wav")
local masterVolume = audio.getVolume(somDeImpacto)



function gameOver()
	--if event.phase == "began" then

		storyboard.gotoScene( "gameOver", "crossFade", 400 )--"gameOver"

		return true
	--end
end

local function carregaPersonagem()
    bola = display.newImage("imagens/bola.png")
    bola.x = display.contentWidth/2
    bola.y = 0
    fisica.addBody(bola, {bounce=0.6, friction=0.1,radius = 20})
	bola.isFixedRotation = true
    bola.myName="bola"
end

local function updateTexto()
    textScore.text = "Score: "..score
end

function some2(self)
    self.alpha = 0
  end

--primeiro obstaculo para impedir que a bola caia no inicio do jogo
local function fistObs()
    obstaculo = display.newImage("imagens/obs.png")
    obstaculo.x = 157
    obstaculo.y = 480
    transition.to(obstaculo,{x= 157,y=-60, time = tempo,onComplete = some2})
	fisica.addBody (obstaculo, "static",{bounce = 0.6,friction=0.1})
    obstaculo.myName="obstaculos"
end

-- carrega obstaculos em diferentes posições no jogo
local function loadObstaculos()

    -- trocar newImage por newImageRect, possiblita redenrizar o tamanho de imagen de acordo com dispositivo(alteração)
	numObstaculos = numObstaculos + 1
	obstaculos[numObstaculos] = display.newImage("imagens/obs.png")
	fisica.addBody (obstaculos[numObstaculos], "static",{bounce = 0.6,friction=0.1})
    local whereFrom = math.random(3)  --determinar a direção do asteróide irá aparecer
	obstaculos[numObstaculos].myName = "obstaculos"
     -- condições para os obstaculos carregarem  no jogo
     if (whereFrom == 1) then
	   w = math.random(45,120)
	   obstaculos[numObstaculos].x = w
       obstaculos[numObstaculos].y = 480
	   transition.to(obstaculos[numObstaculos],{x= w,y=-60, time = tempo,onComplete = some2})--onComplete = some--cosumindo memoria

     elseif (whereFrom == 2) then
	   w = math.random(157,200)
	   obstaculos[numObstaculos].x = w
       obstaculos[numObstaculos].y = 480
       transition.to(obstaculos[numObstaculos],{x= w,y=-60, time = tempo,onComplete = some2})
	   elseif (whereFrom == 3) then
	    w = math.random(200, 280)
	    obstaculos[numObstaculos].x = w
        obstaculos[numObstaculos].y = 480
        transition.to(obstaculos[numObstaculos],{x= w,y=-60, time = tempo,onComplete = some2})
     end
end

-- função pontuação
local function colisao(event)
     if(event.phase == "began")then
	     audio.play(somDeImpacto)-- chamar o som pre carregado
         score=score+100
		 updateTexto()
	 end
end

local function  colisao2(event)
   if((event.object1.myName=="parede" and event.object2.myName=="bola")
		or(event.object1.myName=="bola" and event.object2.myName=="parede"))then
		  audio.play(somDeGameOver)
          event.object1.myName=nil
		  gameOver()
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	--print("Estou createScene upGravit")
    local screenGroup = self.view

	--[[fisica = require("physics")
    fisica.start(); fisica.pause()
    fisica.setGravity(0, 9.0)
    --fisica.setDrawMode("hybrid")]]

	fundo = display.newImage("imagens/fundo.png")
    fundo.y = display.contentHeight/2
    screenGroup:insert( fundo)

	score = 0
    textScore = display.newText("Score: "..score, 240,-40, nil, 12)
    textScore:setTextColor(255,255,255)
	screenGroup:insert( textScore )
	-- direcional esquerdo
    setaEsq = display.newImage("imagens/seta.png")
    setaEsq.x = 45; setaEsq.y = 500;
    setaEsq.rotation = 180;
	screenGroup:insert(setaEsq)
    -- direcional direito
    setaDir = display.newImage("imagens/seta.png")
    setaDir.x = 280; setaDir.y = 502;
	screenGroup:insert(setaDir)

	local parede = display.newRect(0,-40,display.contentWidth,1)
    fisica.addBody(parede,"static")
    parede.myName="parede"
    parede.alpha = 0
	screenGroup:insert(parede)
    local parede = display.newRect(0,510,display.contentWidth,1)
    fisica.addBody(parede,"static")
    parede.myName="parede"
    parede.alpha = 0
    screenGroup:insert(parede)
	local parede = display.newRect(-20,0,1,display.contentHeight)
    fisica.addBody(parede,"static")
    parede.myName="parede"
    parede.alpha = 0
	screenGroup:insert(parede)
    local parede = display.newRect(340,0,1,display.contentHeight)
    fisica.addBody(parede,"static")
    parede.myName="parede"
    parede.alpha = 0
    screenGroup:insert(parede)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    --print("Estou enterScene upGravit")
  storyboard.purgeScene("menu")
  fisica.start()
  motionx = 0
  speed = 2
  obstaculos = {}
  numObstaculos = 0 -- variavel para contagem de obstaculos
  tick = 1200--1500 -- medida de tempo para cada obstaculo aparece
  w = 0 -- guarda a posição x
  tempo = 7000 -- guarda o tempo utilizado no transation

  -- função para parada do personagem
  function stop (event)
	if event.phase =="ended" then
		motionx = 0;
	end
  end
  Runtime:addEventListener("touch", stop )

  -- movimenta o personagem
  function moveBola (event)
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
   if score > 5000 then
	   tempo = 6000
	   --media.playEventSound("sounds/nivel.wav")
    end
	if score > 8000 then
       tempo = 5000

	 end
	if score > 12000 then
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
  carregaPersonagem()
  fistObs()
  -- chama em tempo de execução o metodo colisao, especificando que é uma colisão entre dois objetos
  Runtime:addEventListener("collision", colisao)
  Runtime:addEventListener("collision", colisao2)
  -- metodo que define o delay para surgimento dos obstaculos
  memTimer = timer.performWithDelay(tick,loop ,0)

end


-- Called when scene is about to move offscreen:
function scene:exitScene(event)
	--print("Estou existScene upGravit")
	print(masterVolume)
	print( result )
     local group = self.view
     --fisica.stop()
	 Runtime:removeEventListener("touch", stop )
	 Runtime:removeEventListener("enterFrame", moveBola)
	 Runtime:removeEventListener("collision", colisao)
     Runtime:removeEventListener("collision", colisao2)
	 bola:removeSelf()
	 obstaculo:removeSelf()

	 timer.cancel( memTimer ); memTimer = nil;

	 --audio.dispose(somDeImpacto)
	 --audio.dispose(somDeGameOver)
	 --transition.cancel(transicao)

	 for i=1,table.getn(obstaculos) do
	   if(obstaculos[i].myName~= nil) then
         obstaculos[i]:removeSelf()
         obstaculos[i].myName=nil
	   end
	 end

end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )

	--[[print("Estou destroyScene upGravit")
	package.loaded[fisica] = nil
	fisica = nil]]
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene
