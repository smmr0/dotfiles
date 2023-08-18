require 'pp'

module PrintStatementsReturnNil
  def p(*_args, **_kwargs, &_blk)
    super
    nil
  end

  def pp(*_args, **_kwargs, &_blk)
    super
    nil
  end
end
Kernel.prepend PrintStatementsReturnNil
Object.prepend PrintStatementsReturnNil
