#--
# Copyright (C) 2008 Dimitrij Denissenko
# Please read LICENSE document for more information.
#++
class AccountsController < ApplicationController
  alias_method :standard_registration, :create
  protected :standard_registration
  
  def create    
    if params[:identity_url] || params[:open_id_complete]
      openid_registration
    else
      standard_registration
    end
  end

  protected
  
    def openid_registration
      if params[:open_id_complete].nil?
        identity_url = OpenID::IdentityURL.parse(params[:identity_url])
        begin_open_id_registration(identity_url)
      else
        complete_open_id_registration
      end
    end

  private
    include OpenidAuth::Transactions
  
    def begin_open_id_registration(identity_url)
      open_id_request = open_id_consumer.begin(identity_url)
      add_registration_fields(open_id_request)
      redirect_to(open_id_redirect_url(open_id_request, open_id_registration_url))
    rescue OpenID::DiscoveryFailure, OpenID::OpenIDError
      failed_registration _('Sorry, the OpenID server could not be found.')
    rescue Timeout::Error
      failed_registration _('Unable to connection to the OpenID server.')      
    end

    def complete_open_id_registration
      open_id_response = complete_open_id_transaction      
      case open_id_response.status
      when OpenID::Consumer::SUCCESS
        purge_expired_accounts
        @user = User.new :identity_url => OpenID::IdentityURL.parse(open_id_response.identity_url), 
          :name => params['openid.sreg.fullname'] || params['openid.sreg.nickname']
        @user.time_zone = params['openid.sreg.timezone'] if params['openid.sreg.timezone'].present?
        @user.username = params['openid.sreg.nickname']
        @user.email = params['openid.sreg.email']
        @user.plain_password = @user.plain_password_confirmation = Digest::SHA1.hexdigest(rand(Time.now.utc.to_i).to_s)
        if @user.save
          successful_registration
        else
          failed_registration
        end
      when OpenID::Consumer::CANCEL
        failed_registration _('OpenID authentication was canceled.')
      when OpenID::Consumer::FAILURE
        failed_registration _('Sorry, the OpenID authentication failed.')
      when OpenID::Consumer::SETUP_NEEDED
        failed_registration _('Sorry, the OpenID account is not set-up correctly.')
      end
    end

    def add_registration_fields(open_id_request)
      sreg_request = OpenID::SReg::Request.new
      sreg_request.request_fields(['nickname', 'email', 'fullname', 'timezone'], true)
      open_id_request.add_extension(sreg_request)
    end
end
