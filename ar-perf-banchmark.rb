require "benchmark/ips"
require "benchmark/memory"

class ActiveUser
  include ActiveModel::Model
  attr_accessor :a, :b, :c, :d, :e
end

class ActiveAttributesUser
  include ActiveModel::Model
  include ActiveModel::Attributes
  %i[a b c d e].each { attribute _1 }
end

StructUser = Struct.new(:a, :b, :c, :d, :e, keyword_init: true)

Benchmark.ips do |x|
  x.report("struct") { StructUser.new(a: 1, b: 2, c: 3, d: 4, e: 6) }
  x.report("active model api") { ActiveUser.new(a: 1, b: 2, c: 3, d: 4, e: 5) }
  x.report("w/attributes") { ActiveAttributesUser.new(a: 1, b: 2, c: 3, d: 4, e: 5) }
  x.compare!
end

Benchmark.memory do |x|
  x.report("struct") { StructUser.new(a: 1, b: 2, c: 3, d: 4, e: 5) }
  x.report("active model api") { ActiveUser.new(a: 1, b: 2, c: 3, d: 4, e: 5) }
  x.report("w/attributes") { ActiveAttributesUser.new(a: 1, b: 2, c: 3, d: 4, e: 5) }
  x.compare!
end
