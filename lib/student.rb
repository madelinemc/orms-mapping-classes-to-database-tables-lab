  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize (name, grade, id=nil) #id is set to nil because the table in database will give the id
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table #create the table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table #drop the entire table
    sql = <<-SQL
    DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end

  def save #insert student instance into the students database
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql,self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]  #to get the id of the newly saved Student instance

  end

  def self.create(name:, grade:) #class method that uses keyword arguments to: 
    student = Student.new(name, grade) #1. instantiate new Student 
    student.save #2. save that new Student instance
    student #3. return it
  end
  

end
