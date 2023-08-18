if Object.const_defined?(:Money)
  module MoneyInspectWithFormat
    def inspect(*args, **kwargs, &blk)
      if args.empty? && kwargs.empty? && !blk
        format
      else
        super
      end
    end
  end

  Money.prepend MoneyInspectWithFormat
end
