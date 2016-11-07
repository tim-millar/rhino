require 'spec_helper'

module Rhino
  describe Server do
    subject(:server) { Server.new(application, sockets) }
    let(:application) { double('Application') }
    let(:sockets) { [socket] }
    let(:socket) { double('Socket', close: nil) }

    describe '#run' do
      it 'handles interrupt' do
        expect(server).to receive(:monitor).and_raise(Interrupt)
        expect(Logger).to receive(:log).with('INTERRUPTED')
        server.run
      end
    end

    describe '#monitor' do
      let(:io) { double('IO', accept: socket) }
      let(:http) { double('HTTP', handle: nil) }

      before do
        allow(IO).to receive(:select).with(sockets).and_return([[io]])
        allow(HTTP).to receive(:new).with(socket, application).and_return(http)
      end

      it 'selects then accepts and handles a connection' do
        expect(http).to receive(:handle)

        server.monitor
      end
    end
  end
end
