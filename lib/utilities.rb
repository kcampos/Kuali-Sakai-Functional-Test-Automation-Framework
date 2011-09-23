# 
# == Synopsis
#
# This file contains custom methods used throughout rSmart's test scripts

module Utilities
  
  # A random string creator that draws from all printable ASCII characters
  # from 33 to 128.
  def random_string(length=10, s="")
    length.enum_for(:times).inject(s) do |result, index|
      s << rand(93) + 33 
    end
  end
  
  # A "friendlier" version of the above.  Only uses letters and numbers.
  def random_alphanums(length=10, s="")
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789'
    length.times { s << chars[rand(chars.size)] }
    s.to_s
  end
  
end