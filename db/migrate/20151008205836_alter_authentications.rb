class AlterAuthentications < ActiveRecord::Migration
  def up
    change_column :authentications, :provider, :string, default: '', null: false, after: :uid
    change_column :authentications, :uid, :string, default: '', null: false

    add_column :authentications, :sign_in_count, :integer, default: 0, null: false
    add_column :authentications, :current_sign_in_at, :datetime
    add_column :authentications, :last_sign_in_at, :datetime
    add_column :authentications, :current_sign_in_ip, :inet
    add_column :authentications, :last_sign_in_ip, :inet

    remove_index :authentications, [:provider, :uid]
    add_index :authentications, [:uid, :provider, :staff_id], unique: true
  end

  def down
    change_column :authentications, :uid, :string, after: :provider
    change_column :authentications, :provider, :string

    remove_column :authentications, :sign_in_count
    remove_column :authentications, :current_sign_in_at
    remove_column :authentications, :last_sign_in_at
    remove_column :authentications, :current_sign_in_ip
    remove_column :authentications, :last_sign_in_ip

    remove_index :authentications, [:uid, :provider, :staff_id]
    add_index :authentications, [:provider, :uid], unique: true
  end
end
