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
end
