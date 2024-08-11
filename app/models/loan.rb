class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :admin, class_name: 'User'

  enum status: { requested: 0, approved: 1, open: 2, closed: 3, rejected: 4}

  before_create :generate_loan_number
  after_update :deduct_loan_amount

  # validate :amount_cannot_exceed_wallet, on: :create
  validate :check_admin_wallet_amount, :only_one_active_loan



  def generate_loan_number
    self.loan_number = "PLN-" + SecureRandom.hex(6)
  end

  # def amount_cannot_exceed_wallet
  #   if amount.present? && user.wallet <= amount
  #     errors.add(:amount, "cannot exceed the available wallet amount of #{user.wallet}")
  #   end
  # end

  def deduct_loan_amount
    DeductLoanAmountJob.perform_async(id) if self.open? && self.total_payable_amount > user.wallet
  end

  def check_admin_wallet_amount
    if self.status_changed? && self.approved? && admin.wallet < amount
      errors.add(:amount, "cannot exceed the available wallet amount of admin")
    end
  end

  private

  def only_one_active_loan

    if Loan.where(user_id: user_id, active: true).where.not(id: self.id).exists?
      errors.add(:status, 'There can only be one active loan at a time.')
    end
  end

end
