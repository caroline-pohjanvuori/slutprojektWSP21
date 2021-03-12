require 'slim'
require 'sinatra'
enable :sessions
require 'sqlite3'
require 'bcrypt'

enable :sessions

def connect_to_db(path)
  db = SQLite3::Database.new(path)
  db.results_as_hash = true
  return db
 end
 

get('/') do
  slim(:"/index")
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

get('/task/tasklist') do
  db = connect_to_db('db/promodoro.db')
  id = session[:id].to_i
  result = db.execute("SELECT * FROM tasks WHERE userid = ?", id)
  p "alla results fran #{result}"
  slim(:"/tasklist", locals:{tasks:result})
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

post('/tasklist') do
  newTask = params[:task]
  description= params[:description]
  user_id = session[:id]
  db=SQLite3::Database.new('db/promodoro.db') 
  db.execute("INSERT INTO tasks (taskname, description, userid) VALUES (?, ?, ?)", newTask, description, user_id)
  redirect('/tasks') 
end


get('/taskList/:id/edit') do
  id = params[:id].to_i
  db=SQLite3::Database.new('db/promodoro.db') 
  db.results_as_hash = true
  result = db.execute("SELECT * FROM tasks WHERE id = ?", id).first
  slim(:"/tasks/edit", locals:{result:result})
end

post('/taskList/:id/update') do
  content= params[:updatedTask]
  content= params[:updateddesc]
  id=params[:id].to_i
  db=SQLite3::Database.new('db/promodoro.db') 
  db.execute("UPDATE tasks SET taskcontent = ? WHERE id = ?", content, id)
  redirect('/tasks')
end


post('/taskList/:id/delete') do
  id= params[:id].to_i
  db=SQLite3::Database.new('db/promodoro.db') 
  db.execute("DELETE FROM tasks WHERE id = ?", id)
  redirect('/tasks')
end

