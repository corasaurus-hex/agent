module Agent
  class Once
    def initialize
      @monitor   = Monitor.new
      @performed = false
    end

    def perform
      # optimium path
      return nil, error if @performed

      # slow path
      @monitor.synchronize do
        # Hold this mutex for the minimum amount of time possible, since mutexes are slow
        return nil, error if @performed
        @performed = true
      end

      return yield, nil
    end

    def performed?
      @performed
    end

  protected

    def error
      @error ||= Agent::Error.new("already performed")
    end

  end
end
