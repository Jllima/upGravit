-----------------------------------------------------------------------------------------
-- main.lua
--medidas da tela 320X570
-----------------------------------------------------------------------------------------

-- Carrega uma splash screen externa(alteração)
--[[local splash = require("splash")
splash.splashBackground()]]

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
-- incluem biblioteca de "widget" de Corona
local widget = require "widget"

--------------------------------------------

-- declarações para a frente e outros locais
local playBtn

local function gameOver()
    storyboard.gotoScene("gameOver","fade", 500)
	return true
end

function scene:createScene( event )
  -- implementa a física
  local fisica = require("physics")
  fisica.start()
  fisica.setGravity(0, 8.0)
  --fisica.setDrawMode("hybrid")

  -- plano de fundo do jogo
  local fundo = display.newImage("imagens/fundo.png")
  fundo.y = display.contentHeight/2
  -- variaveis para o uso no código
  local motionx = 0
  local speed = 2
  local obstaculos = {}
  local numObstaculos = 0 -- variavel para contagem de obstaculos
  local tick = 1200--1500 -- medida de tempo para cada obstaculo aparece
  local w = 0 -- guarda a posição x
  local tempo = 7000 -- guarda o tempo utilizado no transation
  local score = 0 -- pontuação

  --Pre carregamento dos sons , para melhora de performance(alteração)
  somDeImpacto = audio.loadSound("sounds/impacto.wav")
  somDeGameOver = audio.loadSound("sounds/destructe.wav")

  --[[local function gameOver()
	 obstaculos.alpha = 0
    local fundoGameOver = display.newImage("imagens/gameOver.png")
    playBtn = widget.newButton{
		label="Jogar",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=154, height=40,
		onRelease = menu	-- função de ouvinte de evento
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125
    print("ok")
	-- ir para cena level1.lua
	--storyboard.gotoScene( "menu", "fade", 500 )

	return true	-- indica toque bem sucedida
  end
]]



  -- Exibe pontuação
  local function novoTexto()
    textScore = display.newText("Score: "..score, 240,-40, nil, 12)
    textScore:setTextColor(255,255,255)
  end
  local function updateTexto()
    textScore.text = "Score: "..score
  end

  -- carregar personagem

  local  bola = display.newImage("imagens/bola.png")
    bola.x = display.contentWidth/2
    bola.y = 0
    fisica.addBody(bola, {bounce=0.3, friction=0.5}) --radius=13
    bola.myName="bola"

  -- função utilizada no transation.to para retirar os obstaculos
  local function some (self)
   self:removeSelf()
  end

  -- primeiro obstaculo para impedir que a bola caia no inicio do jogo
  local obstaculo = display.newImage("imagens/obs.png")
    obstaculo.x = 157
    obstaculo.y = 480
    transition.to(obstaculo,{x= 157,y=0, time = 7000,onComplete = some})
    fisica.addBody (obstaculo, "static",{bounce = 0.3,friction=0.5})
    obstaculo.myName="obstaculos"

  --paredes do jogo
  local parede = display.newRect(0,-40,display.contentWidth,1)
    fisica.addBody(parede,"static")
    parede.myName="parede"
    parede.alpha = 0
  local parede = display.newRect(0,510,display.contentWidth,1)
    fisica.addBody(parede,"static")
    parede.myName="parede"
    parede.alpha = 0
  local parede = display.newRect(-20,0,1,display.contentHeight)
    fisica.addBody(parede,"static")
    parede.myName="parede"
    parede.alpha = 0
  local parede = display.newRect(340,0,1,display.contentHeight)
    fisica.addBody(parede,"static")
    parede.myName="parede"
    parede.alpha = 0

  -- carrega obstaculos em diferentes posições no jogo
  local function loadObstaculos()
    -- trocar newImage por newImageRect, possiblita redenrizar o tamanho de imagen de acordo com dispositivo(alteração)
	numObstaculos = numObstaculos + 1
	obstaculos[numObstaculos] = display.newImage("imagens/obs.png")
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

  -- função para parada do personagem
  local function stop (event)
	if event.phase =="ended" then
		motionx = 0;
	end
  end
  Runtime:addEventListener("touch", stop )

  -- direcional esquerdo
  local setaEsq = display.newImage("imagens/seta.png")
  setaEsq.x = 45; setaEsq.y = 500;
  setaEsq.rotation = 180;

  -- direcional direito
  local setaDir = display.newImage("imagens/seta.png")
  setaDir.x = 280; setaDir.y = 502;

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

  -- função pontuação
  local function colisao(event)
     if((event.object1.myName=="obstaculos" and event.object2.myName=="bola")
	   or(event.object1.myName=="bola" and event.object2.myName=="obstaculos"))then
	     audio.play(somDeImpacto) -- chamar o som pre carregado
		 --media.playEventSound("sounds/impacto.wav")
         score=score+100
		 updateTexto()
	  end
  end

  local function  colisao2(event)
   if((event.object1.myName=="parede" and event.object2.myName=="bola")
		or(event.object1.myName=="bola" and event.object2.myName=="parede"))then
		  audio.play(somDeGameOver)
		  --media.playEventSound("sounds/destructe.wav")
          --event.object1:removeSelf()
          event.object1.myName=nil
          bola.alpha = 0

		  local lose = display.newText("GAME OVER!!", 30, 150, nil, 36)
           lose:setTextColor(255,255,255)
		  gameOver()
	end
  end

  -- loop do jogo
  local function loop()
   loadObstaculos()
   if score > 2000 then
	   tempo = 6000
	   --media.playEventSound("sounds/nivel.wav")
    end
	if score > 5000 then
       tempo = 5000

	 end
	if score > 8000 then
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
  Runtime:addEventListener("collision", colisao2)
  -- metodo que define o delay para surgimento dos obstaculos
  timer.performWithDelay(tick,loop ,0)



end
  -- Chamado imediatamente após a cena mudou na tela:
function scene:enterScene( event )
	local group = self.view
	-- Inserir o código aqui (por exemplo, contadores de início, áudio carga, ouvintes de início, etc)
	--remover a visão de cena anterior
	storyboard.purgeScene("menu")
end

  -- Chamado quando a cena está prestes a se mover fora da tela:
function scene:exitScene( event )
	local group = self.view
    -- Chamado quando a cena está prestes a se mover fora da tela:

end

  -- Se a visão de cena é removido, a cena: destroyScene () será chamado pouco antes:
function scene:destroyScene( event )
	local group = self.view

	if playBtn then
		playBtn:removeSelf()	-- widgets de devem ser removidos manualmente
		playBtn = nil
	end
end

-----------------------------------------------------------------------------------------
-- FIM DA SUA IMPLEMENTAÇÃO
-----------------------------------------------------------------------------------------

-- evento "createScene" é despachado se a visão de cena não existe
scene:addEventListener( "createScene", scene )

-- evento "enterScene" é despachado sempre que transição de cena terminou
scene:addEventListener( "enterScene", scene )

-- evento "exitScene" é despachado sempre que antes da transição da cena seguinte começa
scene:addEventListener( "exitScene", scene )

-- Evento "destroyScene" é despachado antes vista é descarregado, o que pode ser
-- Descarregadas automaticamente em situações de pouca memória, ou explicitamente, através de uma chamada para
-- Storyboard.purgeScene () ou storyboard.removeScene ().
scene:addEventListener( "destroyScene", scene )

return scene

