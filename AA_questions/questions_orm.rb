require_relative 'base_orm.rb'

class Question 
  attr_accessor :id, :title, :body, :user_id 
  
  def self.all 
    data = QuestionsDatabase.instance.execute ("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_id(search_id)
    data = QuestionsDatabase.instance.execute <<-SQL, search_id
      SELECT * 
      FROM questions
      WHERE
        id = ?
      SQL
    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_title(search_title)
    data = QuestionsDatabase.instance.execute <<-SQL, search_title
      SELECT * 
      FROM questions
      WHERE
        title like ?
      SQL
    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_author_id(search_author_id)
    data = QuestionsDatabase.instance.execute <<-SQL, search_author_id
      SELECT * 
      FROM questions
      WHERE
        user_id = ?
      SQL
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
  end

  def author
    User.find_by_id(self.user_id)
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollows.followers_for_question_id(self.id)
  end

end
