if Object.const_defined?(:Money)
  module MoneyInspectWithFormat
    def inspect
      format
    end
  end

  Money.prepend MoneyInspectWithFormat
end
