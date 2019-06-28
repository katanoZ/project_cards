class CardDestroyLogsCallbacks
  def content(card)
    if card.operator
      "#{card.operator.name}さんが#{card.name}カードを削除しました"
    else
      "#{card.column.name}カラムの#{card.name}カードが削除されました"
    end
  end

  private

  def after_destroy(card)
    Log.create!(content: content(card), project: card.project)
  end
end
