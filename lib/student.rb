require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade
  attr_reader :id
   



  def initialize(name, grade, id=nil)
    @name = name,
    @grade = grade,
    @id = id
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

  def save
    if self.id
      self.update
    else
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
     #row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", self.name)[0]
     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
     #binding.pry
    end
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL

    DB[:conn].execute(sql)

  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.name = name
    student.grade = grade
    student.save
    #binding.pry
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end

  def self.find_by_name(name)

    sql =  'SELECT * FROM students WHERE name = ? LIMIT 1'

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def update
    sql = <<-SQL
      UPDATE students 
      SET name = ?, grade = ? 
      WHERE id = ? 
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
    #binding.pry
  end


end
