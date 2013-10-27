local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"
-- declarações para a frente e outros locais
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
		onRelease = menu	-- função de ouvinte de evento
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
  -- Chamado imediatamente após a cena mudou na tela:
function scene:enterScene( event )
	local group = self.view

	-- Inserir o código aqui (por exemplo, contadores de início, áudio carga, ouvintes de início, etc)
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


