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
        @previous << @@node[node_name] if !node_name.empty? and @@node[node_name] and !@previous.include? @@node[node_name] 
	begin
	@@node[node_name].following << self unless @@node[node_name].following.include? self
	rescue 
          puts "#{node_name} not found."
        end
      end
    end

    def dump()
      output = Hash.new
      @following.each do |node|
        output[node] = "    #{self.name} [label=\"{#{@sooner_time} | #{@name} | #{@duration} | #{@last_time}}\"];\n"
        output[node] << "    #{self.name} -> #{node.name};\n"
	output.merge(node.dump)
 
      end
      output
    end

   def self.dump
      lines = Hash.new
      ouput = <<-DIDIGRAPH
        digraph {
	    rankdir=LR;
	    node [shape=record style=rounded]

           #{@@first_node.dump.values.inspect }"
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
         begin
           (a.sooner_time || 0 ) + a.duration > b ? 
	   a.sooner_time + a.duration : 
	   b 
         rescue
           0
         end
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
