class LoansController < ApplicationController
  before_action :require_login
  before_action :set_loan, only: %i[ edit]
  load_and_authorize_resource except: %i[create new]
  authorize_resource only: %i[create new]

  # GET /loans or /loans.json
  def index
  end

  # GET /loans/new
  def new
    @loan = Loan.new
  end

  def edit
  end


  # POST /loans or /loans.json
  def create
    @loan = Loan.new(loan_params)
    @loan.user_id = current_user.id
    @loan.admin_id = admin_user.id

    respond_to do |format|
      if @loan.save
        format.html { redirect_to loans_url, notice: "Loan was successfully created." }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    if @loan.update(status: 'approved', interest_rate: approve_params[:interest_rate].presence || 5)
      redirect_to loans_url, notice: "Loan was successfully approved."
    else
      redirect_to loans_url, notice: "Loan approval failed."
    end
  end

  def reject
    if @loan.update(status: 'rejected', active: false)
      redirect_to loans_url, notice: "Loan was successfully rejected."
    else
      redirect_to loans_url, notice: "Loan rejection failed."
    end
  end

  def accept
    if @loan.update(status: 'open', total_payable_amount: @loan.amount) && admin_user.update(wallet: admin_user.wallet - @loan.amount) && @loan.user.update(wallet: @loan.user.wallet + @loan.amount)
      LoanInterestCalculationJob.perform_at(5.minutes, @loan.id)
      redirect_to loans_url, notice: "Loan was successfully accepted."
    else
      redirect_to loans_url, notice: "Loan acceptance failed."
    end
  end

  def pay
    if current_user.wallet >= @loan.total_payable_amount
      if @loan.update(status: 'closed', paid_at: Time.now, active: false) && admin_user.update(wallet: admin_user.wallet + @loan.total_payable_amount) && current_user.update(wallet: current_user.wallet - @loan.total_payable_amount)
        redirect_to loans_url, notice: "Loan was successfully paid."
      else
        redirect_to loans_url, notice: "Loan payment failed."
      end
    else
      redirect_to loans_url, notice: "Insufficient wallet balance."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = Loan.find(params[:id])
    end

    def approve_params
      params.require(:loan).permit(:interest_rate)
    end

    # Only allow a list of trusted parameters through.
    def loan_params
      params.require(:loan).permit(:name, :amount)
    end
end
