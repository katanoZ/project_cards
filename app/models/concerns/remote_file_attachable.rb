require 'open-uri'

module RemoteFileAttachable
  def attach_remote_file!(url)
    OpenURI.open_uri(url) do |file|
      attachment_target.attach(
        io: file,
        filename: File.basename(url),
        content_type: file.content_type
      )
    end
  end

  def attachment_target
    raise NotImplementedError, "You must implement #{self.class}##{__method__}"
  end
end
