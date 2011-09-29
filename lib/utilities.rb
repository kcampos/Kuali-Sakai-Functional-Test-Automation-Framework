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
  
  def random_nicelink(length=10)  # A "friendlier" version of the above. No characters need to be escaped for valid URLs.
    # Uses no Reserved or "Unsafe" characters.
    # Also excludes the comma, the @ sign and the plus sign, so it can be used to build email addresses.
    chars = %w{a b c d e f g h j k m n p q r s t u v w x y z A B C D E F G H J K L M N P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9 _ - .}
    (0...length).map { chars[rand(chars.size)]}.join
  end
  
  # A "friendlier" version of the above.  Only uses letters and numbers.
  def random_alphanums(length=10, s="")
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789'
    length.times { s << chars[rand(chars.size)] }
    s.to_s
  end
  
  # Some date and time helper functions
  def last_hour
    (Time.now - 3600).strftime("%I").to_i
  end
  
  def current_hour
    Time.now.strftime("%I").to_i
  end
  
  def next_hour
    (Time.now + 3600).strftime("%I").to_i
  end
  
end