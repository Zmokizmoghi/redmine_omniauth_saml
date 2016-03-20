class AddOneloginAuthToUser < ActiveRecord::Migration
  def change
    add_column :users, :onelogin_auth, :boolean, null: false, default: false
  end
end
