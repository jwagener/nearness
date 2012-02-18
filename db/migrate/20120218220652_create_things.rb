class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.string :url
      t.string :name
      t.string :image_url
      t.text :preview_html
      t.string :uri

      t.timestamps
    end
  end
end
