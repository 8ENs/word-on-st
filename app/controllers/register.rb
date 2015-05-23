WordOnSt::App.controllers :register do
  
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
  
  get :index, map: '/register' do
    @user = User.new
    render '/register/index'
  end

  post :register, map: '/register' do
    @user = User.new(
      name:   params[:user_name],
      email:  params[:user_email],
      password:  params[:user_password]
    )
    if @user.save
      session[:id] = @user.id
      session[:name] = @user.name
      redirect '/'
    else
      render '/register/index'
    end
  end

end
