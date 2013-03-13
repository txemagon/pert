module Pert

  class Node

    @@first_node = nil
    @@last_node = nil
    @@node = Hash.new

    attr_accessor :name, :sooner_time, :last_time, :following, :duration, :previous

    def initialize(name, duration=0, previous=[])
      @previous  = []
      @following = []
  
      if !@@first_node
        @@first_node = true
        @@first_node = Node.new("START")
 	@@last_node  = Node.new("END")
      end
      @name, @duration = name.upcase, duration.to_i

      @@node[name] = self
      previous.each do |node_name|
        node_name = "START" if node_name == '-'
        @previous << @@node[node_name] if !node_name.empty? and @@node[node_name]
	begin
	@@node[node_name].following << self
	rescue 
          puts "#{node_name} not found."
        end
      end
    end

    def dump
      output = ""
      @following.each do |node|
        output << "    #{self.name} [label=\"{#{@sooner_time} | #{@name} | #{@duration} | #{@last_time}}\"];\n"
        output << "    #{self.name} -> #{node.name};\n"
	output << node.dump
      end
      output
    end

   def self.dump
      ouput = <<-DIDIGRAPH
        digraph {
	    rankdir=LR;
	    node [shape=record style=rounded]

           #{@@first_node.dump }
	}
      DIDIGRAPH
    end

    def to_s
      "#{@name}, [#{(@previous.collect {|p| p.name}).join(', ')}], [#{(@following.collect {|p| p.name}).join(', ')}] #{@duration.to_s} "
    end

    def forward_process
      if @name != "END" and @following.empty?
        @following << @@last_node 
	@@last_node.previous << self
      end
      @sooner_time = @previous.inject(0) do |b,a| 
         (a.sooner_time || 0 ) + a.duration > b ? 
	 a.sooner_time + a.duration : 
	 b 
      end
      unless @following.empty?
        @following.each { |f| f.forward_process }
      end
      @sooner_time
    end
     
    def backward_process
      if !@following or @following.empty? or @name == "END"
        @last_time = @sooner_time || 0
	@following = []
      else
        @last_time = @following.inject(@following[0].last_time) do |b,a| 
	  begin
	  a.last_time - a.duration < b ? 
	    a.last_time - a.duration : 
	    b 
	  rescue
	     @@last_node.last_time
	   end
	end
      end
      unless @previous.empty?
        @previous.each { |p| p.backward_process }
      end
      @last_time
    end

    def self.process
      @@first_node.forward_process
      @@last_node.backward_process
    end

  end
end
