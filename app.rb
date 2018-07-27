require "sinatra"
require "sinatra/base"
require "sinatra/activerecord"
require "./models/task.rb"

CABLE_URL = ENV['ANYCABLE'] ? "ws://localhost:9293/cable" : "/cable"
configure { set :server, :puma }

class App < Sinatra::Base

  @@points = (0...52).to_a

  get '/' do
    tasks = Task.all.order(task_id: :desc)
    tasklen = tasks.length
    if tasklen == 0
      ctask = Task.new do |t|
        t.task_id, t.color, t.point, t.content = 0,'待定',0,'待定' 
      end
    else
      ctask = tasks.first
    end
    maxid = ctask.task_id
    erb :index, :locals => {:maxid => maxid, :tasks => tasks, :ctask => ctask}
  end
end
