local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require "widget"
local banco = require("banco")

local playBtn,label1,label2, pontos,textoPoint,theBest,
       grade,font,opcoes
local w = display.contentWidth
local h = display.contentHeight

local function chamarMenu()
    storyboard.gotoScene( "menu", "slideRight", 500 )
    return true
end

function scene:createScene( event )
  local group = self.view

  if "Win" == system.getInfo( "platformName" ) then
    font = "Varela Round"
  else
    font = "VarelaRound-Regular"
  end

  theBest = display.newImage("imagens/theBest.png")
  theBest:setReferencePoint( display.CenterReferencePoint )
  theBest.x,theBest.y = w/2, h - 400                         --newText( "THE BEST", w*0.27, h - 300, font, 30 )
  group:insert(theBest)

  pontos = banco.lista()
  textoPoint = display.newText(pontos, w*0.36, h - 300 , font, 30)

  playBtn = widget.newButton{
		label="BACK",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=154, height=40,
		onRelease = chamarMenu	-- função de ouvinte de evento
  }
  playBtn:setReferencePoint( display.CenterReferencePoint )
  playBtn.x = w*0.5
  playBtn.y = h - 100

  group:insert(playBtn)
  group:insert(textoPoint)
end

function scene:enterScene( event )
   storyboard.purgeScene("gameOver")
end


function scene:exitScene( event )

	local group = self.view
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
