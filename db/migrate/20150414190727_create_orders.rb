class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :card_id
      t.string :ip
      t.string :express_token
      t.string :express_payer_id

      t.timestamps null: false
    end
  end
end
