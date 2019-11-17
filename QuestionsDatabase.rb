require 'sqlite3'
require 'singleton'
require_relative "data_classes/user.rb"
require_relative "data_classes/question.rb"
require_relative "data_classes/question_follow.rb"
require_relative "data_classes/question_like.rb"
require_relative "data_classes/reply.rb"

class QuestionsDatabase < SQLite3::Database
   include Singleton

   def initialize
      super('questions.db')
      self.type_translation = true
      self.results_as_hash = true
   end
end