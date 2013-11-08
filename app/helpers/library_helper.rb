module LibraryHelper
  def library_header_layout library
    render "/shared/library_header", library: library
  end
end
