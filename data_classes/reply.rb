require_relative "../QuestionsDatabase.rb"

class Reply
   attr_accessor :id, :fname, :lname
   def initialize(options)
      @id = options["id"]
      @subject_question_id = options["subject_question_id"]
      @author_id = options["author_id"]
      @body = options["body"]
      @parent_id = options["parent_id"]
   end

   def self.find_by_id(id)
      reply = QuestionsDatabase.instance.execute(<<-SQL, id)
         SELECT
            *
         FROM
            replies
         WHERE
            id = ?
      SQL
      return nil unless reply.length > 0
      Reply.new(reply.first) # query returns array of hashes
   end

   
end
