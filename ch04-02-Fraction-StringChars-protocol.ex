defimpl String.Chars, for: Fraction do
  def to_string(fraction) do
    "#{fraction.a} / #{fraction.b}"
  end
end
