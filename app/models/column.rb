class Column < ApplicationRecord
  has_many :cards, -> { order(position: :desc) }, dependent: :destroy
  belongs_to :project

  acts_as_list scope: :project

  attr_accessor :operator

  validates :name, presence: true,
                   uniqueness: { scope: :project },
                   length: { maximum: 40 }
end
