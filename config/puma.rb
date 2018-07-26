# Change to match your CPU core count
workers ENV.fetch("PUMA_WORKERS") { 1 }

# Min and Max threads per worker
threads ENV.fetch("PUMA_MIN_THREADS") { 1 }, ENV.fetch("PUMA_MAX_THREADS") { 10 }

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# Set up socket location
bind "unix://#{shared_dir}/sockets/puma.sock"

# Redirect STDOUT to log files
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
rackup "#{app_dir}/config.ru"

activate_control_app