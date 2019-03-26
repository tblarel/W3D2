require_relative 'base_orm.rb'

class User 
  attr_accessor :id, :fname, :lname 
  
  def self.all 
    data = QuestionsDatabase.instance.execute ("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_id(search_id)
    data = QuestionsDatabase.instance.execute <<-SQL, search_id
      SELECT * 
      FROM users
      WHERE
        id = ?
      SQL
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_name(first_name,last_name)
    data = QuestionsDatabase.instance.execute <<-SQL, first_name , last_name
      SELECT * 
      FROM users
      WHERE
        fname = ?
      AND
        lname = ?
      SQL
    data.map { |datum| User.new(datum) }
  end

  
  def initialize(options)
    @id = options["id"]
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def authored_questions
    Question.find_by_author_id(self.id)
  end
  
  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(self.id)
  end

  def average_karma
    data = QuestionsDatabase.instance.execute <<-SQL, self.id
      SELECT   
        AVG(likes_per_question.num_Likes) AS karma
      FROM
        (SELECT
          question_id, COUNT(user_id) AS num_likes
        FROM
          question_likes
        GROUP BY
          question_id
        ) AS likes_per_question
      LEFT JOIN
        question_likes ON question_likes.question_id = likes_per_question.question_id
      WHERE
        question_likes.user_id = ?
      GROUP BY 
        question_likes.user_id

    SQL
    data.first["karma"]
  end

  def save
    if self.id.nil?
      #insert
      QuestionsDatabase.instance.execute <<-SQL, self.fname, self.lname
        INSERT INTO
          users (fname, lname)
        VALUES
          (?, ?)
      SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute <<-SQL, self.fname, self.lname, self.id
        UPDATE
          users 
        SET
          fname = ?, lname = ?
        WHERE
          id = ?
      SQL
    end      
  end

end
