#--
# Copyright (C) 2008 Dimitrij Denissenko
# Please read LICENSE document for more information.
#++
gem 'ruby-openid', '>= 2.0.0'
require 'openid'
require 'openid/store/filesystem'
require 'openid/extensions/sreg'

RetroEM::Views.register_extension 'openid_auth/user', :user, :fields
RetroEM::Views.register_extension 'openid_auth/session/form', :session, :top
RetroEM::Views.register_extension 'openid_auth/session/header', :session, :header
RetroEM::Views.register_extension 'openid_auth/account/form', :user, :new, :top
RetroEM::Views.register_extension 'openid_auth/account/header', :user, :new, :header
