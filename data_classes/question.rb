require_relative "../QuestionsDatabase.rb"

class Question
   attr_accessor :id, :title, :body, :author_id
   def initialize(options)
      @id = options["id"]
      @title = options["title"]
      @body = options["body"]
      @author_id = options["author_id"]
   end

   def self.find_by_id(id)
      question = QuestionsDatabase.instance.execute(<<-SQL, id)
         SELECT
            *
         FROM
            questions
         WHERE
            id = ?
      SQL
      return nil unless question.length > 0
      Question.new(question.first) # query returns array of hashes
   end

   
end
