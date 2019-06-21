class OwnerRejectionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.owner?(record.project)

    record.errors[attribute] <<
      (options[:message] || I18n.t('errors.messages.invalid'))
  end
end
