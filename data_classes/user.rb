require_relative "../QuestionsDatabase.rb"

class User
   attr_accessor :id, :fname, :lname
   def initialize(options)
      @id = options["id"]
      @fname = options["fname"]
      @lname = options["lname"]
   end

   def self.find_by_id(id)
      user = QuestionsDatabase.instance.execute(<<-SQL, id)
         SELECT
            *
         FROM
            users
         WHERE
            id = ?
      SQL
      return nil unless user.length > 0
      User.new(user.first) # query returns array of hashes
   end

   
end