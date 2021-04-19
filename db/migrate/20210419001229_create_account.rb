class CreateAccount < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.boolean :blocked, :default => false

      t.timestamps
    end
  end
end
