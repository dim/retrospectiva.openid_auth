#--
# Copyright (C) 2008 Dimitrij Denissenko
# Please read LICENSE document for more information.
#++
class SessionsController < ApplicationController  
  alias_method :password_authentication, :create
  protected :password_authentication
  
  def create        
    if params[:identity_url] || params[:open_id_complete]
      openid_authentication
    else
      password_authentication
    end
  end

  protected
  
    def openid_authentication
      if params[:open_id_complete].nil?
        identity_url = OpenID::IdentityURL.parse(params[:identity_url])
        initiate_open_id_authentication(identity_url)
      else
        complete_open_id_authentication
      end
    end

  private
    include OpenidAuth::Transactions

    def initiate_open_id_authentication(identity_url)
      authenticating_open_id_user(identity_url) do
        begin_open_id_authentication(identity_url)
      end
    end

    def begin_open_id_authentication(identity_url)
      open_id_request = open_id_consumer.begin(identity_url)
      redirect_to(open_id_redirect_url(open_id_request, open_id_login_url))
    rescue OpenID::DiscoveryFailure, OpenID::OpenIDError
      failed_login _('Sorry, the OpenID server could not be found.')
    rescue Timeout::Error
      failed_login _('Unable to connection to the OpenID server.')      
    end

    def complete_open_id_authentication
      open_id_response = complete_open_id_transaction
      case open_id_response.status
      when OpenID::Consumer::SUCCESS
        identity_url = OpenID::IdentityURL.parse(open_id_response.identity_url)
        authenticating_open_id_user(identity_url) do |user|
          successful_login(user)
        end
      when OpenID::Consumer::CANCEL
        failed_login _('OpenID authentication was canceled.')
      when OpenID::Consumer::FAILURE
        failed_login _('Sorry, the OpenID authentication failed.')
      when OpenID::Consumer::SETUP_NEEDED
        failed_login _('Sorry, the OpenID account is not set-up correctly.')
      end
    end

    def authenticating_open_id_user(identity_url)
      user = User.open_id_authenticate(identity_url)
      if user
        yield(user)
      else
        message = _('Sorry, no user by that identity URL exists.')
        message += ' ' + _('Please register first.') if RetroCM[:general][:user_management][:self_registration]
        failed_login message
      end
    end

end
