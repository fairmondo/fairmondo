prawn_document(:filename=>"#{t("formtastic.labels.user.#{params[:print]}")}.pdf") do |pdf|

  pdf.text I18n.t("users.print.#{params[:print]}", name: resource.fullname), :align => :center, :size => 18
  pdf.move_down 12
  if params[:print] == 'terms'
    pdf.text HtmlToText.convert resource.terms
  elsif params[:print] == 'cancellation'
    pdf.text HtmlToText.convert  resource.cancellation
  end
end