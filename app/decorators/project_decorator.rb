module ProjectDecorator
  def form_path
    new_record? ? myprojects_path : myproject_path(id)
  end
end
