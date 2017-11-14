class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name,grade,id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade INT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name,grade) VALUES (?,?)
    SQL
    DB[:conn].execute(sql,self.name,self.grade)
    new_id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    Student.new(self.name,self.grade,new_id)
  end

  def self.create()
    Student.new(name,grade).save
  end

end
