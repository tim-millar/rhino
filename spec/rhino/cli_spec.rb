require 'spec_helper'

module Rhino
  describe CLI do
    subject(:cli) { CLI.new }

    let(:launcher) { double('Launcher', run: nil) }

    before do
      allow(Launcher).to receive(:new)
        .with(4000, '0.0.0.0', true, 16, './config.ru')
        .and_return(launcher)
    end

    describe '#parse' do
      let(:debug) {
        <<~DEBUG
          usage: rhino [options] [./config.ru]
              -h, --help     help
              -v, --version  version
              -b, --bind     bind (default: 0.0.0.0)
              -p, --port     port (default: 5000)
              --backlog      backlog (default: 64)
              --reuseaddr    reuseaddr (default: true)
        DEBUG
      }

      %w(-h --help).each do |option|
        it "supports '#{option}' option" do
          expect(Rhino.logger).to receive(:log).with(debug)
          cli.parse([option])
        end
      end

      %w(-v --version).each do |option|
        it "supports '#{option}' option" do
          expect(Rhino.logger).to receive(:log).with(Rhino::VERSION)
          cli.parse([option])
        end
      end

      it 'builds a lanucher and executes run' do
        expect(launcher).to receive(:run)
        cli.parse(["--port", "4000", "--bind", "0.0.0.0", "--backlog", "16"])
      end
    end
  end
end
