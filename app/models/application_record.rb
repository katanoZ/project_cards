class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # model全体に関する定数はここに書く
  # （個々のmodelに関する定数はそのmodelに書く）
  # （アプリケーション全体に関する定数はconfig/initializers/constants.rbに書く）

  # 最大画像サイズ
  MAX_IMAGE_SIZE = 2.megabytes

  # 画像の許容するContent-Type
  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/jpg image/png image/gif].freeze
end
