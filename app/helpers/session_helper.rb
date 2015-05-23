# Helper methods defined here can be accessed in any controller or view in the application

module WordOnSt
  class App
    module SessionHelper
      # def simple_helper_method
      # ...
      # end

      def user_logged_in?
        session[:id].present?
      end

      def get_current_user
        User.find(session[:id]) if user_logged_in?
        # else return nil object so we can refer to get_current_user.name instead of session[:name] (option)
      end
    end

    helpers SessionHelper
  end
end
