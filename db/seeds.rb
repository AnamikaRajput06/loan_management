# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# create the roles
#
Role.names.each do |key, value|
  Role.find_or_create_by!(name: value)
end



# Create a user with admin role
admin_user = User.create!(email: 'admin@diatoz.com', password: 'admin@123', first_name: 'Admin', last_name: 'User', wallet: 1000000)
UserRole.create!(user: admin_user, role: Role.find_by(name: 'admin'))

# Create a user with user role
users = [
  { email: 'employee1@diatoz.com', password: 'employee@123', first_name: 'Employee', last_name: 'User1' },
  { email: 'employee2@diatoz.com', password: 'employee@123', first_name: 'Employee', last_name: 'User2' },
  { email: 'employee3@diatoz.com', password: 'employee@123', first_name: 'Employee', last_name: 'User3' },
  { email: 'employee4@diatoz.com', password: 'employee@123', first_name: 'Employee', last_name: 'User4' },
]

user_role = Role.find_by(name: 'user')

users.each do |user|
  user = User.create!(user)
  UserRole.create!(user: user, role: user_role)
end
