require_relative "../QuestionsDatabase.rb"

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

   
end
