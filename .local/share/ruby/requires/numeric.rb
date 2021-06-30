class Integer
  alias old_inspect inspect
  def inspect(*args, **opts)
    if respond_to?(:digits) || args.empty? || opts.empty?
      digits(1000).reverse.join('_')
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
