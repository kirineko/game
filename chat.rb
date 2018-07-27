require "litecable"
require "sinatra/activerecord"
require "./models/task.rb"

module Chat
  class Connection < LiteCable::Connection::Base
    identified_by :sid

    def connect
      @sid = request.params["sid"]
      $stdout.puts "#{@sid} connected"
    end

    def disconnect
      $stdout.puts "#{@sid} disconnected"
    end
  end

  class Channel < LiteCable::Channel::Base

    identifier :chat
    @@points = (0...52).to_a

    def subscribed
      reject unless chat_id
      stream_from "chat_#{chat_id}"
    end

    def speak(data)
      id = Task.maximum('task_id')
      task_id = id.to_i + 1
      color, point, content = random_task()

      if !color
        code = -1
        data = {}
        msg = ''
      else
        task = Task.new do |t|
          t.task_id = task_id
          t.color, t.point, t.content = color, point, content
        end

        task.save

        data = {
          task_id: task_id,
          color: color,
          point: point,
          content: content
        }
      end

      LiteCable.broadcast "chat_#{chat_id}", code: code , data: data, sid: sid, action: 'speak'
    end

    def clear(data)
      Task.delete_all
      @@points = (0...52).to_a
      LiteCable.broadcast "chat_#{chat_id}", code: 0 , data: {}, sid: sid, action: 'clear'
    end

    private

    def chat_id
      params.fetch("id")
    end

    def random_task()
      colors = ['红桃','方块','黑桃','梅花']
      points = (1..13).to_a
      alloc = @@points.sample
      if !alloc 
        return nil,nil,nil
      end
      @@points.delete(alloc)
      cindex, pindex = alloc.divmod(13)
      color, point = colors[cindex], points[pindex]
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

  end
end
