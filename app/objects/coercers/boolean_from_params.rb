class BooleanFromParams < Virtus::Attribute

  def coerce value
    return true if value.is_a?(TrueClass) || value == 1 || value =~ (/^(true|t|yes|y|1)$/i)
    false
  end

end
