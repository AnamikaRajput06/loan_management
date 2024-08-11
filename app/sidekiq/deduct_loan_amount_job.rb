class DeductLoanAmountJob
  include Sidekiq::Job

  def perform(id)
    loan = Loan.find(id)
    return unless loan.open?

    user = loan.user
    loan.update(status: 'closed', paid_at: Time.now, active: false)
    admin_user = User.admin_user
    admin_user.update(wallet: admin_user.wallet + user.wallet)
    user.update(wallet: 0)
  end
end
