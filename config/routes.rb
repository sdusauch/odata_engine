OData::Engine.routes.draw do
  get 'OData.svc' => "o_data#service", :as => :service, :defaults => { :format => 'xml' }
  # this is what we want to do, but this doesn't work in Rails 4
  #get '$metadata' => "o_data#metadata", :as => :o_data_metadata, :defaults => { :format => 'xml' }
  # this is a workaround
  get ':wtfrails' => "o_data#metadata", :as => :metadata, :defaults => { :format => 'xml' },
    :constraints => {wtfrails: /\$metadata/ }
  get 'OData.svc/*path' => "o_data#resource", :as => :resource, :defaults => { :format => 'atom' }
end
