module OpenidAuth
  module Transactions
    IGNORE_KEYS = [:format, :user]

    def complete_open_id_transaction      
      params_with_path = params.except(*IGNORE_KEYS).reject { |key, value| request.path_parameters[key] }
      open_id_consumer.complete(params_with_path, request.url)
    end     

    def open_id_consumer
      @open_id_consumer ||= OpenID::Consumer.new session, OpenID::Store::Filesystem.new(File.join(RAILS_ROOT, 'tmp', 'openid'))
    end  

    def open_id_redirect_url(open_id_request, return_to)
      open_id_request.return_to_args['open_id_complete'] = '1'
      open_id_request.redirect_url(root_url, return_to)
    end    
    
  end   
end