class Admin < ActiveRecord::Migration
def up
  admin = User.new
  admin.email = "admin@example.com"
  admin.password = "secret"
  admin.password_confirmation = "secret"
  admin.role = "admin"
  admin.save!
end

def down
  admin = User.find_by_email "admin@example.com"
  User.delete admin
end
end
