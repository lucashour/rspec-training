class User < ApplicationRecord
  # -- Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }
  validates :role, presence: true

  # -- Associations
  has_many :posts, dependent: :destroy

  # -- Enumeratives
  enum role: [:admin, :regular]

  # -- Methods
  def valid_password?(value)
    value == password
  end
end
