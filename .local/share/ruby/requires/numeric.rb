class Integer
  alias old_inspect inspect
  def inspect(*args, **opts)
    if respond_to?(:digits) || args.empty? || opts.empty?
      groups = abs.digits(1000).reverse
      padded_groups = [(positive? ? groups.first : groups.first * -1).to_s]
      groups.drop(1).each do |group|
        padded_groups << group.to_s.rjust(3, '0')
      end
      padded_groups.join('_')
    else
      old_inspect(*args, **opts)
    end
  end
end

class Float
  alias old_inspect inspect
  def inspect(*args, **opts)
    old_inspect(*args, **opts).sub(
      Regexp.new("\\A#{Regexp.escape(to_i.to_s)}(?=\\.|\\z)"),
      to_i.inspect
    )
  end
end
