-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- ocultar a barra de status
display.setStatusBar( display.HiddenStatusBar )

-- incluir o módulo Corona "storyboard"
local storyboard = require "storyboard"
local banco = require("banco")

-- tela do menu de carga

storyboard.gotoScene( "menu")
banco.criarBd()
