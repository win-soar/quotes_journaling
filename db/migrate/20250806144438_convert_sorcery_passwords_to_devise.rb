class ConvertSorceryPasswordsToDevise < ActiveRecord::Migration[7.1]
  def up
    User.find_each do |user|
      if user.encrypted_password.present? && !user.encrypted_password.start_with?('$2a$')
        user.update(
          encrypted_password: BCrypt::Password.create(user.password)
        )
      end
    end
  end
end