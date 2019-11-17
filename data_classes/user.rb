class User
   attr_accessor :id, :fname, :lname
   def initialize(options)
      @id = options["id"]
      @fname = options["fname"]
      @lname = options["lname"]
   end

   
end
