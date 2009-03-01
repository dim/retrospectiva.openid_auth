#--
# Copyright (C) 2008 Dimitrij Denissenko
# Please read LICENSE document for more information.
#++
User.class_eval do
  attr_accessible :identity_url
  before_validation :normalize_identity_url
  
  validates_uniqueness_of :identity_url, 
    :case_sensitive => false, 
    :if => Proc.new { |user| user.identity_url.present? }
  
  def self.open_id_authenticate(identity_url)
    identity_url.present? ? active.find_by_identity_url(identity_url) : nil
  end
  
  protected
  
    def normalize_identity_url
      self.identity_url = OpenID::IdentityURL.parse(identity_url) if identity_url.present?
      true
    end
    
end
