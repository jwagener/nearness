class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.string :object_url
      t.string :subject_url
      t.string :predicate
      t.string :creator_url

      t.timestamps
    end
  end
end
