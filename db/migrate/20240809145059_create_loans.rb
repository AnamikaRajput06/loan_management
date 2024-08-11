class CreateLoans < ActiveRecord::Migration[7.1]
  def change
    create_table :loans do |t|
      t.string :name, null: false
      t.string :loan_number, null: false
      t.integer :status, null: false, default: 0
      t.float :amount, null: false
      t.float :interest_rate, default: 5.0, null: false
      t.float :total_payable_amount
      t.datetime :paid_at
      t.boolean :active, default: true
      t.references :user, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
    add_index :loans, :loan_number, unique: true
  end
end
