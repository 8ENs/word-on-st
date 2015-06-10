WordOnSt::App.controllers :register do
  
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
      redirect '/pins'
    else
      render '/register/index'
    end
  end

end
