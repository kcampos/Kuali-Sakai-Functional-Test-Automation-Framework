class Time

  # Using the :year_range option (or no option), this method creates a
  # Time object of a random value, within
  # the year range specified (default is 5 years in the past).
  #
  # Using the :series option, this method returns an array
  # containing a randomized Time object as its first element (limited by
  # the specified :year_range value). Subsequent elements will be Time objects
  # with values putting them later than the prior element, within the specified
  # range value (see examples).
  #
  # Usage Examples:
  # @example
  #   a random date...
  #   ?> Time.random
  #   => Tue Aug 05 00:00:00 EDT 2007
  #
  #   birthdays, anyone?...
  #   5.times { p Time.random(:year_range=>80) }
  #   Wed Feb 06 00:00:00 EDT 1974
  #   Tue Dec 22 00:00:00 EST 1992
  #   Fri Apr 14 00:00:00 EWT 1944
  #   Thu Jul 01 00:00:00 EDT 1993
  #   Wed Oct 02 00:00:00 EDT 2002
  #
  #   A series of dates are useful for account-related info...
  #   ?> Time.random(:series=>[20.days, 3.years])
  #   => [Sat Jan 22 00:00:00 EST 2005,
  #   Sat Jan 29 12:58:45 EST 2005,
  #   Fri Sep 08 09:34:58 EDT 2006]
  #
  #   or maybe to simulate events during an hour?...
  #   ?> Time.random(:series=>[1.hour,1.hour,1.hour])
  #   => [Wed Apr 21 00:00:00 EDT 2004,
  #   Wed Apr 21 00:45:59 EDT 2004,
  #   Wed Apr 21 01:02:47 EDT 2004,
  #   Wed Apr 21 01:31:00 EDT 2004]
  def self.random(params={})
    years_back = params[:year_range] || 5
    year = (rand * (years_back)).ceil + (Time.now.year - years_back)
    month = (rand * 12).ceil
    day = (rand * 31).ceil
    series = [date = Time.local(year, month, day)]
    if params[:series]
      params[:series].each do |some_time_after|
        series << series.last + (rand * some_time_after).ceil
      end
      return series
    end
    date
  end

end  # Time

module Enumerable

  # Use for getting a natural sort order instead of the ASCII
  # sort order.
  def alphabetize
    sort { |a, b| grouped_compare(a, b) }
  end

  # Use for sorting an Enumerable object in place.
  def alphabetize!
    sort! { |a, b| grouped_compare(a, b) }
  end

  private
  def grouped_compare(a, b)
    loop {
      a_chunk, a = extract_alpha_or_number_group(a)
      b_chunk, b = extract_alpha_or_number_group(b)
      ret = a_chunk <=> b_chunk
      return -1 if a_chunk == ''
      return ret if ret != 0
    }
  end

  def extract_alpha_or_number_group(item)
    test_item = item.downcase
    matchdata = /([a-z]+|[\d]+)/.match(test_item)
    if matchdata.nil?
      ["", ""]
    else
      [matchdata[0], test_item = test_item[matchdata.offset(0)[1] .. -1]]
    end
  end

end # Enumerable