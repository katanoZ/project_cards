require 'open-uri'

module RemoteImageAttachable
  def attach_remote_image!(url)
    OpenURI.open_uri(url) do |file|
      image.attach(
        io: file,
        filename: File.basename(url),
        content_type: file.content_type
      )
    end
  end
end
