require "pert/version"
require "pert/node"

module Pert

  def self.process 
    Node.process
  end

  def self.load_line(args)
    return if args.empty?
    name = args.shift
    duration = args.pop
    Node.new(name, duration, args)
  end

  def self.print
    puts Node.dump
  end

end
