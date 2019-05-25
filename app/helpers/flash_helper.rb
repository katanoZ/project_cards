module FlashHelper
  def flash_class(key)
    case key
    when 'notice'
      'alert alert-primary alert-dismissible fade show'
    when 'alert'
      'alert alert-danger alert-dismissible fade show'
    end
  end
end
