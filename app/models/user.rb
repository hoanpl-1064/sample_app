class User < ApplicationRecord
  attr_accessor :remember_token
  include BCrypt
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true
  validates :email, presence: true,
    length: {maximum: Settings.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX}
  validates :password, presence: true,
    length: {minimum: Settings.user.email.min_length},
    allow_nil: true
  # allow_nil: true to ignore the checking name
  # and email when we update (it filled)

  has_secure_password

  scope :sort_name, ->{order :name}

  def self.digest string
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
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_column :remember_digest, nil
  end
end
