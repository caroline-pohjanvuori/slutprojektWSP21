require 'slim'
require 'sinatra'
enable :sessions
require 'sqlite3'
require 'bcrypt'

enable :sessions

def connect_to_db(path)
  #funk för att effektivare connecta till db
  db = SQLite3::Database.new(path)
  db.results_as_hash = true
  return db
 end
 

get('/') do
  slim(:"/index")
end

get('/showregister') do
  slim(:"/register")
end

post('/users/new')do
  #nya användare
  username= params[:username]
  password=params[:password]
  password_comfirm=params[:password_comfirm]

  if (password_comfirm == password)
    #lägg till användare
    password_digest= BCrypt::Password.create(password)
    db = connect_to_db('db/promodoro.db') 
    db.execute("INSERT INTO user (username, pwdigest) VALUES (?,?)", username, password_digest)
    redirect('/') 
  else
    #error
    "Lösenordet matchade ej"
  end
end
get('/showlogin') do
  #mellansteg till login
  slim(:login)
end

post('/login') do
  #login för gamla användare
  username= params[:username]
  password=params[:password]
  db = connect_to_db('db/promodoro.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM user WHERE username = ?", username).first
  pwdigest= result["pwdigest"]
  id= result["id"]

  if BCrypt::Password.new(pwdigest) == password
    session[:id] = id
    redirect('/')
  else
    #error
    "lösenordet matchade ej"
  end
end

get('/tasklist') do
  #tar upp tasks
  db = connect_to_db('db/promodoro.db')
  id = session[:id].to_i
  result = db.execute("SELECT * FROM tasks WHERE userid = ?", id)
  slim(:"task/tasklist", locals:{tasks:result})
end


post('/tasklist') do
  #skapar nya tasks
  newTask = params[:task]
  description= params[:description]
  taskcolor = params[:col].to_i
  user_id = session[:id]
  db = connect_to_db('db/promodoro.db')
  db.execute("INSERT INTO tasks (taskname, description, userid) VALUES (?, ?, ?)", newTask, description, user_id)
  result = db.execute("SELECT id FROM tasks WHERE taskname=? AND userId=? ", newTask, user_id).first
  id = result["id"].to_i
  db.execute("INSERT INTO taskcolor (taskid, colorid) VALUES (?, ?)", id, taskcolor)
  redirect('/tasklist') 
end


get('/tasklist/:id/edit') do
  #första steg för att edita tasks. Det som händer när du trycker på knappen
  id = params[:id].to_i
  db = connect_to_db('db/promodoro.db') 
  db.results_as_hash = true
  result = db.execute("SELECT * FROM tasks WHERE id = ?", id).first
  slim(:"/task/edit", locals:{update:result})
end

post('/taskList/:id/update') do
  #andra steget för att edita tasks. Det som händer när du har skrivit in uppdateringarna
  taskname= params[:updatedtask]
  description = params[:updateddesc]
  color = params[:col].to_i
  id=params[:id].to_i
  db = connect_to_db('db/promodoro.db') 
  db.execute("UPDATE tasks SET taskname = ?, description = ?  WHERE id = ?", taskname, description, id)
  db.execute("UPDATE taskcolor SET colorid = ? WHERE taskid = ?", color, id)
  redirect('/tasklist')
end


post('/tasklist/:id/delete') do
  #radera tasks
  id= params[:id].to_i
  db = connect_to_db('db/promodoro.db') 
  db.execute("DELETE FROM tasks WHERE id = ?", id)
  db.execute("DELETE FROM taskcolor WHERE taskid = ?", id)
  redirect('/tasklist')
end

