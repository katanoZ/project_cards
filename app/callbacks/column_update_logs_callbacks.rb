class ColumnUpdateLogsCallbacks
  def content(column)
    if column.operator
      "#{column.operator.name}さんが#{column.name_before_last_save}カラムの名前を#{column.name}に編集しました"
    else
      "#{column.name_before_last_save}カラムの名前が#{column.name}に編集されました"
    end
  end

  private

  def after_update(column)
    return unless column.saved_change_to_name?

    Log.create!(content: content(column), project: column.project)
  end
end
