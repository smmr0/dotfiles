require 'pp'

module PrintStatementsReturnNil
  def p(*_ojbs)
    super
    nil
  end

  def pp(*_objs)
    super
    nil
  end
end
Kernel.prepend PrintStatementsReturnNil
Object.prepend PrintStatementsReturnNil
