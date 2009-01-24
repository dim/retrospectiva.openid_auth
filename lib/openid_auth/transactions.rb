module OpenidAuth
  module Transactions

    def complete_open_id_transaction
      params_with_path = params.reject { |key, value| request.path_parameters[key] }
      params_with_path.delete(:format)
      open_id_consumer.complete(params_with_path, request.url)
    end     

    def open_id_consumer
      @open_id_consumer ||= OpenID::Consumer.new session, OpenID::Store::Filesystem.new(File.join(RAILS_ROOT, 'tmp', 'openid'))
    end  

    def open_id_redirect_url(open_id_request, return_to)
      open_id_request.return_to_args['open_id_complete'] = '1'
      open_id_request.redirect_url(home_url, return_to)
    end    
    
  end   
end