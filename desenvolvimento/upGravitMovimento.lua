---------------------------------------------------------------------------------
--
-- upGravit
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local sprite = require("sprite")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local   fisica = require("physics")
fisica.start(); fisica.pause()
fisica.setGravity(0, 9.0)
--fisica.setDrawMode("hybrid")
local isSimulator = "simulator" == system.getInfo("environment")

-- Carregar variaveis
local fundo,textScore,memTimer,bola,speed,obstaculos,numObstaculos,
obstaculo,tick,w,tempo,score,setaEsq,setaDir,nuvem,nuvem2,nuvem3,sheet1,spriteSet1

somDeImpacto = audio.loadSound("sounds/impacto.wav")
somDeGameOver = audio.loadSound("sounds/destructe.wav")
local masterVolume = audio.getVolume(somDeImpacto)


-- fun��o para game over
function gameOver()
	--if event.phase == "began" then

		storyboard.gotoScene( "gameOver", "crossFade", 400 )--"gameOver"

		return true
	--end
end
-- fun��o para carregar o personagem
local function carregaPersonagem()
    sheet1 = graphics.newImageSheet( "imagens/sprites2.png", { width=35, height=35, numFrames=3})
    bola = display.newSprite(sheet1,{name="man", start=1, count=3, time=500,loopCount=1} )
	bola.x = display.contentWidth/2
	bola.y = 0
    fisica.addBody(bola, {bounce=0.6, friction=0.1,radius = 20})
	bola.isFixedRotation = true
    bola.myName="bola"
end
-- atualizar o escores na tela
local function updateTexto()
    textScore.text = "Score: "..score
end
-- fazer os obdtaculos sumirem
function some2(self)
    self.alpha = 0
  end

--primeiro obstaculo para impedir que a bola caia no inicio do jogo
local function fistObs()
    obstaculo = display.newImage("imagens/obs.png")
    obstaculo.x = 157
    obstaculo.y = 530
    transition.to(obstaculo,{x= 157,y=-60, time = tempo,onComplete = some2})
	fisica.addBody (obstaculo, "static",{bounce = 0.6,friction=0.1})
    obstaculo.myName="obstaculos"
end

-- carrega obstaculos em diferentes posi��es no jogo
local function loadObstaculos()
    -- trocar newImage por newImageRect, possiblita redenrizar o tamanho de imagen de acordo com dispositivo(altera��o)
	numObstaculos = numObstaculos + 1
	obstaculos[numObstaculos] = display.newImage("imagens/obs.png")
	fisica.addBody (obstaculos[numObstaculos], "static",{bounce = 0.6,friction=0.1})
    local whereFrom = math.random(3)  --determinar a dire��o do aster�ide ir� aparecer
	obstaculos[numObstaculos].myName = "obstaculos"
     -- condi��es para os obstaculos carregarem  no jogo
     if (whereFrom == 1) then
	   w = math.random(45,120)
	   obstaculos[numObstaculos].x = w
       obstaculos[numObstaculos].y = 530
	   transition.to(obstaculos[numObstaculos],{x= w,y=-60, time = tempo,onComplete = some2})--onComplete = some--cosumindo memoria
     elseif (whereFrom == 2) then
	   w = math.random(157,200)
	   obstaculos[numObstaculos].x = w
       obstaculos[numObstaculos].y = 530
       transition.to(obstaculos[numObstaculos],{x= w,y=-60, time = tempo,onComplete = some2})
	   elseif (whereFrom == 3) then
	    w = math.random(200, 280)
	    obstaculos[numObstaculos].x = w
        obstaculos[numObstaculos].y = 530
        transition.to(obstaculos[numObstaculos],{x= w,y=-60, time = tempo,onComplete = some2})
     end
end

-- fun��o pontua��o
local function colisao(event)
     if(event.phase == "began")then
	     audio.play(somDeImpacto)-- chamar o som pre carregado
		 --bola:prepare("walk")
		 bola:play()
         score=score+100
		 updateTexto()
	 end
end
-- fun��o para game over
local function  colisao2(event)
   if((event.object1.myName=="parede" and event.object2.myName=="bola")
		or(event.object1.myName=="bola" and event.object2.myName=="parede"))then
		  audio.play(somDeGameOver)
          event.object1.myName=nil
		  gameOver()
	end
end
-- fun��o para movimenta��o das nuvens
local function movimentaNuvem(self,event)
    if self.x > 530 then
	    self.x = -30
	else
	   self.x = self.x + self.speed
	end
end
--[[
local function onAccelerate( event )

	-- Format and display the Accelerator values
	--
	xyzFormat( xg, event.xGravity)
	xyzFormat( yg, event.yGravity)
	xyzFormat( zg, event.zGravity)
	xyzFormat( xi, event.xInstant)
	xyzFormat( yi, event.yInstant)
	xyzFormat( zi, event.zInstant)

	frameUpdate = false		-- update done

	-- Move our object based on the accelerator values
	--
	bola.x = centerX + (centerX * event.xGravity)
	bola.y = centerY + (centerY * event.yGravity * -1)

end]]

-- Called when the scene's view does not exist:
function scene:createScene( event )
	--print("Estou createScene upGravit")
    local screenGroup = self.view

	fundo = display.newImage("imagens/fundo.png")
	fundo.x = display.contentWidth / 2
	fundo.y = display.contentHeight/2
    screenGroup:insert( fundo)

	score = 0
    textScore = display.newText("Score: "..score, 200,0, nil, 20)
    textScore:setTextColor(0,0,255)
	screenGroup:insert( textScore )
	--[[ direcional esquerdo
    setaEsq = display.newImage("imagens/seta.png")
    setaEsq.x = 45; setaEsq.y = 550;
    setaEsq.rotation = 180;
	screenGroup:insert(setaEsq)
    -- direcional direito
    setaDir = display.newImage("imagens/seta.png")
    setaDir.x = 280; setaDir.y = 552;
	screenGroup:insert(setaDir)
    ]]
	local parede = display.newRect(0,-40,display.contentWidth,1)
    fisica.addBody(parede,"static")
    parede.myName="parede"
    parede.alpha = 0
	screenGroup:insert(parede)
    local parede = display.newRect(0,570,display.contentWidth,1)
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

	nuvem = display.newImage("imagens/NUVEM3.png")
	nuvem:setReferencePoint(display.BottomRightReferencePoint)
	nuvem.x = -50
	nuvem.y = 200
	nuvem.speed = 0.2
	screenGroup:insert(nuvem)
	nuvem2 = display.newImage("imagens/NUVEM2.png")
	nuvem2:setReferencePoint(display.BottomRightReferencePoint)
	nuvem2.x = -10
	nuvem2.y = 350
	nuvem2.speed = 0.4
	screenGroup:insert(nuvem2)
	nuvem3 = display.newImage("imagens/NUVEM1.png")
	nuvem3:setReferencePoint(display.BottomRightReferencePoint)
	nuvem3.x = -30
	nuvem3.y = 500
	nuvem3.speed = 0.3
	screenGroup:insert(nuvem3)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  --print("Estou enterScene upGravit")
  storyboard.purgeScene("menu")
  fisica.start()

  --variaveis de movimenta��o
  motionx = 0
  speed = 3
  --array de obstaculos
  obstaculos = {}
  numObstaculos = 0 -- variavel para contagem de obstaculos
  tick = 1200--1500 -- medida de tempo para cada obstaculo aparece
  w = 0 -- guarda a posi��o x
  tempo = 7000 -- guarda o tempo utilizado no transation

  --[[ fun��o para parada do personagem
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
  ]]
   -- loop do jogo
  local function loop()
   loadObstaculos()
   if score > 3000 then
	   tempo = 6000
	   --media.playEventSound("sounds/nivel.wav")
    end
	if score > 5000 then
       tempo = 5000

	 end
	if score > 7000 then
	   tempo = 4000

	 end
	 if score > 10000 then
	   tempo = 3000
     end
	 if score > 11000 then
	   tempo = 2000
     end
    if score > 12000 then
	   tempo = 1000
     end
  end

  carregaPersonagem()
  fistObs()
  --Runtime:addEventListener ("accelerometer", onAccelerate);
  -- chama em tempo de execu��o a fun��o para movimenta��o das nuvens
  nuvem.enterFrame = movimentaNuvem
  Runtime:addEventListener("enterFrame", nuvem)
  nuvem2.enterFrame = movimentaNuvem
  Runtime:addEventListener("enterFrame", nuvem2)
  nuvem3.enterFrame = movimentaNuvem
  Runtime:addEventListener("enterFrame", nuvem3)
  -- chama em tempo de execu��o o metodo colisao, especificando que � uma colis�o entre dois objetos
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
	 --Runtime:removeEventListener("accelerometer", onAccelerate);
	 --Runtime:removeEventListener("touch", stop )
	 --Runtime:removeEventListener("enterFrame", moveBola)
	 Runtime:removeEventListener("enterFrame", nuvem)
	 Runtime:removeEventListener("enterFrame", nuvem2)
	 Runtime:removeEventListener("enterFrame", nuvem3)
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
-- fim da implementa��o
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
