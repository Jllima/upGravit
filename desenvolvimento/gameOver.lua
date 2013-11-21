local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local banco = require("banco")

local widget = require "widget"

local playBtn,fundoGameOver, pontos,textoPoint,textoPoint2,record
local w = display.contentWidth
local h = display.contentHeight

local function menu()

	-- ir para cena level1.lua

	storyboard.gotoScene("menu", "slideUp", 400)

	return true	-- indica toque bem sucedida
end

function scene:createScene( event )
  --print("Estou createScene gameOver")
    local group = self.view
	pontos = banco.getScore()
	record = banco.lista()
    textoPoint = display.newText("Pontos: "..pontos, w*0.3, h/2, native.systemFont, 25)
    textoPoint2 = display.newText("Record: "..record, w*0.3, h - 250, native.systemFont, 25)
    fundoGameOver = display.newImage("imagens/gameOver.png")
	fundoGameOver:setReferencePoint( display.TopLeftReferencePoint )
	fundoGameOver.x, fundoGameOver.y = 0,0
    playBtn = widget.newButton{
		label="iniciar",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=154, height=50,
		onRelease = menu	-- função de ouvinte de evento
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 140

	group:insert(fundoGameOver)
	group:insert( playBtn )
    group:insert(textoPoint)
	group:insert(textoPoint2)
	return true	-- indica toque bem sucedida

end
  -- Chamado imediatamente após a cena mudou na tela:
function scene:enterScene( event )
    --print("Estou enterScene gameOver")
	local group = self.view
	storyboard.purgeScene("upGravit")
	storyboard.purgeScene("upGravitMovimento")
	-- Inserir o código aqui (por exemplo, contadores de início, áudio carga, ouvintes de início, etc)
end

  -- Chamado quando a cena está prestes a se mover fora da tela:
function scene:exitScene( event )
    --print("Estou existeScene gameOver")
	local group = self.view
	-- Chamado quando a cena está prestes a se mover fora da tela:
end

  -- Se a visão de cena é removido, a cena: destroyScene () será chamado pouco antes:
function scene:destroyScene( event )
    --print("Estou destroyScene gameOver")
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


