require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/students.db")

#define the model


class Student
  include DataMapper::Resource
  property :id, Serial
  property :firstname, String
  property :lastname, String
  property :studentid, String
  property :birthday , Date
  property :address, String
end
DataMapper.finalize
DataMapper.auto_upgrade!

configure do
  enable :sessions
  set :username, "username"
  set :password, "password"
end

get '/students/new' do
  @newStudent = Student.new
  erb :new_student_page
end

put '/students/:id' do
  student = Student.get(params[:id])
  student.update(params[:student])
  erb :home
end

get '/students/:id/edit' do
  @student = Student.get(params[:id])
   if (Student.get(params[:id]) == nil)
      "Made it "
   else
      erb :edit_student_page
   end
end

get '/students/:id' do

  @showStudent = Student.get(params[:id])
  if (Student.get(params[:id]) == nil)
     "This Student Does Not Exist"
  else
    erb :show_student_page
  end
end



get '/students' do
  @students2 = Student.all
  if session[:admin]
    erb :students
  else
    erb :login
  end
end

post '/students' do
  if session[:admin]
    student = Student.create(params[:student])
    redirect to('/students')
  else
    erb :login
  end
end



delete '/students/:id' do
  if session[:admin]
    Student.get(params[:id]).destroy
    redirect to('/students')
  else
    erb :login
  end
end
