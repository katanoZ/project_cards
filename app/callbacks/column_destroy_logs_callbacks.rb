class ColumnDestroyLogsCallbacks
  def content(column)
    if column.operator
      "#{column.operator.name}さんが#{column.name}カラムを削除しました"
    else
      "#{column.name}カラムが削除されました"
    end
  end

  private

  def after_destroy(column)
    Log.create!(content: content(column), project: column.project)
  end
end
