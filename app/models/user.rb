class User < ApplicationRecord
  include RemoteFileAttachable

  has_one_attached :image
  attribute :new_image
  attr_reader :login_message

  validates :name, presence: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :new_image, file_size: { maximum: MAX_IMAGE_SIZE },
                        file_type: { in: ALLOWED_IMAGE_TYPES },
                        if: :new_image

  after_find :set_find_message
  after_create :set_create_message

  # バリデーションが成功して保存する場合のみ、フォームから入力した画像を実際に添付する
  before_save :attach_new_image

  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]

    find_or_create_by(provider: provider, uid: uid) do |user|
      user.name = auth[:info][:name]
      user.attach_remote_file!(auth[:info][:image])
    end
  end

  # include RemoteFileAttachable
  def attachment_target
    image
  end

  private

  attr_writer :login_message

  def attach_new_image
    image.attach(new_image) if new_image
  end

  def set_find_message
    self.login_message = 'ログインしました'
  end

  def set_create_message
    self.login_message = 'アカウント登録しました'
  end
end
