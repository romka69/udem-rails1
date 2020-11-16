module HomeHelper
  def crud_label(action)
    case action
      when "create"
        "<span class='text-success'><i class='fa fa-plus'></i></span>"
      when "update"
        "<span class='text-warning'><i class='fa fa-pen'></i></span>"
      when "destroy"
        "<span class='text-danger'><i class='fa fa-trash'></i></span>"
    end
  end
end
