class AddCountColumnToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :loan_requests_categories_count, :integer, default: 0
  end
end
