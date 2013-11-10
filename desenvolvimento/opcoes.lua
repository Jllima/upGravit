local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require "widget"
local playBtn,label1

local function chamarMenu()
    storyboard.gotoScene( "menu", "crossFade", 500 )
    return true
end

function scene:createScene( event )
  local group = self.view

  label1 = display.newText( "Opcoes", 20, 30, native.systemFontBold, 20 )
  label1:setTextColor( 190, 190, 255 )
  group:insert(label1)

  playBtn = widget.newButton{
		label="menu",
		labelColor = { default={255}, over={128} },
		defaultFile="imagens/button.png",
		overFile="imagens/button-over.png",
		width=154, height=40,
		onRelease = chamarMenu	-- função de ouvinte de evento
  }
  playBtn:setReferencePoint( display.CenterReferencePoint )
  playBtn.x = display.contentWidth*0.5
  playBtn.y = display.contentHeight - 125

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
