class ApplicationController < ActionController::Base
  before_action :authenticate_user!,except: [:top,:about]
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def after_sign_in_path_for(resource)
    user_path(current_user.id)
    #user_path(resource)でも可。resouceはrailsのメソッドでログイン中のユーザー情報を取得する
    #current_userはdeviceのメソッドでログイン中のユーザー情報を取得する。二つは同じ役割で使える
  end

  def after_sign_out_path_for(resource)
    root_path
  end

#protectedではなくprivateでOK。他のコントローラーはこのコントローラーを継承しているから
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
