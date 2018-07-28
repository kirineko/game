ActiveRecord::Base.establish_connection(
  adapter:  "mysql2",
  host:     "localhost",
  username: "root",
  password: "",
  database: "sample_app_production"
)
class Task < ActiveRecord::Base 
end