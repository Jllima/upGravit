local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"
-- declara��es para a frente e outros locais
local playBtn

local function menu()

	-- ir para cena level1.lua

	storyboard.gotoScene("menu")

	return true	-- indica toque bem sucedida
end

function scene:createScene( event )
  function gameOver()
     local group = display.newGroup()
    local fundoGameOver = display.newImage("imagens/gameOver.png")
    playBtn = widget.newButton{
		label="Jogar",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=154, height=40,
		onRelease = menu	-- fun��o de ouvinte de evento
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125

	group:insert(fundoGameOver)
	group:insert( playBtn )
    print("ok")
	return true	-- indica toque bem sucedida
  end
  gameOver()

end
  -- Chamado imediatamente ap�s a cena mudou na tela:
function scene:enterScene( event )
	local group = self.view

	-- Inserir o c�digo aqui (por exemplo, contadores de in�cio, �udio carga, ouvintes de in�cio, etc)
end

  -- Chamado quando a cena est� prestes a se mover fora da tela:
function scene:exitScene( event )
	local group = self.view

	-- Chamado quando a cena est� prestes a se mover fora da tela:

end

  -- Se a vis�o de cena � removido, a cena: destroyScene () ser� chamado pouco antes:
function scene:destroyScene( event )
	local group = self.view

	if playBtn then
		playBtn:removeSelf()	-- widgets de devem ser removidos manualmente
		playBtn = nil
	end
end

-----------------------------------------------------------------------------------------
-- FIM DA SUA IMPLEMENTA��O
-----------------------------------------------------------------------------------------

-- evento "createScene" � despachado se a vis�o de cena n�o existe
scene:addEventListener( "createScene", scene )

-- evento "enterScene" � despachado sempre que transi��o de cena terminou
scene:addEventListener( "enterScene", scene )

-- evento "exitScene" � despachado sempre que antes da transi��o da cena seguinte come�a
scene:addEventListener( "exitScene", scene )

-- Evento "destroyScene" � despachado antes vista � descarregado, o que pode ser
-- Descarregadas automaticamente em situa��es de pouca mem�ria, ou explicitamente, atrav�s de uma chamada para
-- Storyboard.purgeScene () ou storyboard.removeScene ().
scene:addEventListener( "destroyScene", scene )

return scene


