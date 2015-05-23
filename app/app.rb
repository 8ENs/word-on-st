module WordOnSt
  class App < Padrino::Application
    register SassInitializer
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    # Homepage (Root path)
    get '/' do
      erb :index
    end

    # LOGIN #

    get '/login' do
      @user = User.new
      erb :'login'
    end

    get '/logout' do
      session.destroy
      redirect '/'
    end

    post '/login' do
      @user = User.find_by(email: params[:user_email], password: params[:user_password])

      if @user
        # authenticate
        session[:id] = @user.id
        session[:name] = @user.name
        redirect '/'
      else
        @user = User.new
        @user.errors[:email] << "Login failed. Please try again."
        erb :'login'
      end
    end

    # USERS #

    get '/users' do
      @users = User.all
      erb :'users/index'
    end

    get '/users/register' do
      @user = User.new
      erb :'users/register'
    end

    get '/users/:id' do
      @user = User.find(params[:id])
      erb :'users/show'
    end

    post '/users' do
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
        erb :'users/register'
      end
    end

    # PINS #

    get '/pins' do
      @pins = Pin.all
      erb :'pins/index'
    end

    get '/pins/new' do
      @pin = Pin.new
      erb :'pins/new'
    end

    get '/pins/:id' do
      @pin = Pin.find(params[:id])
      erb :'pins/show'
    end

    post '/pins' do
      @pin = Pin.new(
        message:   params[:message],
        location:  params[:location],
        recipient:   params[:recipient],
        url:   params[:url]
      )
      @pin.user_id = session[:id]
      if @pin.save
        redirect '/pins'
      else
        erb :'pins/new'
      end
    end

    helpers do
      def user_logged_in?
        session[:id]
      end

      def get_current_user
        User.find(session[:id]) if user_logged_in?
        # else return nil object so we can refer to get_current_user.name instead of session[:name] (option)
      end
    end


    ##
    # Caching support.
    #
    # register Padrino::Cache
    # enable :caching
    #
    # You can customize caching store engines:
    #
    # set :cache, Padrino::Cache.new(:LRUHash) # Keeps cached values in memory
    # set :cache, Padrino::Cache.new(:Memcached) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Memcached, '127.0.0.1:11211', :exception_retry_limit => 1)
    # set :cache, Padrino::Cache.new(:Memcached, :backend => memcached_or_dalli_instance)
    # set :cache, Padrino::Cache.new(:Redis) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Redis, :host => '127.0.0.1', :port => 6379, :db => 0)
    # set :cache, Padrino::Cache.new(:Redis, :backend => redis_instance)
    # set :cache, Padrino::Cache.new(:Mongo) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Mongo, :backend => mongo_client_instance)
    # set :cache, Padrino::Cache.new(:File, :dir => Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
    #

    ##
    # Application configuration options.
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, 'bar'       # Set path for I18n translations (default your_apps_root_path/locale)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    ##
    # You can configure for a specified environment like:
    #
    #   configure :development do
    #     set :foo, :bar
    #     disable :asset_stamp # no asset timestamping for dev
    #   end
    #

    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     render 'errors/404'
    #   end
    #
    #   error 500 do
    #     render 'errors/500'
    #   end
    #
  end
end
