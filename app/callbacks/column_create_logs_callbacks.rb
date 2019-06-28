class ColumnCreateLogsCallbacks
  def content(column)
    if column.operator
      "#{column.operator.name}さんが#{column.name}カラムを作成しました"
    else
      "#{column.name}カラムが作成されました"
    end
  end

  private

  def after_create(column)
    Log.create!(content: content(column), project: column.project)
  end
end
