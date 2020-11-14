module ApplicationHelper
  include Pagy::Frontend

  def set_title_index
    return "#{controller_path.classify}s" if current_page?(action: "index")

    "#{action_name.humanize} #{controller_path.classify.downcase}s"
  end

  def set_h1_index(model, index_list)
    model = model == Course ? model.published.approved : model

    if current_page?(action: "index")
      "
        #{controller_path.classify}s
        <div class='badge badge-info'>
          #{model.count}
        </div>
      "
    else
      "
        #{action_name.humanize} #{controller_path.classify.downcase}s
        <div class='badge badge-info'>
          #{index_list.count}
        </div>
      "
    end
  end
end
