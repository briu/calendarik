Rails.application.routes.draw do
  scope 'fetch_event/:event_type' do
    resources :events, except: :show do
      get 'get_events', on: :collection
      post 'move', on: :collection
      post 'resize', on: :collection
    end
  end
end
