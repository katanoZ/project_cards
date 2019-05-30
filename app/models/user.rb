class User < ApplicationRecord
  include RemoteFileAttachable

  has_one_attached :image

  validates :name, presence: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  attr_reader :login_message

  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]

    find_or_create_by(provider: provider, uid: uid) do |user|
      user.name = auth[:info][:name]
      user.attach_remote_file!(auth[:info][:image])
    end
  end

  private

  attr_writer :login_message

  after_find :set_find_message
  after_create :set_create_message

  def set_find_message
    self.login_message = 'ログインしました'
  end

  def set_create_message
    self.login_message = 'アカウント登録しました'
  end

  # include RemoteFileAttachable
  def attachment_target
    image
  end
end
