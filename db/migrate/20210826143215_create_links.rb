class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :name, presence: true, default: false
      t.string :url, presence: true, default: false
      t.belongs_to :linkable, polymorphic: true

      t.timestamps
    end
  end
end
