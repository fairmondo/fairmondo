module AuctionsHelper
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
  def condition_label auction, extraclass = ""
    bclass=condition_badge_class(auction.condition)
    raw "<span class=\"badge " + bclass + " " + extraclass +"\">" + auction.condition_text + "</span>"
  end
  
  def features_label auction, extraclass = ""
     html = "<div class=\"" +extraclass+"\">"
     html +="<span class=\"label label-info\">" + t("formtastic.labels.auction.fair")+ "</span>" if auction.fair
     html +="<span class=\"label label-success\">" + t("formtastic.labels.auction.ecologic")+ "</span>" if auction.ecologic
     html +="<span class=\"label label-important\">" + t("formtastic.labels.auction.small_and_precious")+ "</span>" if auction.small_and_precious
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
  
end
