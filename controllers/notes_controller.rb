# frozen_string_literal: true

require './models/note'

get '/' do
  @notes = Note.all
  erb :index
end

get '/notes/new' do
  erb :new
end

get '/notes/:id' do
  @note = Note.find(params[:id])
  erb :show
end

get '/notes/:id/edit' do
  @note = Note.find(params[:id])
  erb :edit
end

post '/notes' do
  new_id = Note.create(params)
  redirect "/notes/#{new_id}"
end

patch '/notes/:id' do
  Note.update(params[:id], params)
  redirect "/notes/#{params[:id]}"
end

delete '/notes/:id' do
  Note.delete(params[:id])
  redirect '/'
end
