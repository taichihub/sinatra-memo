# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'webrick'

set :server, 'webrick'
set :notes_file, 'notes.json'

helpers do
  def load_notes
    File.exist?(settings.notes_file) ? JSON.parse(File.read(settings.notes_file)) : []
  end

  def save_notes(notes)
    File.write(settings.notes_file, notes.to_json)
  end

  def escape_html(text)
    Rack::Utils.escape_html(text)
  end
end

before do
  @notes = load_notes
end

# トップ画面
get '/' do
  erb :index
end

# メモ作成画面
get '/notes/new' do
  erb :new
end

# メモ詳細画面
get '/notes/:id' do
  @note = @notes.find { |n| n['id'] == params[:id].to_i }
  halt 404, 'Note not found' unless @note
  erb :show
end

# メモ編集画面
get '/notes/:id/edit' do
  @note = @notes.find { |n| n['id'] == params[:id].to_i }
  halt 404, 'Note not found' unless @note
  erb :edit
end

# メモ作成
post '/notes' do
  new_id = @notes.empty? ? 1 : @notes.last['id'] + 1
  new_note = { 'id' => new_id, 'title' => params[:title], 'content' => params[:content] }
  @notes << new_note
  save_notes(@notes)
  redirect '/'
end

# メモ更新
patch '/notes/:id' do
  note = @notes.find { |n| n['id'] == params[:id].to_i }
  halt 404, 'Note not found' unless note
  note['title'] = params[:title]
  note['content'] = params[:content]
  save_notes(@notes)
  redirect "/notes/#{params[:id]}"
end

# メモ削除
delete '/notes/:id' do
  @notes.reject! { |n| n['id'] == params[:id].to_i }
  save_notes(@notes)
  redirect '/'
end
