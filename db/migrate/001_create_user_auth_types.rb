class CreateUserAuthTypes < ActiveRecord::Migration
  def change
    create_table :user_auth_types do |t|
      t.references :user, null: false
      t.boolean :onelogin_auth, null: false, default: false
    end
  end
end
