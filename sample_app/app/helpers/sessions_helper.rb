module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザーがnilでない && 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default) 
    redirect_to(session[:forwarding_url] || default)  #リクエストされたURLが存在する場合はそこにリダイレクトし、ない場合は何らかのデフォルトのURLにリダイレクト。
    session.delete(:forwarding_url)    #転送用のURLを削除している。これをやっておかないと、次回ログインしたときに保護されたページに転送されてしまい、ブラウザを閉じるまでこれが繰り返されてしまう。
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?    #リクエストが送られたURLをsession変数の:forwarding_urlキーに格納。GETリクエストが送られたときだけ。
  end
end