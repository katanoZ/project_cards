class FileTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    allowed_content_types = options[:in]
    return if value.content_type.in?(allowed_content_types)

    record.errors[attribute] <<
      (options[:message] || file_type_invalid_message(allowed_content_types))
  end

  def file_type_invalid_message(allowed_content_types)
    I18n.t('errors.messages.file_type_invalid',
           type: content_type_names_of(allowed_content_types).join(', '))
  end

  def content_type_names_of(content_types)
    types = content_types.map { |content_type| Constants::CONTENT_TYPE_NAMES[content_type] }
    types.compact.uniq
  end
end
