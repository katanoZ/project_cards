require 'open-uri'
# app/models/concerns/remote_file_attachable.rb #attach_remote_file!に対する対応。
# OpenURI.open_uriは、開こうとするファイルサイズが10 kbより大きい場合Tempfileになり、
# 10kb以下の場合はStringIOとなる。
# CloudinaryがStringIOを受け付けないため、ファイルサイズに関わらずTempfileになるよう修正。
OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
OpenURI::Buffer.const_set 'StringMax', 0
