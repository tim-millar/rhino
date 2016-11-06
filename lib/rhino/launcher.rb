module Rhino
  class Launcher
    def initialize(port, bind, reuseaddr, backlog, config)
      @port = port
      @bind = bind
      @reuseaddr = reuseaddr
      @backlog = backlog
      @config = config
    end

    def run
      log_run

      begin
        socket.setsocket(:SOL_SOCKET, :SO_REUSEADDR, @reuseaddr)
        socket.bind(addrinfo)
        socket.listen(@backlog)

        server = Server.new(application, [socket])
        server.run
      end
    end

    private

    def log_run
      Logger.log('Rhino')
      Logger.log("#{@bind}:#{@port}")
    end

    def socket
      Socket.new(:INET, :STREAM)
    end

    def application
      eval(builder, nil, @config)
    end

    def addrinfo
      Addrinfo.tcp(@bind, @port)
    end

    def raw
      File.read(@config)
    end

    def builder
      <<~BUILDER
      Rack::Builder.new do
        #{raw}
      end
      BUILDER
    end
  end
end
