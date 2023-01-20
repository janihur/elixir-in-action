# https://www.mathisfun.com
defmodule Fraction do
  defstruct a: nil, b: nil

  # a = numerator
  # b = denominator (have to non-zero)
  def new(a, b) do
    %Fraction{a: a, b: b}
  end

  def value(fraction) do
    fraction.a / fraction.b
  end

  # another way to implement value()
  def value2(%Fraction{a: a, b: b}) do
    a / b
  end

  def add(fraction1, fraction2) do
    new(
      (fraction1.a) * fraction2.b + (fraction1.b * fraction2.a),
      fraction1.b * fraction2.b
    )
  end

  def sub(fraction1, fraction2) do
    f1 = new(
      fraction1.a * fraction2.b,
      fraction1.b * fraction2.b
    )
    f2 = new(
      fraction2.a * fraction1.b,
      fraction2.b * fraction1.b
    )
    new(
      f1.a - f2.a,
      f1.b
    )
  end
end
