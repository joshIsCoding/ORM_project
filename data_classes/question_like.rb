class QuestionLike
   attr_accessor :id, :user_id, :question_id
   def initialize(options)
      @id = options["id"]
      @user_id = options["user_id"]
      @question_id = options["question_id"]
   end

   def self.find_by_id(id)
      question_like = QuestionsDatabase.instance.execute(<<-SQL, id)
         SELECT
            *
         FROM
            question_likes
         WHERE
            id = ?
      SQL
      return nil unless question_like.length > 0
      QuestionLike.new(question_like.first) # query returns array of hashes
   end

   def self.likers_for_question_id(question_id)
      likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
         SELECT
            users.id, fname, lname
         FROM
            question_likes
         INNER JOIN
            users ON users.id = question_likes.user_id
         WHERE
            question_id = ?

      SQL
      likers.map { |liker| User.new(liker) }
   end

   def self.num_likes_for_question_id(question_id)
      count = QuestionsDatabase.instance.execute(<<-SQL, question_id)
         SELECT
            COUNT(user_id) AS like_count
         FROM
            question_likes
         WHERE
            question_id = ?
      SQL
      count.first["like_count"]
   end
   

   def self.liked_questions_for_user_id(user_id)
      liked_questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
         SELECT
            questions.id, title, body, author_id
         FROM
            question_likes
         INNER JOIN
            questions ON questions.id = question_likes.question_id
         WHERE
            user_id = ?

      SQL
      liked_questions.map { |liked_qu| Question.new(liked_qu) }
   end


   
end
