class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    user = User.find_for_database_authentication(email: params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      token = user.generate_jwt
      sign_in(user)
      
      respond_to do |format|
        format.json { render json: { message: 'Logged in successfully', token: token }, status: :ok }
        format.html do
          session[:user_token] = token
          redirect_to admin_test_results_path
        end
      end
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    sign_out(resource_name)
    redirect_to '/users/login'
  end
end

