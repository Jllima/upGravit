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

storyboard.gotoScene("menu")
banco.criarBd()
local pontos = banco.lista()
if (pontos == nil )then
  banco.insere(0)
end
