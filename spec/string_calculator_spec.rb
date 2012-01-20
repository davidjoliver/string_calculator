require 'string_calculator'

RSpec::Matchers.define :add_up_to do |expected|
  match do |string_value|
    (@result = string_value.extend(StringCalculator).add) == expected
  end
end

describe StringCalculator, "#add" do

  context do
    before(:each) do
      @str = String.new.extend(StringCalculator)
    end

    it 'respects that strings are mutable' do
      @str.add
      mutated = (@str.clone << '42')
      @str.add.should_not eq mutated.add
    end
  end

  context "single number" do
    it "returns zero for an empty string" do
      "".should add_up_to(0)
    end

    it "returns a single number" do
      "1".should add_up_to(1)
    end

    it "returns a two digit number" do
      "22".should add_up_to(22)
    end
  end

  context "2 numbers" do
    it "adds two single digit numbers" do
      "7,8".should add_up_to(15)
    end

    it "adds two double digit numbers" do
      "12,13".should add_up_to(25)
    end

    it "can add 100 digit numbers" do
      ("2"*100 + "," + "3"*100).should add_up_to(5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555)
    end
  end

  context "unknown number of numbers" do
    it "can add three numbers together" do
      "2,3,4".should add_up_to(9)
    end

    it "can handle three multiple-digit numbers" do
      "12,3,444".should add_up_to(459)
    end

    it "can handle 15 numbers" do
      ("12,"*15).should add_up_to(180)
    end
  end


  context "delimiters" do
    it "can use newline as a delimiter" do
      "1\n2".should add_up_to(3)
    end

    it "can use newline and comma" do
      "1\n2,3".should add_up_to(6)
    end

    it "can customize the delimiter" do
      "//|\n1|2|3".should add_up_to(6)
    end
  end

  context "negative numbers" do
    it "disallows a single negative number" do
      lambda {"-1".extend(StringCalculator).add}.should raise_error("Negative numbers not allowed")
    end

    it "disallows multiple negative numbers" do
      lambda {"-1, -2".extend(StringCalculator).add}.should raise_error("Negative numbers not allowed")
    end

    it "disallows mixed signed numbers" do
      lambda {"-1, 4".extend(StringCalculator).add}.should raise_error("Negative numbers not allowed")
    end

    it "more disallowing of mixed signed numbers" do
      lambda {"1, 4, 5, 100, 23, 456, -9, 88".extend(StringCalculator).add}.should raise_error("Negative numbers not allowed")
    end
  end
end
