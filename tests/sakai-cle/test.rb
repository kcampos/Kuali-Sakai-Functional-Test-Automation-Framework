class Goof # Superclass
  #Only this class manipulates the class variable @@classes
  def instantiate_class(key)
    eval(@@classes[key]).new  # This is now problematic because the @@classes variable is not defined outside a method.
    
  end

  def do_this_thing  # This method needs to be used by all sub classes.
    puts "Doing it."
    instantiate_class(:this)
  end
  
  def do_other_thing
      puts "Get funky!"
      instantiate_class(:other)
  end

  def set_hash(hash_object)  # This was Abe's idea for the method.
    @@classes = hash_object
  end

end

class Mofo < Goof # Sub Class 1
  
  def initialize
    #@@classes = {:this=>"Mofo"}
    set_hash ({:this=>"Mofo", :other=>"MasterFun"})
  end
  
end

class Seefeel < Goof # Sub Class 2
  
  def initialize
    set_hash( {:this=>"Seefeel", :other=>"Funkadelic"} )
  end
  
end

class MasterFun < Goof

end

class Funkadelic < Goof

end

fun = Seefeel.new

goo = fun.do_other_thing

puts goo.class
