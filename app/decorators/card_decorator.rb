module CardDecorator
  def due_date_text
    if due_date
      "期限:#{l due_date, format: :yyyymmdd}"
    else
      '期限: 設定なし'
    end
  end
end
