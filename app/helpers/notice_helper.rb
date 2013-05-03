module NoticeHelper
   #### Bootstrap Helpers ####
  
  # Map Flash to Bootstrap CSS
  def bootstrap_notice_mapper(type)
    case type
    when :alert
      "warning"
    when :error
      "error"
    when :notice
      "success"
    else
    "info"
    end
  end
  
  def main_notice_mapper(type)
    case type
    when :alert
      "error"
    when :error
      "error"
    when :notice
      "info"
    when :confirm
      "info confirmation"
    else
    "info"
    end
  end
  
  # Choose between :alert, :error, :notice for type
  def render_notice options = {}, &block
    render layout: "notice_layout",
      locals: {
        :type => options[:type],
        :hide => ""
      }, &block
  end
  
  def render_data_confirm 
    confirm_icon = glyphicons('icon-trash')
    confirm_text = I18n.t('common.text.confirm_yes')
    cancel_text  = I18n.t('common.text.confirm_no')
    render layout: "notice_layout", locals: { :type => :confirm , :hide => "hide"} do
       concat("<p class=\"confirmation_message\"></p>".html_safe)
       concat("<button class=\"btn btn-danger confirm\" > #{confirm_icon} #{confirm_text} </button>".html_safe)
       concat("<button class=\"btn cancel\"  > #{cancel_text} </button>".html_safe)
       
    end
  end
  
  
  
  
end