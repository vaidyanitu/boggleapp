# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require "#{Rails.root}/lib/boardgame.rb"

run Rails.application
