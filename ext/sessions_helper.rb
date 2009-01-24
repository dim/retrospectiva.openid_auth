module SessionsHelper
  
  def html_options_for_login_form_with_openid_auth
    html_options_for_login_form_without_openid_auth.merge(:style => 'display:none;')
  end
  alias_method_chain :html_options_for_login_form, :openid_auth
  
end