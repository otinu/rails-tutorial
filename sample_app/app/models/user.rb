class User < ApplicationRecord
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: { maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, 
               presence: true, 
               length: { maximum: 255 }, 
               format: { with: VALID_EMAIL_REGEX },
               uniqueness: true   #case_sensitive で強制的にfalseにさせていたが、必要がなくなったためにtrueに戻した。
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
end
