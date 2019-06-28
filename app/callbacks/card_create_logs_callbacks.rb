class CardCreateLogsCallbacks
  def content(card)
    if card.operator
      "#{card.operator.name}さんが#{card.name}カードを作成しました"
    else
      "#{card.name}カードが作成されました"
    end
  end

  private

  def after_create(card)
    Log.create!(content: content(card), project: card.project)
  end
end
