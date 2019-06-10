module FormHelper
  def field_class(model:, field:)
    if model.errors[field].present?
      'form-control form-control-lg is-invalid'
    else
      'form-control form-control-lg'
    end
  end
end
