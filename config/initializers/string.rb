class String
  def to_boolean
    return true if self == 'TRUE'
    return false if self == 'FALSE'

    nil
  end
end
