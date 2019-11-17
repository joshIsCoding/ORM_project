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

   def self.find_by_author_id(author_id)
      authors_questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
         SELECT
            *
         FROM
            questions
         WHERE
            author_id = ?
      SQL
      return nil unless authors_questions.length > 0
      authors_questions.map{ |author_qu| Question.new(author_qu) }
   end

   def author
      author = QuestionsDatabase.instance.execute(<<-SQL, author_id)
         SELECT
            *
         FROM
            users
         WHERE
            id = ?
      SQL
      User.new(author.first)
   end

   
end
