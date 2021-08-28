class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :name, presence: true
      t.string :url, presence: true
      t.belongs_to :linkable, polymorphic: true

      t.timestamps
    end
  end
end
