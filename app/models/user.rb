class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtBlacklist

  validates :firstname, :lastname, :email, :password, presence: true
  validates :password, length: { in: 6..128, allow_blank: true }
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  belongs_to :company
  has_one :bank_account
  has_many :shares, class_name: 'UserShare'
  has_many :loans, class_name: 'UserLoan'

  # We override this method to avoid email uniqueness validation
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def admin?
    role == 'admin'
  end

  def full_name
    if firstname && lastname
      "#{firstname} #{lastname}"
    else
      username
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if conditions[:username].nil?
      where(conditions).first
    else
      where(username: conditions[:username]).first
    end
  end
end
