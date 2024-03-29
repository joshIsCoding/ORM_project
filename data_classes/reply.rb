class Reply
   attr_accessor :id, :subject_question_id, :author_id, :body, :parent_id
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

   def self.find_by_author_id(author_id)
      author_replies = QuestionsDatabase.instance.execute(<<-SQL, author_id)
         SELECT
            *
         FROM
            replies
         WHERE
            author_id = ?
      SQL
      return nil unless author_replies.length > 0
      author_replies.map {|auth_reply| Reply.new(auth_reply) } 
   end

   def self.find_by_subject_question_id(subject_question_id)
      question_replies = QuestionsDatabase.instance.execute(<<-SQL, subject_question_id)
         SELECT
            *
         FROM
            replies
         WHERE
            subject_question_id = ?
      SQL
      return nil unless question_replies.length > 0
      question_replies.map {|qu_reply| Reply.new(qu_reply) } 
   end

   def save
      if id
         QuestionsDatabase.instance.execute(<<-SQL, id: self.id, subject_question_id: self.subject_question_id, author_id: self.author_id, body: self.body, parent_id: self.parent_id)
            UPDATE
               replies
            SET
               subject_question_id = :subject_question_id, author_id = :author_id, body = :body, parent_id = :parent_id
            WHERE
               id = :id
         SQL
      else
         QuestionsDatabase.instance.execute(<<-SQL, subject_question_id: self.subject_question_id, author_id: self.author_id, body: self.body, parent_id: self.parent_id)
            INSERT INTO
               replies(subject_question_id, author_id, body, parent_id)
            VALUES
               (:subject_question_id, :author_id, :body, :parent_id)
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

   def question
      question = QuestionsDatabase.instance.execute(<<-SQL, subject_question_id)
         SELECT
            *
         FROM
            questions
         WHERE
            id = ?
      SQL
      Question.new(question.first)
   end

   def parent_reply
      parent_reply = QuestionsDatabase.instance.execute(<<-SQL, parent_id)
         SELECT
            *
         FROM
            replies
         WHERE
            id = ?
      SQL
      return nil unless parent_reply.length > 0
      Reply.new(parent_reply.first)
   end

   def child_replies
      child_replies = QuestionsDatabase.instance.execute(<<-SQL, id)
         SELECT
            *
         FROM
            replies
         WHERE
            parent_id = ?
      SQL
      return nil unless child_replies.length > 0
      child_replies.map { |child_reply| Reply.new(child_reply) } 
   end
   
end
