module LibraryHelper
  def library_header_layout library
    render "/libraries/library_header", library: library
  end

  def mock_library_element
    LibraryElement.new(
      library: Library.new(
        user: current_user
      ),
      article: resource
    )
  end
end
