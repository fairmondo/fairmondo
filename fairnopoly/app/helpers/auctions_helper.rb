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
  def condition_label auction, extraclass =""
    bclass=condition_badge_class(auction.condition)
    raw "<span class=\"badge " + bclass + " " +extraclass +"\">" + auction.condition_text + "</span>"
  end

  def condition_badge_class condition
    case condition
    when "new"
      bclass="badge-info"
    when "old"
      bclass="badge-inverse"
    when "fair"
      bclass="badge-success"
    end
    bclass
  end
end
