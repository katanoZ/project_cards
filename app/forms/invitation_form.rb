class InvitationForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  validates :name, presence: true

  def search
    User.search(name)
  end
end
