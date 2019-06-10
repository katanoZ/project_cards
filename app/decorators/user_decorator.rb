module UserDecorator
  def filefield_label_class
    if errors[:new_image].present?
      'btn btn-lg btn-block btn-secondary bg-light-purple border-danger text-middle-purple mt-2 mt-lg-4'
    else
      'btn btn-lg btn-block btn-secondary bg-light-purple border-middle-purple text-middle-purple mt-2 mt-lg-4'
    end
  end
end
