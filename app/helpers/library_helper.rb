module LibraryHelper
  # used for getting the pagination page for ajax content
  def library_pagination_page(params)
    if params[:library_page]
      "?library_page=#{params[:library_page]}"
    else
      ''
    end
  end
end
