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

   def save
      if id
         QuestionsDatabase.instance.execute(<<-SQL, id: self.id, title: self.title, author_id: self.author_id, body: self.body)
            UPDATE
               questions
            SET
               title = :title, author_id = :author_id, body = :body
            WHERE
               id = :id
         SQL
      else
         QuestionsDatabase.instance.execute(<<-SQL, title: self.title, author_id: self.author_id, body: self.body)
            INSERT INTO
               questions(title, author_id, body)
            VALUES
               (:title, :author_id, :body)
         SQL
         id = QuestionsDatabase.instance.last_insert_row_id   
      end
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

   def replies
      Reply.find_by_subject_question_id(id)
   end

   def followers
      QuestionFollow.followers_for_question_id(id)
   end

   def self.most_followed(n)
      QuestionFollow.most_followed_questions(n)
   end
   
end
