json.extract! loan, :id, :status, :amount, :interest_rate, :approved_at, :user_id, :admin_id, :created_at, :updated_at
json.url loan_url(loan, format: :json)
