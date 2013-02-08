class AddUvSolarPeriods < ActiveRecord::Migration
  def self.up
    add_column :past_summaries, :uv, :int
    add_column :past_summaries, :hiUVDate, :datetime
    add_column :past_summaries, :solar, :int
    add_column :past_summaries, :hiSolarDate, :datetime
  end

  def self.down
    remove_column :past_summaries, :uv
    remove_column :past_summaries, :hiUVDate
    remove_column :past_summaries, :solar
    remove_column :past_summaries, :hiSolarDate
  end
end

