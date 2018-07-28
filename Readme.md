## 1. 轮盘游戏

一个随机抽奖并实时向各端同步推送结果的♂轮盘游戏✨

体验地址: [点我体验游戏](http://118.25.177.136/)

**(已支持数据实时更新)**

## 2. 规则介绍

- 多人随机抽牌
- 任务者根据抽到牌的结果完成指定任务
- 抽牌过程中保证各端数据的一致性和实时性

## 3. 技术介绍


### 3.1 代码分支

- **master**分支：基于websocket分支合并,本文档以websocket分支为标准介绍
- **websocket**分支：基于websocket实现数据实时发送
- **ajax**分支：基于ajax实现异步数据请求，但不保证各端**实时性**，需要主动刷新页面

### 3.2 目录结构

- **`config`**: 存放一些配置文件
- **`db`**: 数据库迁移文件
- **`model`**: 模型，采用Active Record实现ORM
- **`public`**: 公有资源文件, 包含ydui框架资源、图片资源、jquery、websocket客户端js等, 其中`main.js`是需要关注的前端JS代码逻辑文件
- **`view`**: 视图文件, 就一个`index.erb`, 就是一个html文件，但为了偷懒少写JS，在首次加载页面时用模板绑定了一些数据，导致不是纯粹的html, 可优化
- **`app.rb`**: http后端，就是首页加载时绑定的那些数据
- **`chat.rb`**: websocket后端，`speak`方法实现抽牌, `clear`方法实现清空数据，结果都向ws前端进行广播
- **`config.ru`**: 工程启动文件，把app和chat打包为一个APP
- **`Gemfile`**: 依赖的第三方gem包，主要是sinatra框架、Active Record库、litecable库、puma库
- **`Rakefile`**: 脚手架文件，可以使用Rack进行模型迁移，如建立数据库，迁移模型等

### 3.3 框架介绍

1. **`Sinatra`**: 超轻量级WEB框架
2. **`Lite Cable`**: 基于`Pub/Sub`的websocket库
3. **`Active Record`**: 大名鼎鼎的ORM
4. **`YDUI`**: 一只注重审美，且性能高效的移动端&微信UI

## 4. 开发环境和项目配置

### 4.1. 安装RVM和RUBY

参考链接: [安装RUBY环境](https://ruby-china.org/wiki/deploy-rails-on-ubuntu-server)

### 4.2. 安装和配置MySQL

略略略

### 4.3. 安装依赖包

```bash
bundle install
```

### 4.4. 建立数据迁移任务

```bash
bundle exec rake db:create_migration NAME=create_posts
```

### 4.5.编写生成的数据迁移文件和模型文件

语法需要参考`ActiceRecord`[数据迁移](https://ruby-china.github.io/rails-guides/active_record_migrations.html)部分

**数据迁移文件**

```ruby
class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :task_id 
      t.string :color
      t.integer :point
      t.string :content
      t.timestamps
    end
  end
end
```

**模型文件**

```ruby
ActiveRecord::Base.establish_connection(
  adapter:  "mysql2",
  host:     "localhost",
  username: "root",
  password: "",
  database: "sample_app_production"
)
class Task < ActiveRecord::Base 
end
```

### 4.6. 执行数据迁移任务

**会建立对应的MYSQL数据表,需要先在MYSQL中新建数据库**

```bash
 bundle exec rake db:migrate
```

### 4.7. 程序本地启动

在项目目录下执行:

```
puma
```

启动浏览器查看

## 5. 生成环境与项目部署

### 5.1 生成环境说明

- web服务器: **`nginx`**
- 应用服务器: **`puma`**
- websocket服务器: **`puma`**
- DB服务器: **`MySQL`**

### 5.2 编写相关配置文件

已经编写好，存放在config目录下

### 5.3 在项目中建立对应的目录

mkdir shared
mkdir shared/sockets
mkdir shared/pids
mkdir log

### 5.4 启动应用服务器

在ubuntu 16.04以及以上版本，Linux使用了`Systemd`，启动puma步骤如下:

```bash
sudo cp config/puma-game.service /etc/systemd/system/puma-game.service

#开启服务
sudo systemctl start puma-game.service

#查看服务日志
sudo journalctl -f -u puma-game.service

#关闭服务，不要执行
sudo systemctl stop puma-game.service
```

### 5.5 启动web服务器

nginx配置请参考config中的game.conf文件

```bash
sudo cp config/game.conf /etc/nginx/site-available/game.conf
cd /etc/nginx/site-enabled/
sudo ln -s /etc/nginx/site-available/game.conf game.conf
sudo nginx -t
sudo service nginx restart
```

大功告成，休息一下吧~

## 6.特别鸣谢

本项目在开发过程中经历了三个阶段：

1. 基于sinatra + erb数据模板的传统web项目
2. 基于sinatra + ajax的前后端(基本)分离web项目
3. 基于sinatra + websocket的实时web项目

感谢**0x8023**、**MoeHero**、**Thinking**指出了本项目过程中存在的问题，并提出了宝贵的改进意见，没有这些意见，本项目还是一个基于erb不断请求后台的超传统web项目。

## 7. TODO List

1. 前端erb绑定的数据完全拆分
2. 前端项目从事件驱动(`jquery`)改为数据驱动(`vue.js`)
3. 后端性能提升，甚至迁移到`Golang`
4. 业务逻辑的进一步完善，如加强用户控制，识别用户等
5. 开二期新坑，做更有趣的需求