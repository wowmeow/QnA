class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :title, presence: true
      t.text :body, presence: true

      t.timestamps
    end
  end
end
