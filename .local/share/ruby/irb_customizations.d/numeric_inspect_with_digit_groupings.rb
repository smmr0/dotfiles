require 'rubygems'

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.7')
  module IntegerInspectWithDigitGroupings
    def inspect(*args, **kwargs, &blk)
      if respond_to?(:digits) && args.empty? && kwargs.empty? && !blk
        groups = abs.digits(1000).reverse
        padded_groups = [(positive? ? groups.first : groups.first * -1).to_s]
        groups.drop(1).each do |group|
          padded_groups << group.to_s.rjust(3, '0')
        end
        padded_groups.join('_')
      else
        super
      end
    end
  end
  Integer.prepend IntegerInspectWithDigitGroupings

  module FloatInspectWithDigitGroupings
    def inspect(*_args, **_kwargs, &_blk)
      case self
      when self.class::INFINITY
        super
      else
        super.sub(
          Regexp.new("\\A#{Regexp.escape(to_i.to_s)}(?=\\.|\\z)"),
          to_i.inspect
        )
      end
    end
  end
  Float.prepend FloatInspectWithDigitGroupings
end
