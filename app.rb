require "sinatra"
require "sinatra/base"
require "sinatra/activerecord"
require "./models/task.rb"

configure { set :server, :puma }

class App < Sinatra::Base
  get '/' do
    tasks = Task.all.order(created_at: :desc)
    maxid = tasks.length
    erb :index, :locals => {:maxid => maxid, :tasks => tasks}
  end

  get "/task" do
    id = Task.maximum('task_id')
    task_id = id.to_i + 1
    color, point, content = random_task()

    task = Task.new do |t|
      t.task_id = task_id
      t.color, t.point, t.content = color, point, content
    end

    task.save

    redirect to('/')
  end

  get "/clear" do
    Task.destroy_all
    redirect to('/')
  end

  post "/finish" do
    task_id = params["id"].to_i
    status = params["status"].to_i
    task = Task.find_by(task_id: task_id)
    task.update(status: status)
    task.save
    succ_response('更新任务状态成功')
  end

  def random_task()
    colors = ['红桃','方块','黑桃','梅花']
    ponits = (1..13).to_a
    color, point = colors.sample, ponits.sample
    content = get_task_content(color, point)
    return color, point, content
  end

  def get_task_content(color, point)
    c_map = {
      '红桃' => '抽插',
      '方块' => '抽插',
      '黑桃' => '自慰',
      '梅花' => '自慰',
    }
    case c_map[color]
    when '抽插'
      content = '抽插' + (point * 5).to_s
    when '自慰'
      content = '自慰' + (point * 10).to_s    
    end
    content
  end

  def json_response(code, data, msg)
    result = {
      code: code,
      data: data,
      msg: msg
    }.to_json
  end

  def succ_response(data = {}, msg)
    json_response(0, data, msg)
  end
end
