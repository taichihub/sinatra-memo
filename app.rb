# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require './config/environment'
require './controllers/notes_controller'

set :server, 'webrick'

not_found do
  'データが見つかりません'
end

error 500 do
  'サーバーエラーが発生しました'
end
