module FormHelper
  def field_class(model:, field:)
    if model.errors[field].present?
      'form-control form-control-lg is-invalid'
    else
      'form-control form-control-lg'
    end
  end

  def label_class(model:, field:)
    if model.errors[field].present?
      'btn btn-lg btn-block btn-secondary bg-light-purple border-danger text-middle-purple mt-2 mt-lg-4'
    else
      'btn btn-lg btn-block btn-secondary bg-light-purple border-middle-purple text-middle-purple mt-2 mt-lg-4'
    end
  end
end
