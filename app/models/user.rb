class User < ApplicationRecord
  include Clearance::User
  has_one :user_role, dependent: :destroy
  has_one :role, through: :user_role

  has_many :loans
  has_many :given_loans, class_name: 'Loan', foreign_key: 'admin_id'

  delegate :admin?, to: :role

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.admin_user
    @admin_user = User.joins(:role).where(role: {name: :admin}).first
  end
end
