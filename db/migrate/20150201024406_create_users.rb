class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :single_access_token
      t.string :perishable_token
      #t.string :login_count
      #t.string :failed_login_count
      #t.string :last_request_at
      #t.string :current_login_at
      #t.string :last_login_at
      #t.string :current_login_ip
      #t.string :last_login_ip

      t.timestamps
    end
  end
end
