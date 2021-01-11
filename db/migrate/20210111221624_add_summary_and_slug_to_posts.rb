class AddSummaryAndSlugToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :summary, :text
    add_column :posts, :slug, :string
    add_index :posts, :slug, unique: true
  end
end
