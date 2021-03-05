require 'slim'
require 'sinatra'
enable :sessions
require 'sqlite3'
require 'bcrypt'

enable :sessions

get('/') do
  slim(:register)
end

#post('/users/new')do
 # username= params[:username]
  #password=params[:password]
  #password_comfirm=params[:password_comfirm]

  #if (password_comfirm == password)
    #lägg till användare
    #password_digest= BCrypt::Password.create(password)
    #db=SQLite3::Database.new('db/Todo2020.db') 
    #db.execute("INSERT INTO users (username, pwdigest) VALUES (?,?)", username, password_digest)
    #redirect('/') 
  #else
    ##error
    #"Lösenordet matchade ej"
  #end
#end

get('/tasks') do
  id = session[:id].to_i
  db=SQLite3::Database.new('db/Todo2020.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM todo WHERE user_id = ?", id)
  p "alla results fran #{result}"
  slim(:"/tasks", locals:{todos:result})
end

#get('/showlogin') do
 # slim(:login)
#end
#post('/login') do
 # username= params[:username]
  #password=params[:password]
  #db=SQLite3::Database.new('db/Todo2020.db') 
  #db.results_as_hash = true
  #result = db.execute("SELECT * FROM users WHERE username = ?", username).first
  #pwdigest= result["pwdigest"]
  #id= result["id"]

  #if BCrypt::Password.new(pwdigest) == password
    #session[:id] = id
    #redirect('/todos')
  #else
    ##error
    #"lösenordet matchade ej"
  #end
#end

post('/todo') do
  newTodo = params[:todo]
  user_id = session[:id]
  db=SQLite3::Database.new('db/Todo2020.db') 
  db.execute("INSERT INTO todo (content, user_id) VALUES (?,?)", newTodo, user_id)
  redirect('/todos') 
end


get('/todos/:id/edit') do
  id = params[:id].to_i
  db=SQLite3::Database.new('db/Todo2020.db') 
  db.results_as_hash = true
  result = db.execute("SELECT * FROM todo WHERE id = ?", id).first
  slim(:"/todos/edit", locals:{result:result})
end

post('/todos/:id/update') do
  content= params[:updatedTodo]
  id=params[:id].to_i
  db=SQLite3::Database.new('db/Todo2020.db') 
  db.execute("UPDATE todo SET content = ? WHERE id = ?", content, id)
  redirect('/todos')
end


post('/todos/:id/delete') do
  id= params[:id].to_i
  db=SQLite3::Database.new('db/Todo2020.db') 
  db.execute("DELETE FROM todo WHERE id = ?", id)
  redirect('/todos')
end

