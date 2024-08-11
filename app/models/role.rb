class Role < ApplicationRecord
  has_many :user_roles
  has_many :users, through: :user_roles

  enum name: { admin: 'admin', user: 'user' }
end
