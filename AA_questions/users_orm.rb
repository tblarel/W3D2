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

  def self.find_by_name(first_name)
    data = QuestionsDatabase.instance.execute <<-SQL, first_name
      SELECT * 
      FROM users
      WHERE
        fname = ?
      SQL
    data.map { |datum| User.new(datum) }
  end

  def initialize(options)
    @id = options["id"]
    @fname = options['fname']
    @lname = options['lname']
  end

end
