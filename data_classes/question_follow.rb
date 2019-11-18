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

   def self.followers_for_question_id(question_id)
      followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
         SELECT
            users.id, fname, lname
         FROM
            question_follows
         INNER JOIN
            users ON users.id = question_follows.author_id
         WHERE
            question_id = ?
      SQL

      followers.map { |follower| User.new(follower) }
   end

   def self.followed_questions_for_user_id(user_id)
      followed_questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
         SELECT
            questions.id, title, body, questions.author_id
         FROM
            question_follows
         INNER JOIN
            questions ON questions.id = question_follows.question_id
         WHERE
            question_follows.author_id = ?
      SQL

      followed_questions.map { |qu| Question.new(qu) }
   end

end
