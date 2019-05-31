class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  MAX_IMAGE_SIZE = 2.megabytes
  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/jpg image/png image/gif].freeze
end
