module StringCalculator
  def add
    add_em_up
  end

  private

  def add_em_up
    d = 0
    digits.each do |val|
      raise "Negative numbers not allowed" if val < 0
      d += val
    end
    d
  end

  def digits
    self.sub!("\n", delimiter)
    self.split(delimiter).map(&:to_i)
  end

  def delimiter
    if self.start_with?("//")
      @delimiter ||= self[2]
    else
      ","
    end
  end
end
