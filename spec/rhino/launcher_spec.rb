require 'spec_helper'

module Rhino
  describe Launcher do
    subject(:launcher) { Launcher.new(port, bind, reuseaddr, backlog, config) }
    let(:config) { './spec/support/config.ru' }
    let(:socket) { double('Socket') }
    let(:addrinfo) { double('Addrinfo') }
    let(:server) { double('Server') }
    let(:raw) { double('IO') }
    let(:port) { 8000 }
    let(:bind) { '0.0.0.0' }
    let(:reuseaddr) { true }
    let(:backlog) { 64 }

    describe '#run' do
      before do
        allow(Logger).to receive(:log).once.with('Rhino')
        allow(Logger).to receive(:log).once.with("#{bind}:#{port}")
        allow(Socket).to receive(:new).with(:INET, :STREAM).and_return(socket)
        allow(socket).to receive(:setsocket).
          with(:SOL_SOCKET, :SO_REUSEADDR, reuseaddr)
        allow(Addrinfo).to receive(:tcp).with(bind, port).and_return(addrinfo)
        allow(socket).to receive(:bind).with(addrinfo)
        allow(socket).to receive(:listen).with(backlog)
        allow(Server).to receive(:new).and_return(server) # !!!
        allow(File).to receive(:read).with(config).and_return(raw)
      end

      it 'configures a socket and proxies to a server' do
        expect(server).to receive(:run)
        launcher.run
      end
    end
  end
end
