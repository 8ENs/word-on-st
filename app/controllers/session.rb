WordOnSt::App.controllers :session do

  get :index, map: '/login' do
    @user = User.new
    render 'login'
  end

  get :logout do
    session.destroy
    redirect '/'
  end

  post :login, map: '/login' do
    
    @user = User.find_by(email: params[:user_email], password: params[:user_password])

    if @user
      # authenticate
      session[:id] = @user.id
      session[:name] = @user.name
      redirect '/pins'
    else
      @user = User.new
      @user.errors[:email] << "Login failed. Please try again."
      render 'login'
    end
  end

end
