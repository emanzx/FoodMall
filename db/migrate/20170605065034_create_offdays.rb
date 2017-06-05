class CreateOffdays < ActiveRecord::Migration[5.0]
  def change
    create_table :offdays do |t|
      t.date :date_off
      t.text :note

      t.timestamps
    end
  end
end
