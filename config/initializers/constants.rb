module Constants
  # アプリケーション全体に関する定数はここに書く
  # （model全体に関する定数はapp/models/application_record.rbに書く）
  # （個々のmodelに関する定数はそのmodelに書く）

  # Content-Typeに対して表示する名称
  CONTENT_TYPE_NAMES = {
    'image/jpeg': 'JPEG',
    'image/jpg': 'JPEG',
    'image/png': 'PNG',
    'image/gif': 'GIF'
  }.with_indifferent_access
end
