class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # model全体に関する定数はここに書く
  # （アプリケーション全体に関する定数はconfig/initializers/constants.rbに書く）
  MAX_IMAGE_SIZE = 2.megabytes
  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/jpg image/png image/gif].freeze
end
