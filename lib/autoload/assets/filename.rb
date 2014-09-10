module Assets
  # This class does normalization of any string passed into `normalize`.
  # With help of `ActiveSupport#parameterize` all special characters that
  # don't conform URL standard will be replaced by dashes.
  # String passed will be also downcases.
  #
  # === Example
  #
  # Filename.normalize("Qwe%%ty 1.jPg")
  # => "qwe-ty-1.jpg"
  #
  class Filename
    def self.normalize(name)
      self.new(name).normalize
    end

    def initialize(name)
      @name = name
    end

    def normalize
      "#{file_name}#{ext_name}"
    end

    private

    def file_name
      File.basename(@name, File.extname(@name)).parameterize
    end

    def ext_name
      File.extname(@name).downcase
    end
  end

end