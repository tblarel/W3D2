require_relative 'users_orm'
require_relative 'questions_orm'

class QuestionLike
  attr_accessor :user_id, :question_id

  def self.all
    data = QuestionsDatabase.instance.execute ("SELECT * FROM question_likes")
    data.map { |datum| QuestionLike.new(datum) }
  end

  def self.likers_for_question_id(search_question_id)
    data = QuestionsDatabase.instance.execute <<-SQL, search_question_id
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users on question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL
    data.map { |datum| User.new(datum) }
  end

  def self.num_likes_for_question_id(search_question_id)
    data = QuestionsDatabase.instance.execute <<-SQL, search_question_id
      SELECT
        questions.*, COUNT(question_likes.user_id) AS num_likes
      FROM
        question_likes
      JOIN
        questions ON questions.id = question_likes.question_id
      WHERE
        question_likes.question_id = ?
      GROUP BY
        question_likes.question_id
    SQL
    data.map { |datum| [ Question.new(datum), datum["num_likes"] ] }
  end

  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute <<-SQL, n
      SELECT
        COUNT(user_id) AS num_likes 
      FROM
        question_likes
      GROUP BY
        question_id
      ORDER BY
        count(user_id) DESC
      LIMIT 
        ?
    SQL
    data
  end

  def initialize(options)
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end

  def self.liked_questions_for_user_id(user_id)
  end
end