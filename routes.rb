#--
# Copyright (C) 2008 Dimitrij Denissenko
# Please read LICENSE document for more information.
#++
RetroEM::Routes.draw do |map|

  map.open_id_login 'sessions/open_id', :controller => "sessions", :action => "create", :conditions => { :method => :get }
  map.open_id_registration 'accounts/open_id', :controller => "accounts", :action => "create", :conditions => { :method => :get }

end

