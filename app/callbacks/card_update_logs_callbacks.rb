class CardUpdateLogsCallbacks
  def content(card)
    if card.operator
      "#{card.operator.name}さんが#{card.name_before_last_save}カードの名前を#{card.name}に編集しました"
    else
      "#{card.name_before_last_save}カードの名前が#{card.name}に編集されました"
    end
  end

  private

  def after_update(card)
    return unless card.saved_change_to_name?

    Log.create!(content: content(card), project: card.project)
  end
end
