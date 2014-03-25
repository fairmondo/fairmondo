class SearchCache < Article
  attr_accessor :attrs

  def initialize attrs
    self.attrs = attrs
    super attrs[:article]
  end

  # @attr [Proc] Block to execute on failure
  def articles
    begin ######## Solr
      find_like_this(attrs[:page]).results
    rescue Errno::ECONNREFUSED
      yield if block_given?
      Article.page attrs[:page]
    end
  end
end
