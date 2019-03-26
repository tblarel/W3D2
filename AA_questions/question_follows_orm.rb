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

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
  end

  

end
