module LibraryHelper
  def library_header_layout library
    render "/libraries/library_header", library: library
  end
end
