module Agent
  class WaitGroup
    class NegativeWaitGroupCount < Exception; end

    attr_reader :count

    def initialize
      @count   = 0
      @monitor = Monitor.new
      @cvar    = @monitor.new_cond
    end

    def wait
      @monitor.synchronize do
        @cvar.wait_while{ @count > 0 }
      end
    end

    def add(delta)
      @monitor.synchronize do
        @count += delta
        raise NegativeWaitGroupCount if @count < 0
        @cvar.signal if @count == 0
      end
    end

    def done
      @monitor.synchronize do
        add(-1)
      end
    end
  end
end
