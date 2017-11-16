class Operation
  attr_reader :state
  def initialize
    @state = OperationOpenState.new
  end

  def trigger(state)
    @state = @state.next(state)
  end

  def do_some_stuff
    @state.do_some_stuff
  end
end

class StateBase
  def do_some_stuff
    puts "I'm doing nothing yet"
  end
end

class OperationOpenState < StateBase
  def next(state)
    if valid?(state)
      OperationPendingPaymentState.new
    else
      raise IllegalStateJumpError
    end
  end
  
  def do_some_stuff
    puts "I'm here to server u"
  end

  def valid?(state)
    state == :pending_payment
  end
end

class OperationPendingPaymentState
  def next(state)
    OperationConfirmState.new if valid?(state)
  end

  def do_some_stuff
    puts "Thanl you, it's appreciated"
  end

  def valid?(state)
    state == :confirm
  end
end
class IllegalStateJumpError < StandardError; end
class OperationConfirmState; 
  def do_some_stuff
    puts "Haha, dummy i didn't do anything and u paid"
  end
end

#Usage
operation = Operation.new
puts operation.state.class
#=> OperationOpenState
puts operation.do_some_stuff
operation.trigger :pending_payment
puts operation.state.class
#=> OperationPendingPaymentState
puts operation.do_some_stuff
operation.trigger :confirm
puts operation.state.class
#=> OperationConfirmState
puts operation.do_some_stuff

operation = Operation.new
operation.trigger :confirm
#=> raise IllegalStateJumpError