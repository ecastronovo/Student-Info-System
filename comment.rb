require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/comments.db")

#define the model


class Comment
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :content, String
  property :created_at, DateTime
end
DataMapper.finalize
DataMapper.auto_upgrade!

get '/comments' do
  if session[:admin]
    @title = "Comments"
    @comments = Comment.all
    erb :comments
  else
    erb :login
  end
end

get '/comments/new' do
  @newComment = Comment.new
  erb :new_comment_page
end

get '/comments/:id' do
  @showComment = Comment.get(params[:id])
  if (Comment.get(params[:id]) == nil)
     "This Comment Does Not Exist"
  else
    erb :show_comment_page
  end
end

post '/comments' do
  comment = Comment.create(params[:comment])
  redirect to('/comments')
end
