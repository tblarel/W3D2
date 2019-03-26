require_relative 'base_orm.rb'
require_relative 'users_orm'
require_relative 'questions_orm'

class QuestionFollows 
  attr_accessor :id, :question_id, :user_id 
  
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
        questions.id, questions.title, questions.body, questions.user_id
      FROM 
        question_follows
      JOIN
        questions ON questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = ?
    SQL
  data.map { |datum| Question.new(datum) }
  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute <<-SQL, n
      SELECT 
        questions.id, questions.title, questions.body, questions.user_id, COUNT(question_follows.user_id) as Total_Followers
      FROM 
        question_follows
      JOIN
        questions ON questions.id = question_follows.question_id
      GROUP BY
        question_follows.question_id
      ORDER BY
        COUNT(question_follows.user_id) desc
      LIMIT
        ?
        
    SQL
    data.map { |datum| [ Question.new(datum), datum['Total_Followers'] ] }
  end

  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end

  

end
