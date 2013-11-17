-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local banco = require("banco")

-- incluem biblioteca de "widget" de Corona
local widget = require "widget"

--------------------------------------------

-- declarações para a frente e outros locais
local playBtn
opcao = 0


-- 'onRelease "ouvinte de eventos para playBtn
local function chamarUpGravit()
    if (opcao == 1 or opcao == 0) then
      storyboard.gotoScene( "upGravit", "crossFade", 500 )
	elseif(opcao == 2)then
	  storyboard.gotoScene( "upGravitMovimento", "crossFade", 500 )
	end
    return true	-- indica toque bem sucedida
end

local function chamarOpcoes()
    storyboard.gotoScene( "opcoes", "slideLeft", 500 )
    return true	-- indica toque bem sucedida
end



-----------------------------------------------------------------------------------------
-- INÍCIO DE SUA IMPLEMENTAÇÃO
--
-- NOTA: Código fora de funções de ouvinte (abaixo) só será executada uma vez,
-- A menos que storyboard.removeScene () é chamado.
--
-----------------------------------------------------------------------------------------

-- Chamado quando vista da cena não existe:
function scene:createScene( event )
	-- print("Estou createScene menu")

	local group = self.view

	-- exibir uma imagem de fundo
	local background = display.newImageRect( "imagens/fundo1.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0

	-- criar imagem do logotipo / título / posição sobre superior a metade da tela
	--[[local titleLogo = display.newImageRect( "imagens/logo.png", 264, 42 )
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100]]

	-- criar um botão widget (que carrega upGravit.lua em chamarUpGravit)
	playBtn = widget.newButton{
		label="Jogar",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=154, height=40,
		onRelease = chamarUpGravit	-- função de ouvinte de evento
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125

	-- criar um botão widget (que carrega upGravit.lua em chamarUpGravit)
	playBtn2 = widget.newButton{
		label="Opcoes",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=154, height=40,
		onRelease =chamarOpcoes	-- função de ouvinte de evento
	}
	playBtn2:setReferencePoint( display.CenterReferencePoint )
	playBtn2.x = display.contentWidth*0.5
	playBtn2.y = display.contentHeight - 70

	-- todos os objetos de exibição deve ser inserido no grupo
	group:insert( background )
	--group:insert( titleLogo )
	group:insert( playBtn )
	group:insert( playBtn2 )

end

-- Chamado imediatamente após a cena mudou na tela:
function scene:enterScene( event )
    --print("Estou enterScene menu")
	storyboard.purgeScene("gameOver")
	storyboard.purgeScene("opcoes")
	local group = self.view
	--banco.fecharBd()

	-- Inserir o código aqui (por exemplo, contadores de início, áudio carga, ouvintes de início, etc)

end

-- Chamado quando a cena está prestes a se mover fora da tela:
function scene:exitScene( event )
    --print("Estou exitScene menu")
	local group = self.view

	-- Chamado quando a cena está prestes a se mover fora da tela:

end

-- Se a visão de cena é removido, a cena: destroyScene () será chamado pouco antes:
function scene:destroyScene( event )
    --print("Estou destroyScene menu")
	local group = self.view

	if playBtn then
		playBtn:removeSelf()	-- widgets de devem ser removidos manualmente
		playBtn = nil
	end
	if playBtn2 then
		playBtn2:removeSelf()	-- widgets de devem ser removidos manualmente
		playBtn2 = nil
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

-----------------------------------------------------------------------------------------

return scene
