-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- ocultar a barra de status
display.setStatusBar( display.HiddenStatusBar )

-- incluir o m�dulo Corona "storyboard"
local storyboard = require "storyboard"
local banco = require("banco")

-- tela do menu de carga

storyboard.gotoScene( "menu")
banco.criarBd()
