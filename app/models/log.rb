class Log < ApplicationRecord
  belongs_to :project

  paginates_per 5

  def self.create_due_date_notification_logs!
    cards = Card.where('due_date <= ?', Date.today).order(created_at: :asc)
    cards.each do |card|
      content = if card.due_date.today?
                  "本日が#{card.name}カードの締切期限です"
                else
                  "#{card.name}カードの締切期限が#{(Date.today - card.due_date).to_i}日過ぎました"
                end
      create!(content: content, project: card.project)
    end
  end
end
