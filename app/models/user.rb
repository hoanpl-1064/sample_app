class User < ApplicationRecord
  include BCrypt
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true
  validates :email, presence: true,
    length: {maximum: Settings.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX}

  has_secure_password

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             Engine::MIN_COST
           else
             Engine.cost
           end
    Password.create string, cost: cost
  end
end
