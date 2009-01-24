#--
# Copyright (C) 2008 Dimitrij Denissenko
# Please read LICENSE document for more information.
#++
class OpenID::IdentityURL < String
  
  def self.parse(url)
    begin
      uri = URI.parse(url)
      uri = URI.parse("http://#{url}") unless uri.scheme
      uri.scheme = uri.scheme.downcase  # URI should do this
      new(uri.normalize.to_s.chomp('/'))
    rescue URI::InvalidURIError
      nil
    end
  end

end