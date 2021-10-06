class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request?
  skip_before_action :verify_authenticity_token, if: :json_request?

  rescue_from ActionController::InvalidAuthenticityToken,
              with: :invalid_auth_token

  before_action :set_current_user, if: :json_request?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password) }
  end

  private

  def json_request?
    request.format.json?
  end

  # Use api_user Devise scope for JSON access
  def authenticate_user!(*args)
    super and return unless args.blank?

    json_request? ? authenticate_api_user! : super
  end

  def invalid_auth_token
    respond_to do |format|
      format.html do
        redirect_to new_user_session_path,
                    error: 'Login invalid or expired'
      end
      format.json { head 401 }
    end
  end

  # So we can use Pundit policies for api_users
  # rubocop:disable Naming/MemoizedInstanceVariableName
  def set_current_user
    @current_user ||= warden.authenticate(scope: :api_user)
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName

  def check_friendship(logged_user, user)
    Friendship.exists?(inviter_id: logged_user, invitee_id: user, status: true)
  end

  def check_invitation(logged_user, user)
    Friendship.exists?(inviter_id: logged_user,
                       invitee_id: user) || Friendship.exists?(inviter_id: user, invitee_id: logged_user)
  end
end
