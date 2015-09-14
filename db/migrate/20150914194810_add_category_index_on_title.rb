class AddCategoryIndexOnTitle < ActiveRecord::Migration
  def change
    add_index :categories, :title
  end
end
