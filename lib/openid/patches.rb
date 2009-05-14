require 'openid/consumer'

OpenID::OpenIDServiceEndpoint.class_eval do
  
  class << self

    def from_html_with_unicode_patch(uri, html)
      from_html_without_unicode_patch(uri, html.force_encoding('UTF-8'))      
    end
    alias_method_chain :from_html, :unicode_patch
    
  end

end if RUBY_VERSION.to_f >= 1.9