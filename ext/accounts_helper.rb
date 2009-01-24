module AccountsHelper

  def html_options_for_account_form_with_openid_auth
    html_options_for_account_form_without_openid_auth.merge(:style => 'display:none;')
  end
  alias_method_chain :html_options_for_account_form, :openid_auth

end
