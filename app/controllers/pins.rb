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

  get :index, map: '/pins' do
    @pins = Pin.all
    render '/pins/index'
  end

  get :new, map: '/pins/new' do
    @new_pin = Pin.new
    @pins = Pin.where(user_id: session[:id])
    render '/pins/new'
  end

  get :for, map: '/pins/new/:id' do
    @new_pin = Pin.new
    @pins = Pin.where(user_id: session[:id])
    @id = params[:id]
    render '/pins/new'
  end

  get :destroy, map: '/pins/destroy/:id' do
    Pin.find(params[:id]).destroy
    redirect '/pins'
  end

  get :show, map: '/pins/:id' do
    @pin = Pin.find(params[:id])
    render '/pins/show'
  end

  # maybe make locations its own model/controller once things get more complicated with geo/map/etc ?
  # get :location, map: '/pins/location/:id' do
  #   @pins = Pin.all
  #   render '/pins/location'
  # end

  post :pins, map: '/pins' do
    @new_pin = Pin.new(
      message:   params[:message],
      location:  params[:location],
      recipient:   params[:recipient],
      url:   params[:url]
    )
    @new_pin.user_id = session[:id]
    if @new_pin.save
      redirect '/pins'
    else
      render '/pins/new'
    end
  end
  
end
