WordOnSt::App.controllers :pins do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end

  get :pins, map: 'pins' do
    @pins = Pin.all
    render 'pins/index'
  end

  get :pins, map: 'pins/new' do
    @pin = Pin.new
    render 'pins/new'
  end

  get :show, map: 'pins/:id' do
    @pin = Pin.find(params[:id])
    render 'pins/show'
  end

  post :pins, map: 'pins' do
    @pin = Pin.new(
      message:   params[:message],
      location:  params[:location],
      recipient:   params[:recipient],
      url:   params[:url]
    )
    @pin.user_id = session[:id]
    if @pin.save
      redirect 'pins'
    else
      render 'pins/new'
    end
  end
  
end
