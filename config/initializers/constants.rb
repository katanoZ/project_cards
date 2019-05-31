module Constants
  # アプリケーション全体に関する定数はここに書く
  # （model全体に関する定数はapp/models/application_record.rbに書く）
  CONTENT_TYPE_NAMES = {
    'image/jpeg': 'JPEG',
    'image/jpg': 'JPEG',
    'image/png': 'PNG',
    'image/gif': 'GIF'
  }.with_indifferent_access
end
