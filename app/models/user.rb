class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :validatable

  has_one_attached :profile_picture

  ROLES = %w[super_admin admin branch_manager volunteer].freeze
  enum gender: {
    male: 1,
    female: 2,
    other: 3
  }

  validates :first_name,:last_name, :role, :gender, :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\+?[0-9]+\z/, message: 'Must be a valid phone number' }
  validates :role, inclusion: { in: ROLES, message: '%<value>s is not a valid role' }
  validates :password,
            presence: { message: 'Password can not be blank' },
            confirmation: { message: 'Password confirmation does not match' },
            length: { within: 8..128, message: 'Password must be between 8 and 128 characters long' },
            format: { with: /\A(?=.*[a-zA-Z])(?=.*\d).+\z/,
                      message: 'must include at least one letter and one number' },
            if: :password_required?
  validates :profile_picture,
            content_type: ['image/png', 'image/jpg', 'image/jpeg'],
            size: { less_than: 2.megabytes, message: 'is too large (maximum size is 2MB)' }

  ROLES.each do |role_name|
    define_method "#{role_name.gsub(' ', '_')}?" do
      role == role_name.tr('_', ' ')
    end
  end

  private

  def password_required?
    new_record? || password.present?
  end
end
