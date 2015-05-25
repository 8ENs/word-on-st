
WordOnSt::App.controllers :pins do
  # ANDREW"S RECOMMENDED MAPPINGS FOR CONTROLLERS
  #
  # get :index, map: '/pins'
  # get :show, with: :id, map: '/pins/:id'
  # get :new, map: '/pins/new'
  # post :create, map: '/pins'
  # get :edit, with: :id, map: '/pins/:id/edit'
  # put :update, with: :id, map: '/pins/:id'
  # delete :destroy, with: :id, map: '/pins/:id'
  #

  get :index, map: '/pins', provides: [:html, :json] do
    @pins = Pin.all

    # @here = [ params[:lat].to_f, params[:lon].to_f ]
    @here = [60.71549959999999, -135.0489237]

    case content_type
    when :html
      render '/pins/index'
    when :json
      @pins.to_json
    end
  end

  get :new, map: '/pins/new', provides: [:html, :json] do
    @new_pin = Pin.new
    @pins_sent = Pin.where(user_id: session[:id])

    @pins = Pin.all
    case content_type
    when :html
      render '/pins/new'
    when :json
      @pins.to_json
    end
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
      coordinates:  [ params[:lat], params[:lon] ],
      recipient:   params[:recipient],
      # url:   params[:url]
    )
    @new_pin.user_id = session[:id]

    if @new_pin.save
      redirect '/pins'
    else
      render '/pins/new'
    end
  end
  
end
