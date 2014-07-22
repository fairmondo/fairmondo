class UserTokenGenerator
  def self.generate(user_agent, remote_addr)
    Digest::SHA2.hexdigest(user_agent + remote_addr)
  end
end