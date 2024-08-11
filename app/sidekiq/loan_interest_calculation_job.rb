class LoanInterestCalculationJob
  include Sidekiq::Job

  def perform(id)
    loan = Loan.find(id)
    return unless loan.open?

    loan.update(total_payable_amount: loan.amount + (loan.amount * loan.interest_rate / 100))
    LoanInterestCalculationJob.perform_later(5.minutes, id)
  end
end
