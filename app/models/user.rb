class User < ActiveRecord::Base
  validates :username, :session_token, :password_digest, presence: true
  validates :username, :session_token, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}

  after_initialize :ensure_session_token

  attr_reader :password

  has_many :cats, dependent: :destroy
  has_many :cat_rental_requests, dependent: :destroy 

  def generate_session_token
    SecureRandom::urlsafe_base64(32)
  end

  def reset_session_token!
    begin
      self.session_token = generate_session_token
      self.save!
    rescue
      retry
    end
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

end
