require_relative 'base_orm.rb'

class Reply 
  attr_accessor :id, :question_id, :body, :user_id , :parent_id
  
  def self.all 
    data = QuestionsDatabase.instance.execute ("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_id(search_id)
    data = QuestionsDatabase.instance.execute <<-SQL, search_id
      SELECT * 
      FROM replies
      WHERE
        id = ?
      SQL
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_question_id(search_question_id)
    data = QuestionsDatabase.instance.execute <<-SQL, search_question_id
      SELECT * 
      FROM replies
      WHERE
        question_id = ?
      SQL
    data.map { |datum| Reply.new(datum) }
  end
  
  def self.find_by_user_id(search_user_id)
    data = QuestionsDatabase.instance.execute <<-SQL, search_user_id
      SELECT * 
      FROM replies
      WHERE
        user_id = ?
      SQL
    data.map { |datum| Reply.new(datum) }
  end



  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @parent_id = options['parent_id']
    @body = options["body"]
    @user_id = options["user_id"]
  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def child_replies
    data = QuestionsDatabase.instance.execute <<-SQL, self.id
      SELECT * 
      FROM replies
      WHERE
        parent_id = ?
      SQL
    data.map { |datum| Reply.new(datum) }
  end
end
