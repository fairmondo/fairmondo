if @print
  prawn_document(:filename=>"#{t("formtastic.labels.user.#{@print}")}.pdf") do |pdf|

    pdf.text I18n.t("users.print.#{@print}", name: resource.fullname), :align => :center, :size => 18
    pdf.move_down 12
    if @print == 'terms'
      pdf.text HtmlToText.convert resource.terms
    elsif @print == 'cancellation'
      pdf.text HtmlToText.convert  resource.cancellation
    end
  end
end
