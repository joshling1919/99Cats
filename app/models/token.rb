class Token < ActiveRecord::Base
  validates :user_id, :token, presence: true
  validates :token, uniqueness: true
  belongs_to :user

  def self.create_token!(user)
    begin
      session_token = self.generate_session_token
      Token.create(user_id: user.id, token: session_token)
    rescue
      retry
    end
    
    session_token
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(32)
  end
end
