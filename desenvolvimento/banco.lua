module(..., package.seeall)
sqlite = require ( "sqlite3" )
local pontos
function criarBd()
   path = system.pathForFile("banco.db", system.DocumentsDirectory)
   db = sqlite.open( path )
   db:exec( "CREATE TABLE IF NOT EXISTS tabela (id INTEGER PRIMARY KEY, score INTEGER);" )
   print("O banco foi criado")
end

function insere(score)
   insert = "INSERT INTO tabela VALUES (NULL, '" .. score .. "' );" -- Concatena o parametro "score" na variavel "insert"
   db:exec( insert ) -- Executa a inserção no banco
   print("inserido")
end

function atualiza(score)
   update = "UPDATE tabela SET score = '"..score.."' WHERE ID = 1;"
   db:exec(update)
   print("atualizado")
end

function lista()
   local point
   for row in db:nrows("SELECT score FROM tabela WHERE ID = 1;") do
    --txId   = display.newText(row.id .. " - ", 10, 30 * row.id, native.systemFont, 18) -- Texto que mostra o "id"
	--txNome = display.newText(row.score, 34, 30 , native.systemFont, 18) -- Texto que mostra o "nome"
	point = row.score
   end
   return point
end

function fecharBd()
    db:exec( "DROP TABLE tabela;")
	--db:close()

	print("tabela desfeita")
end

function setScore(pontos)
    score = pontos
end

function getScore()
    return score
end

function onSystemEvent( event )
	if( event.type == "applicationExit" ) then
	  db:close()
	end
	print("banco fechou")
end

Runtime:addEventListener( "system", onSystemEvent )
