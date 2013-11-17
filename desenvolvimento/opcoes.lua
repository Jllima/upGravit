local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require "widget"
local banco = require("banco")

local playBtn,label1, touch, movimento,label2, pontos,textoPoint,theBest
local w = display.contentWidth
local h = display.contentHeight

local function chamarMenu()
    storyboard.gotoScene( "menu", "slideRight", 500 )
    return true
end

local function opcaoMovimento()
    opcao = 2
    storyboard.gotoScene( "menu", "slideRight", 500 )
    return true
end
local function opcaoThouch()
    opcao = 1
    storyboard.gotoScene( "menu", "slideRight", 500 )
    return true
end

function scene:createScene( event )
  local group = self.view

  theBest = display.newText( "Melhor pontuacao", w*0.2, h - 300, native.systemFontBold, 20 )
  group:insert(theBest)

  pontos = banco.lista()
  textoPoint = display.newText(pontos, w*0.5, h - 200 , native.systemFont, 18)


  label1 = display.newText( "Opcoes", 20, 30, native.systemFontBold, 20 )
  label1:setTextColor( 190, 190, 255 )
  group:insert(label1)

  label2 = display.newText( "Escolha o tipo de jogabilidade", 20, 100, native.systemFontBold, 20 )
  label2:setTextColor( 190, 190, 255 )
  group:insert(label2)

  playBtn = widget.newButton{
		label="voltar",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=154, height=40,
		onRelease = chamarMenu	-- função de ouvinte de evento
  }
  playBtn:setReferencePoint( display.CenterReferencePoint )
  playBtn.x = w*0.5
  playBtn.y = h - 125

  touch = widget.newButton{
		label="touch",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=110, height=40,
		onRelease = opcaoThouch	-- função de ouvinte de evento
  }
  touch:setReferencePoint( display.CenterReferencePoint )
  touch.x = w*0.3
  touch.y = h - 400

  movimento = widget.newButton{
		label="movimento",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=110, height=40,
		onRelease = opcaoMovimento	-- função de ouvinte de evento
  }
  movimento:setReferencePoint( display.CenterReferencePoint )
  movimento.x = w*0.7
  movimento.y = h - 400

  group:insert(playBtn)
  group:insert(touch)
  group:insert(movimento)
  group:insert(textoPoint)
end

function scene:enterScene( event )
   storyboard.purgeScene("gameOver")
end


function scene:exitScene( event )

	local group = self.view
	label1:removeSelf()
end


function scene:destroyScene( event )

	local group = self.view

	if playBtn then
		playBtn:removeSelf()
		playBtn = nil
	end
end


scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene
