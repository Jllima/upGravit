module(..., package.seeall)

--Include sqlite
  require "sqlite3"


function criarDB()

  --Open data.db.  If the file doesn't exist it will be created
  local path = system.pathForFile("data1.db", system.DocumentsDirectory)
  db = sqlite3.open( path )

  --Handle the applicationExit event to close the db
  local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then
            db:close()
        end
  end

  --Setup the table if it doesn't exist
  local tablesetup = [[CREATE TABLE IF NOT EXISTS jogador(id INTEGER PRIMARY KEY, content, content2);]]
  print(tablesetup)
  db:exec( tablesetup )

  --Add rows with a auto index in 'id'. You don't need to specify a set of values because we're populating all of them
  local testvalue = {}
  testvalue[1] = 'Hello'
  testvalue[2] = 'World'
  testvalue[3] = 'Lua'
  local tablefill =[[INSERT INTO test VALUES (NULL, ']]..testvalue[1]..[[',']]..testvalue[2]..[['); ]]
  local tablefill2 =[[INSERT INTO test VALUES (NULL, ']]..testvalue[2]..[[',']]..testvalue[1]..[['); ]]
  local tablefill3 =[[INSERT INTO test VALUES (NULL, ']]..testvalue[1]..[[',']]..testvalue[3]..[['); ]]
  db:exec( tablefill )
  db:exec( tablefill2 )
  db:exec( tablefill3 )

  --print the sqlite version to the terminal
  print( "version " .. sqlite3.version() )

  --print all the table contents
  for row in db:nrows("SELECT * FROM jogador") do
   local text = row.content.." "..row.content2
   local t = display.newText(text, 20, 120 + (20 * row.id), native.systemFont, 16)
   t:setTextColor(255,0,255)
  end

  --setup the system listener to catch applicationExit
  Runtime:addEventListener( "system", onSystemEvent )
end
