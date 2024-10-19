class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    user = User.find_for_database_authentication(email: params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      sign_in(user)
      render json: { message: 'Logged in successfully', token: user.generate_jwt }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    sign_out(resource_name)
    render json: { message: 'Logged out successfully' }
  end
end
