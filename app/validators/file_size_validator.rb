class FileSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    max_size = options[:maximum]
    return if value.size <= max_size

    record.errors[attribute] << (options[:message] || file_too_big_message(max_size))
  end

  def file_too_big_message(max_size)
    I18n.t('errors.messages.file_too_big', max_size: human_size(max_size))
  end

  def human_size(size)
    ActiveSupport::NumberHelper.number_to_human_size(size)
  end
end
