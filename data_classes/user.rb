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

   def self.find_by_name(fname, lname)
      user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
         SELECT
            *
         FROM
            users
         WHERE
            (fname = ? 
               AND lname = ?)
      SQL
      return nil unless user.length > 0
      User.new(user.first) # query returns array of hashes
   end

   def save
      if id
         QuestionsDatabase.instance.execute(<<-SQL, id: self.id, fname: self.fname, lname: self.lname)
            UPDATE
               users
            SET
               fname = :fname, lname = :lname
            WHERE
               id = :id
         SQL
      else
         QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
            INSERT INTO
               users(fname, lname)
            VALUES
               (?, ?)
         SQL
         id = QuestionsDatabase.instance.last_insert_row_id   
      end
   end

   def authored_questions
      Question.find_by_author_id(id)
   end

   def authored_replies
      Reply.find_by_author_id(id)
   end

   def followed_questions
      QuestionFollow.followed_questions_for_user_id(id)
   end

   def average_karma
      QuestionsDatabase.instance.execute(<<-SQL, id)
         SELECT
           ( COUNT(DISTINCT(questions.id)) / CAST ( COUNT(question_likes.id) AS FLOAT ) )
         FROM
            questions
         LEFT OUTER JOIN
            question_likes ON questions.id = question_likes.question_id
         WHERE
            questions.author_id = ?
      SQL
   end

   
end
