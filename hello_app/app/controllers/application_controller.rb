class ApplicationController < ActionController::Base
  
  def hello
    render html: "デプロイ成功"
  end
  
end
