class CardSaveLogsCallbacks
  TARGET_ATTRIBUTES = %w[due_date assignee_id].freeze

  def content_for_due_date(card)
    due_date_str = card.due_date ? I18n.l(card.due_date, format: :yyyymmdd) : 'なし'
    if card.operator
      "#{card.operator.name}さんが#{card.name}カードの期限を#{due_date_str}に設定しました"
    else
      "#{card.name}カードの期限が#{due_date_str}に設定されました"
    end
  end

  def content_for_assignee_id(card)
    if card.operator
      "#{card.operator.name}さんが#{card.name}カードを#{card.assignee.name}さんにアサインしました"
    else
      "#{card.name}カードが#{card.assignee.name}さんにアサインされました"
    end
  end

  private

  def after_save(card)
    TARGET_ATTRIBUTES.each do |attr|
      next unless card.saved_change_to_attribute?(attr)

      content = send("content_for_#{attr}", card)
      Log.create!(content: content, project: card.project)
    end
  end
end
