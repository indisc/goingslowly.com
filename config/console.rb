require './lib/goingslowly'
require 'logger'
require 'benchmark'
include GS
DB.logger = Logger.new($stdout)

def quick(repetitions=100, &block)
  Benchmark.bmbm do |b|
    b.report {repetitions.times &block}
  end
  nil
end
