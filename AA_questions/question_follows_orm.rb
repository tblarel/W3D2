require_relative 'base_orm.rb'

class QuestionFollows 
  attr_accessor :id, :title, :body, :user_id 
  
  def self.all 
    data = QuestionsDatabase.instance.execute ("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollows.new(datum) }
  end

  def self.followers_for_question_id(search_question_id)
    data = QuestionsDatabase.instance.execute <<-SQL, search_question_id
      SELECT 
        users.fname, users.lname , user_id
      FROM 
        question_follows
      JOIN
        users ON users.id = question_follows.user_id
      WHERE
        question_follows.question_id = ?
    SQL
  data.map { |datum| User.new(datum) }
  end

  def self.followed_questions_for_user_id(search_user_id)
    data = QuestionsDatabase.instance.execute <<-SQL, search_user_id
      SELECT 
        questions.id, questions.body
      FROM 
        question_follows
      JOIN
        questions ON questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = ?
    SQL
  data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end

  

end
