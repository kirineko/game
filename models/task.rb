ActiveRecord::Base.establish_connection(
  adapter:  "mysql2",
  host:     "118.25.177.136",
  username: "root",
  password: "root",
  database: "sample_app_production"
)
class Task < ActiveRecord::Base 
end