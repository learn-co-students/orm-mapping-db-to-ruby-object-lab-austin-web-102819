class Student
  attr_accessor :name, :grade, :id

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    # binding.pry
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
    # binding.pry
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
                  SELECT id, name, grade FROM students;
                SQL
    # sql = DB[:conn].prepare(statement)
    row = DB[:conn].execute(sql)

    row.map do |r|
      self.new_from_db(r)
    end

  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    # DB[:conn].results_as_hash = true
    sql = <<-SQL
                  SELECT 
                    id, name, grade 
                  FROM students
                  WHERE NAME = ?;
                SQL
    # sql = DB[:conn].prepare(statement)
    # sql.bind_param 1, name
    rs = DB[:conn].execute(sql, name)
    student = self.new_from_db(rs.flatten)
    binding.pry
    student
  end

  def self.all_students_in_grade_X(grade)
    DB[:conn].results_as_hash = true
    sql = <<-SQL
                  SELECT 
                    id, name, grade 
                  FROM students
                  WHERE grade = ?;
                SQL
    # sql = DB[:conn].prepare(statement)
    # sql.bind_param 1, grade
    row = DB[:conn].execute(sql, grade)
    
    arr = []
    row.map do |r|
      arr << r
    end
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
                  SELECT 
                    id, name, grade 
                  FROM students
                  WHERE grade = 9;
                SQL
    # sql = DB[:conn].prepare(statement)
    row = DB[:conn].execute(sql)

    arr = []
    row.map do |r|
      arr << r
    end
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
                  SELECT 
                    id, name, grade 
                  FROM students
                  WHERE grade = 12;
                SQL
    # sql = DB[:conn].prepare(statement)
    row = DB[:conn].execute(sql)

    arr = []
    row.map do |r|
      arr << r
    end
    arr[1]
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
                  SELECT 
                    id, name, grade 
                  FROM students
                  WHERE grade = 10
                  LIMIT ?;
                SQL
    # sql = DB[:conn].prepare(statement)
    row = DB[:conn].execute(sql, x)

    arr = []
    row.map do |r|
      arr << r
    end
    arr
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
