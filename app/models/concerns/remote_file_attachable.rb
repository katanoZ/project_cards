require 'open-uri'

module RemoteFileAttachable
  def attach_remote_file!(url)
    OpenURI.open_uri(url) do |file|
      content_type = file.content_type
      attachment_target.attach(
        io: file,
        filename: filename(url, content_type),
        content_type: content_type
      )
    end
  end

  def filename(url, content_type)
    # omniauthで取得したinfo.imageのファイル名がcontent_typeと異なる拡張子の場合があるため、
    # cloudinaryでエラーにならないように、content_typeに合わせた拡張子を付け直す。
    name = File.basename(url, '.*')
    ext = Rack::Mime::MIME_TYPES.invert[content_type]
    "#{name}#{ext}"
  end

  def attachment_target
    raise NotImplementedError, "You must implement #{self.class}##{__method__}"
  end
end
