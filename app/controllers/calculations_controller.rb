class CalculationsController < ApplicationController

  def word_count
    @text = params[:user_text]
    @special_word = params[:user_word]

    # ================================================================================
    # Your code goes below.
    # The text the user input is in the string @text.
    # The special word the user input is in the string @special_word.
    # ================================================================================


    @word_count = @text.split.count

    @character_count_with_spaces = @text.length

    @character_count_without_spaces = @text.gsub(/\s+/,"").length

    @occurrences = @text.split.count(@special_word)

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("word_count.html.erb")
  end

  def payment(r,n,p)
    pmt=p*(r/12)/(1-(1+r/12)**-(n*12))
  end

  def loan_payment
    @apr = params[:annual_percentage_rate].to_f
    @years = params[:number_of_years].to_i
    @principal = params[:principal_value].to_f

    # ================================================================================
    # Your code goes below.
    # The annual percentage rate the user input is in the decimal @apr.
    # The number of years the user input is in the integer @years.
    # The principal value the user input is in the decimal @principal.
    # ================================================================================

    @monthly_payment = payment(@apr,@years,@principal)

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("loan_payment.html.erb")
  end

  def time_between
    @starting = Chronic.parse(params[:starting_time])
    @ending = Chronic.parse(params[:ending_time])

    # ================================================================================
    # Your code goes below.
    # The start time is in the Time @starting.
    # The end time is in the Time @ending.
    # Note: Ruby stores Times in terms of seconds since Jan 1, 1970.
    #   So if you subtract one time from another, you will get an integer
    #   number of seconds as a result.
    # ================================================================================

    @seconds = @ending - @starting
    @minutes = (@ending - @starting)/60
    @hours = (@ending - @starting)/60/60
    @days = (@ending - @starting)/60/60/24
    @weeks = (@ending - @starting)/60/60/24/7
    @years = (@ending - @starting)/60/60/24/7/52

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("time_between.html.erb")
  end

  def sum(n)
    n.inject(0) { |sum, x| sum + x }
  end

  def mean(n)
    n.inject(0) {sum(n)} / n.size.to_f
  end

  def median(n, already_sorted=false)
    return nil if n.empty?
    n = n.sort unless already_sorted
    m_pos = n.size / 2
    return n.size % 2 == 1 ? n[m_pos] : mean(n[m_pos-1..m_pos])
  end

  def variance(n)
    m = mean(n)
    n.inject(0) { |variance, x| variance + ((x - m) **2) }
  end

  def standard_deviation(n)
    m = mean(n)
    v = variance(n)
    return m, Math.sqrt(v/(n.size-1))
  end

  def modes(n, find_all=true)
    histogram = n.inject(Hash.new(0)) { |h, n| h[n] += 1; h }
    modes = nil
    histogram.each_pair do |item, times|
      modes << item if modes && times == modes[0] and find_all
      modes = [times, item] if (!modes && times>1) or (modes && times>modes[0])
    end
    return modes ? modes[1...modes.size] : modes
  end

  def descriptive_statistics
    @numbers = params[:list_of_numbers].gsub(',', '').split.map(&:to_f)

    # ================================================================================
    # Your code goes below.
    # The numbers the user input are in the array @numbers.
    # ================================================================================

    @sorted_numbers = @numbers.sort

    @count = @numbers.count

    @minimum = @numbers.min

    @maximum = @numbers.max

    @range = @maximum - @minimum

    @list = @sorted_numbers.length
    if @list %2 != 0
      @median = @sorted_numbers[@list/2]
    else
      @median = (@sorted_numbers[@list/2]+@sorted_numbers[(@list/2)-1])/2.0
    end

    @sum = @numbers.sum

    @mean = @sum / @count

    @variance = 0
    @numbers.each do |x|
      @variance = @variance + ((x-@mean)**2)/@count
    end

    @standard_deviation = Math.sqrt(@variance)

    @freq = @numbers.inject(Hash.new(0)) {|h,v| h[v] += 1; h}
    @mode=@numbers.max_by { |v| @freq[v]}

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("descriptive_statistics.html.erb")
  end
end
