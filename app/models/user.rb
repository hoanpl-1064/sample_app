class User < ApplicationRecord
  attr_accessor :remember_token
  include BCrypt
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true
  validates :email, presence: true,
    length: {maximum: Settings.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX}

  has_secure_password

  def User.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             Engine::MIN_COST
           else
             Engine.cost
           end
    Password.create string, cost: cost
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_collumn :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_collumn :remember_digest, nil
  end
end
