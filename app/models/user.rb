class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :posts, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook, :instagram]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image
      user.access_token = auth.credentials.token

      # page_id = 'YOUR_PAGE_ID' # Replace with your Facebook Page ID
      # graph = Koala::Facebook::API.new(user.access_token)
      # page_access_token = graph.get_page_access_token(page_id)
      
      # user.page_access_token = page_access_token
    end
  end
end
