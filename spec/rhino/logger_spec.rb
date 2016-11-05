require 'spec_helper'

module Rhino
  describe Logger do
    let(:stream) { double(:stream) }

    describe "#log" do
      let(:logger) { Rhino::Logger.new(stream) }

      it "proxies to stream" do
        expect(stream).to receive(:puts).with("Hello!")
        logger.log("Hello!")
      end
    end
  end
end
