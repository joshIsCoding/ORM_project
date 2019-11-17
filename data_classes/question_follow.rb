require_relative "../QuestionsDatabase.rb"

class QuestionFollow
   attr_accessor :id, :question_id, :author_id
   def initialize(options)
      @id = options["id"]
      @question_id = options["question_id"]
      @author_id = options["author_id"]
   end

   def self.find_by_id(id)
      question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
         SELECT
            *
         FROM
            question_follows
         WHERE
            id = ?
      SQL
      return nil unless question_follow.length > 0
      QuestionFollow.new(question_follow.first) # query returns array of hashes
   end

end
