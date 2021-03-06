---------------------------------------------------------------------------------
--
-- upGravit
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local sprite = require("sprite")
local banco = require("banco")
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local   fisica = require("physics")
fisica.start(); fisica.pause()

--fisica.setDrawMode("hybrid")
-- Carregar variaveis
local fundo,textScore,memTimer,bola,speed,obstaculos,obstaculos2,numObstaculos,numObstaculos2,score,pontos,
       obstaculo,w,tempo,setaEsq,setaDir,nuvem,nuvem2,nuvem3,sheet1,spriteSet1,cont,cont2,font

somDeImpacto = audio.loadSound("sounds/impacto.wav")
somDeGameOver = audio.loadSound("sounds/destructe.wav")
local wx = display.contentWidth
local h = display.contentHeight

-- fun��o para game over
local function gameOver()
	--if event.phase == "began" then
    storyboard.gotoScene( "gameOver", "crossFade", 600 )--"gameOver"
    return true
	--end
end

local function carregaPersonagem()
    sheet1 = graphics.newImageSheet( "imagens/sprites2.png", { width=35, height=35, numFrames=3})
    bola = display.newSprite(sheet1,{name="man", start=1, count=3, time=300,loopCount=1} )
	bola.x = wx/2
	bola.y = 0
    fisica.addBody(bola, {bounce=0.6, friction=0.1,radius = 20})
	bola.isFixedRotation = true
    bola.myName="bola"
	return bola
end

local function fistObs(tempo)
    obstaculo = display.newImage("imagens/obs.png")
    obstaculo.x = wx/2
    obstaculo.y = h - 40
	fisica.addBody (obstaculo, "static",{bounce = 0.6,friction=0.1})
    obstaculo.myName="obstaculos"
	transition.to(obstaculo,{x= 157,y=-60, time = tempo,onComplete = some2})
	return obstaculo
end

--atualizar o escores na tela
local function updateTexto()
    textScore.text = "Score: "..score
end
-- fazer os obdtaculos sumirem
local function some2(self)
    self.alpha = 0
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
       obstaculos[numObstaculos].y = h - 40
	   transition.to(obstaculos[numObstaculos],{x= w,y=-60, time = tempo,onComplete = some2})--onComplete = some--cosumindo memoria
     elseif (whereFrom == 2) then
	   w = math.random(157,200)
	   obstaculos[numObstaculos].x = w
       obstaculos[numObstaculos].y = h - 40
       transition.to(obstaculos[numObstaculos],{x= w,y=-60, time = tempo,onComplete = some2})
	   elseif (whereFrom == 3) then
	    w = math.random(200, 280)
	    obstaculos[numObstaculos].x = w
        obstaculos[numObstaculos].y = h - 40
        transition.to(obstaculos[numObstaculos],{x= w,y=-60, time = tempo,onComplete = some2})
     end
end

local function loadObstaculos2()
    -- trocar newImage por newImageRect, possiblita redenrizar o tamanho de imagen de acordo com dispositivo(altera��o)
	numObstaculos2 = numObstaculos2 + 1
	obstaculos2[numObstaculos2] = display.newImage("imagens/obs2.png")
	fisica.addBody(obstaculos2[numObstaculos2], "static",{bounce = 0.6,friction=0.1})
    local whereFrom = math.random(3)  --determinar a dire��o do aster�ide ir� aparecer
	obstaculos2[numObstaculos2].myName = "obstaculos2"
     -- condi��es para os obstaculos carregarem  no jogo
     if (whereFrom == 1) then
	   w = math.random(45,120)
	   obstaculos2[numObstaculos2].x = w
       obstaculos2[numObstaculos2].y = h - 40
	   transition.to(obstaculos2[numObstaculos2],{x= w,y=-60, time = tempo,onComplete = some2})--onComplete = some--cosumindo memoria
     elseif (whereFrom == 2) then
	   w = math.random(157,200)
	   obstaculos2[numObstaculos2].x = w
       obstaculos2[numObstaculos2].y = h - 40
       transition.to(obstaculos2[numObstaculos2],{x= w,y=-60, time = tempo,onComplete = some2})
	   elseif (whereFrom == 3) then
	    w = math.random(200, 280)
	    obstaculos2[numObstaculos2].x = w
        obstaculos2[numObstaculos2].y = h - 40
        transition.to(obstaculos2[numObstaculos2],{x= w,y=-60, time = tempo,onComplete = some2})
     end
end

-- fun��o pontua��o
local function colisao(event)
     if(event.phase == "began")then
	     audio.play(somDeImpacto)-- chamar o som pre carregado
		 --bola:prepare("walk")
		 bola:play()
         score=score+50
		 updateTexto()
	 end
end
-- fun��o para game over
local function  colisao2(event)
   if((event.object1.myName=="parede" and event.object2.myName=="bola")
		or(event.object1.myName=="bola" and event.object2.myName=="parede"))then
		  audio.play(somDeGameOver)
          event.object1.myName=nil
		  if(score > pontos)then
	        banco.atualiza(score)
	      end
		  banco.setScore(score)
	      gameOver()
	elseif((event.object1.myName=="obstaculos2" and event.object2.myName=="bola")
		or(event.object1.myName=="bola" and event.object2.myName=="obstaculos2"))then
		  audio.play(somDeGameOver)
		  if(score > pontos)then
	        banco.atualiza(score)
	      end
		  banco.setScore(score)
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
-- fun��es que deslocam o presonagem
local function movimentaBolaD(self,event)
    if self.x < 0 then
	    self.x = 320
	end
	if self.x > 320 then
	    self.x = 0
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	--print("Estou createScene upGravit")
    local screenGroup = self.view

	if "Win" == system.getInfo( "platformName" ) then
      font = "Varela Round"
    else
      font = "VarelaRound-Regular"
    end

	fundo = display.newImage("imagens/fundo.png")
	fundo.x = wx/ 2
	fundo.y = h/2
    screenGroup:insert( fundo)

	score = 0

    textScore = display.newText("Score: "..score, wx*0.6,h - 560, font, 23)
    textScore:setTextColor(0,0,255)
	screenGroup:insert( textScore )
	-- direcional esquerdo
    setaEsq = display.newImage("imagens/seta.png")
    setaEsq.x = 45; setaEsq.y = 530;
    setaEsq.rotation = 180;
	screenGroup:insert(setaEsq)
    -- direcional direito
    setaDir = display.newImage("imagens/seta.png")
    setaDir.x = 280; setaDir.y = 532;
	screenGroup:insert(setaDir)

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
  fisica.setGravity(0, 20.0)
  pontos = banco.lista()
  --variaveis de movimenta��o
  motionx = 0 -- orienta��o para o direcional
  speed = 4  -- velocidade do movimento do personagem
  obstaculos = {}  --array de obstaculos
  obstaculos2 = {}  --array de obstaculos
  numObstaculos = 0 -- variavel para contagem de obstaculos
  numObstaculos2 = 0 -- variavel para contagem de obstaculos
  tick = 1200 -- medida de tempo para cada obstaculo aparece
  w = 0 -- guarda a posi��o x
  tempo = 7000 -- guarda o tempo utilizado no transation

  -- fun��o para parada do personagem
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
   if(cont == cont2)then
     loadObstaculos2()
   else
     loadObstaculos()
   end

   if score < 3000 then
       cont = math.random(5)
       cont2 = math.random(7)
    elseif(score > 3000 and score <= 5000) then
       cont = math.random(5)
       cont2 = math.random(7)
	   tick = 1100
	   tempo = 6000
    elseif(score > 5000 and score <= 7000) then
       cont = math.random(5)
       cont2 = math.random(5)
	   tick = 700
	   tempo = 5500
    elseif(score > 7000 and score <= 10000) then
	   cont = math.random(4)
       cont2 = math.random(4)
	   tick = 400
	   tempo = 5000
    elseif(score > 10000 and score <= 11000)then
	   cont = math.random(4)
       cont2 = math.random(4)
	   tick = 300
	   tempo = 4500
	elseif(score > 11000 and score <= 15000) then
	   cont = math.random(3)
       cont2 = math.random(3)
	   tick = 200
	   tempo = 4000
     elseif(score > 15000 )then
	   cont = math.random(3)
       cont2 = math.random(3)
	   tick = 100
     end
  end

  carregaPersonagem()
  fistObs(tempo)
  -- chama em tempo de execu��o a fun��o para movimenta��o das nuvens
  nuvem.enterFrame = movimentaNuvem
  Runtime:addEventListener("enterFrame", nuvem)
  nuvem2.enterFrame = movimentaNuvem
  Runtime:addEventListener("enterFrame", nuvem2)
  nuvem3.enterFrame = movimentaNuvem
  Runtime:addEventListener("enterFrame", nuvem3)
  bola.enterFrame = movimentaBolaD
  Runtime:addEventListener("enterFrame", bola)
  -- chama em tempo de execu��o o metodo colisao, especificando que � uma colis�o entre dois objetos
  Runtime:addEventListener("collision", colisao)
  Runtime:addEventListener("collision", colisao2)
  -- metodo que define o delay para surgimento dos obstaculos
  memTimer = timer.performWithDelay(tick,loop ,0)

end


-- Called when scene is about to move offscreen:
function scene:exitScene(event)
	--print("Estou existScene upGravit")
     local group = self.view
	 Runtime:removeEventListener("touch", stop )
	 Runtime:removeEventListener("enterFrame", bola)
	 Runtime:removeEventListener("enterFrame", moveBola)
	 Runtime:removeEventListener("enterFrame", nuvem)
	 Runtime:removeEventListener("enterFrame", nuvem2)
	 Runtime:removeEventListener("enterFrame", nuvem3)
	 Runtime:removeEventListener("collision", colisao)
     Runtime:removeEventListener("collision", colisao2)
	 bola:removeSelf()
	 obstaculo:removeSelf()
     --fisica.stop()
	 timer.cancel( memTimer ); memTimer = nil;
     -- limpar memoria
	 for i=1,table.getn(obstaculos) do
	   if(obstaculos[i].myName~= nil) then
         obstaculos[i]:removeSelf()
         obstaculos[i].myName=nil
	   end
	 end
	 for i=1,table.getn(obstaculos2) do
	   if(obstaculos2[i].myName~= nil) then
         obstaculos2[i]:removeSelf()
         obstaculos2[i].myName=nil
	   end
	 end

end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )


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
