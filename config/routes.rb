OData::Engine.routes.draw do
  get '/' => "o_data#service", as: :service, defaults: { format: 'xml' }
  get ':metadata' => "o_data#metadata", as: :metadata, defaults: { format: 'xml' },
    constraints: {metadata: /\$metadata/ }
  get '*path' => "o_data#resource", as: :resource, defaults: { format: 'atom' }
end
