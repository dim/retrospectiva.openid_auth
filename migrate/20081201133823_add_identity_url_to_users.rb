class AddIdentityUrlToUsers < ActiveRecord::Migration
  def self.up
    col_names = suppress_messages do
      columns('users').map(&:name)
    end
    index_names = suppress_messages do
      indexes('users').map(&:name)
    end
    unless col_names.include?('identity_url')
      add_column :users, :identity_url, :string, :limit => 100
    end
    unless index_names.include?('i_users_on_identity_url')
      add_index :users, :identity_url, :name => 'i_users_on_identity_url'
    end
  end

  def self.down
    remove_index :users, :name => 'i_users_on_identity_url'
    remove_column :users, :identity_url
  end
end
