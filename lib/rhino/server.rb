module Rhino
  class Server
    def initialize(application, sockets)
      @application = application
      @sockets = sockets
    end

    def run
      loop do
        begin
          monitor
        rescue Interrupt
          Logger.log('INTERRUPTED')
          return
        end
      end
    end

    def monitor
      begin
        http.handle
      ensure
        socket.close
      end
    end

    private

    def selections
      IO.select(@sockets).first
    end

    def io
      selections.first
    end

    def socket
      io.accept
    end

    def http
      HTTP.new(socket, @application)
    end
  end
end
