class Student

  attr_accessor :id, :name, :grade

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
    select * from students
    SQL
    all_rows = DB[:conn].execute(sql)
    all_rows.map{|row| self.new_from_db(row)}
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    select * from students where students.name = name
    SQL
    row = DB[:conn].execute(sql)[0]
    self.new_from_db(row)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade integer
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = "select * from students where grade = 9"
    selected_students = DB[:conn].execute(sql)
    selected_students.map{|student| self.new_from_db(student)}
  end

  def self.students_below_12th_grade
    sql = "select * from students where grade < 12"
    selected_students = DB[:conn].execute(sql)
    selected_students.map{|student| self.new_from_db(student)}
  end

  def self.first_X_students_in_grade_10(n)
    sql = <<-SQL
    select * from students where grade = 10 limit ?
    SQL
    selected_students = DB[:conn].execute(sql, n)
    selected_students.map{|student| self.new_from_db(student)}
  end

  def self.first_student_in_grade_10
    sql = "select * from students where grade = 10 limit 1"
    selected_student = DB[:conn].execute(sql)[0]
    self.new_from_db(selected_student)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    select * from students where grade = ?
    SQL
    selected_students = DB[:conn].execute(sql, grade)
    selected_students.map{|student| self.new_from_db(student)}
  end
end
