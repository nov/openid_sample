class CreateOpenIds < ActiveRecord::Migration
  def self.up
    create_table :open_ids do |t|
      t.string :identifier, :display_identifier
      t.text :ax_response, :oauth_response
      t.timestamps
    end
  end

  def self.down
    drop_table :open_ids
  end
end
