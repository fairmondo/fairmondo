prawn_document(:filename=>"#{params[:print]}.pdf") do |pdf|

  pdf.text I18n.t("users.print.#{params[:print]}", name: resource.fullname), :align => :center, :size => 18
  pdf.move_down 12
  if params[:print] == 'terms'
    pdf.text Sanitize.fragment resource.terms
  elsif params[:print] == 'cancellation'
    pdf.text Sanitize.fragment resource.cancellation
  end
end