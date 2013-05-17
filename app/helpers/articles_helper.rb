module ArticlesHelper
  def category_button_text name , children , pad = false
    html= raw glyphicons('icon-tags')
    html+= " "
    html+= name
    if children
      html+= raw "<span style=\" float: right; "
      if pad
        html+=raw "padding-right:10px"
      end
      html+=raw "\">"
      html+= raw glyphicons('icon-chevron-right')
      html+= raw "</span>"
    end
    html
  end

  # Conditions
  def condition_label article, extraclass = ""
    bclass=condition_badge_class(article.condition)
    raw "<span class=\"badge " + bclass + " " + extraclass +"\">" + article.condition_text + "</span>"
  end

  def features_label article, extraclass = ""
     html = "<div class=\"" +extraclass+"\">"
     html +="<span class=\"label label-info\">" + t("formtastic.labels.article.fair")+ "</span>" if article.fair
     html +="<span class=\"label label-success\">" + t("formtastic.labels.article.ecologic")+ "</span>" if article.ecologic
     html +="<span class=\"label label-important\">" + t("formtastic.labels.article.small_and_precious")+ "</span>" if article.small_and_precious
     html += "</div>"
     html.html_safe
  end

  def condition_badge_class condition
    case condition
    when "new"
      bclass="badge-white"
    when "old"
      bclass="badge-inverse"
    end
    bclass
  end



   def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def get_category_tree category
    tree = []
    cat = category
    tree.unshift(cat)

    while parent_cat = parent_category(cat)
      tree.unshift(parent_cat)
      cat = parent_cat
    end
    return tree
  end

  def parent_category cat
    Category.where(:id => cat.parent_id).first
  end

  def category_shift level
    html = raw "padding-left:"+(level*10).to_s+"px;"
  end

end
