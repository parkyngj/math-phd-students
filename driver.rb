# User interface file for Math PhD Students Database

require 'sqlite3'
require 'csv'
require 'faker'
require_relative 'students'
require_relative 'advisors'
require_relative 'classes'
require_relative 'grades'
require_relative 'fields'

$database = SQLite3::Database.new("hmps.db")
$database.results_as_hash = true

$database.execute("CREATE TABLE IF NOT EXISTS students(
  id INTEGER PRIMARY KEY,
  last_name VARCHAR(255),
  first_name VARCHAR(255),
  advisor INT,
  field INT,
  gpa FLOAT,
  matriculation_date DATE,
  graduation_date DATE,
  FOREIGN KEY (advisor) REFERENCES advisors(id)
  FOREIGN KEY (field) REFERENCES fields(id)
  )"
)

$database.execute("CREATE TABLE IF NOT EXISTS advisors(
  id INTEGER PRIMARY KEY,
  last_name VARCHAR(255),
  first_name VARCHAR(255),
  field INT,
  FOREIGN KEY (field) REFERENCES fields(id)
  )"
)

$database.execute("CREATE TABLE IF NOT EXISTS classes(
  id INTEGER PRIMARY KEY,
  name VARCHAR(255),
  field INT,
  FOREIGN KEY (field) REFERENCES fields(id)
  )"
)

$database.execute("CREATE TABLE IF NOT EXISTS grades(
  id INTEGER PRIMARY KEY,
  student INT,
  class INT,
  grade FLOAT,
  date_given DATE,
  FOREIGN KEY (student) REFERENCES students(id),
  FOREIGN KEY (class) REFERENCES classes(id)
  )"
)

$database.execute("CREATE TABLE IF NOT EXISTS fields(
  id INTEGER PRIMARY KEY,
  name VARCHAR(255)
  )"
)

# PRE-POPULATE fields TABLE

$database.execute(
  "INSERT INTO fields (name)
  SELECT 'Algebra'
  WHERE NOT EXISTS (SELECT 1 FROM fields WHERE name='Algebra');"
  )

$database.execute(
  "INSERT INTO fields (name)
  SELECT 'Analysis'
  WHERE NOT EXISTS (SELECT 1 FROM fields WHERE name='Analysis');"
  )

$database.execute(
  "INSERT INTO fields (name)
  SELECT 'Applied Math'
  WHERE NOT EXISTS (SELECT 1 FROM fields WHERE name='Applied Math');"
  )

$database.execute(
  "INSERT INTO fields (name)
  SELECT 'Logic'
  WHERE NOT EXISTS (SELECT 1 FROM fields WHERE name='Logic');"
  )

$database.execute(
  "INSERT INTO fields (name)
  SELECT 'Topology'
  WHERE NOT EXISTS (SELECT 1 FROM fields WHERE name='Topology');"
  )

# PRE-POPULATE advisors TABLE

$database.execute(
  "INSERT INTO advisors (last_name, first_name, field)
  SELECT 'Blanda', 'Adrienne', 1
  WHERE NOT EXISTS (SELECT 1 FROM advisors WHERE last_name='Blanda' AND first_name='Adrienne' AND field='1');
  "
  )

$database.execute(
  "INSERT INTO advisors (last_name, first_name, field)
  SELECT 'Kassulke', 'Grant', 2
  WHERE NOT EXISTS (SELECT 1 FROM advisors WHERE last_name='Kassulke' AND first_name='Grant' AND field='2');
  "
  )

$database.execute(
  "INSERT INTO advisors (last_name, first_name, field)
  SELECT 'Mertz', 'Damaris', 3
  WHERE NOT EXISTS (SELECT 1 FROM advisors WHERE last_name='Mertz' AND first_name='Damaris' AND field='3');
  "
  )

$database.execute(
  "INSERT INTO advisors (last_name, first_name, field)
  SELECT 'Ratke', 'Jerad', 4
  WHERE NOT EXISTS (SELECT 1 FROM advisors WHERE last_name='Ratke' AND first_name='Jerad' AND field='4');
  "
  )

$database.execute(
  "INSERT INTO advisors (last_name, first_name, field)
  SELECT 'Robel', 'Stephan', 5
  WHERE NOT EXISTS (SELECT 1 FROM advisors WHERE last_name='Robel' AND first_name='Stephan' AND field='5');
  "
  )

# PRE-POPULATE classes TABLE

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Groups, Rings, Fields', 1
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Groups, Rings, Fields' AND field='1');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Homological Algebra', 1
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Homological Algebra' AND field='1');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Algebraic Geometry', 1
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Algebraic Geometry' AND field='1');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Measure Theory', 2
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Measure Theory' AND field='2');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Harmonic Analysis', 2
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Harmonic Analysis' AND field='2');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Differentiable Manifolds', 2
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Differentiable Manifolds' AND field='2');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Differential Equations', 3
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Differential Equations' AND field='3');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Stochastic Processes', 3
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Stochastic Processes' AND field='3');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Numerical Analysis', 3
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Numerical Analysis' AND field='3');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Riemannian Geometry', 4
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Riemannian Geometry' AND field='4');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Complex Geometry', 4
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Complex Geometry' AND field='4');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Symplectic Geometry', 4
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Symplectic Geometry' AND field='4');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Metamathematics', 5
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Metamathematics' AND field='5');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Recursion Theory', 5
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Recursion Theory' AND field='5');
  "
  )

$database.execute(
  "INSERT INTO classes (name, field)
  SELECT 'Model Theory', 5
  WHERE NOT EXISTS (SELECT 1 FROM classes WHERE name='Model Theory' AND field='5');
  "
  )

# triggers

# trigger to automatically set graduation date after student has taken 8 classes

$database.execute(
  "CREATE TRIGGER IF NOT EXISTS set_grad_date AFTER INSERT ON grades
  WHEN 8=(SELECT count(*) FROM grades WHERE student=(SELECT student FROM grades WHERE id=(select max(id) from grades)))
  BEGIN
    UPDATE students SET graduation_date=(SELECT date_given FROM grades WHERE id=(select max(id) FROM grades)) WHERE id=(SELECT student FROM grades WHERE id=(SELECT max(id) FROM grades));
  END;
  "
  )

# trigger to automatically calculate a student's gpa after a student takes a class

$database.execute(
  "CREATE TRIGGER IF NOT EXISTS gpa_calc AFTER INSERT ON grades
  BEGIN
    UPDATE students
    SET gpa=(SELECT sum(grade) FROM grades total WHERE student=(SELECT student FROM grades WHERE id=(SELECT max(id) FROM grades)))/(SELECT count(*) FROM grades WHERE student=(SELECT STUDENT FROM grades WHERE id=(SELECT max(id) FROM grades)))
    WHERE id=(SELECT STUDENT FROM grades WHERE id=(SELECT max(id) FROM grades));
  END;
  "
  )

puts "Welcome to Hackett U's Math PhD Students Database.
Please access the README file at the GitHub repo for this database (https://github.com/parkyngj/hackett-math-phd-students).
NOTE: All inputs are case insensitive."

def ui_generate_data
  puts "How many random students would you like to generate?"
  student_generate_num_input = gets.chomp.to_i

  student_generate_num_input.times {
    ln = Faker::Name.last_name
    fn = Faker::Name.first_name
    randid = rand(1..5)
    add_student(ln, fn, randid, randid)
  }

  puts "Do you want to generate some random grades for these students? (y/n)"
  grades_generate_response = gets.chomp

  if grades_generate_response == "y"
    student_generate_num_input.times do |i|
      num_grades = rand(1..8)
      num_grades.times do |idx|
        random_class = rand(1..15)
        random_grade = rand(0..4)
        add_grade(i+1, random_class, random_grade)
      end
    end
  end

  ui_main_menu
end

def ui_main_menu
puts "What would you like to do? (Type one of the choices below.)
\tView Entries
\tAdd Entries
\tGenerate Student Data
\tLeave"

main_menu_input = gets.chomp.downcase

  if main_menu_input == "view entries"
    ui_view_entries
  elsif main_menu_input == "add entries"
    ui_add_entries
  elsif main_menu_input == "generate student data"
    ui_generate_data
  else
    exit
  end
end

def ui_view_entries
puts "From which table would you like to view entries from? (Type one of the choices below.)
\tAdvisors
\tClasses
\tGrades
\tFields
\tStudents
\tBack to Main Menu"

view_entries_input = gets.chomp.downcase

  if view_entries_input == "advisors"
    ui_view_advisors
  elsif view_entries_input == "classes"
    ui_view_classes
  elsif view_entries_input == "grades"
    ui_view_grades
  elsif view_entries_input == "fields"
    ui_view_fields
  elsif view_entries_input == "students"
    ui_view_students
  else
    ui_main_menu
  end
end

def ui_view_advisors
puts "Which entries would you like to view from the advisors table? (Type one of the choices below.)
\tAll entries
\tSearch by Specialty
\tBack to Entry Viewer Menu
\tBack to Main Menu"

view_advisors_input = gets.chomp.downcase

  if view_advisors_input == "all entries"
    view_advisors
    ui_view_advisors
  elsif view_advisors_input == "search by specialty"
    puts "Enter the ID of the field you wish to select advisors by:"
    search_advisors_by_field_input = gets.chomp.to_i
    search_advisors_by_field(search_advisors_by_field_input)
    ui_view_advisors
  elsif view_advisors_input == "back to entry viewer menu"
    ui_view_entries
  else
    ui_main_menu
  end
end

def ui_view_students
puts "Which entries would you like to view from the students table? (Type one of the choices below.)
\tAll entries
\tSearch by ID
\tSearch by Name
\tSearch by Specialty
\tSearch by Advisor
\tBack to Entry Viewer Menu
\tBack to Main Menu"

view_students_input = gets.chomp.downcase

  if view_students_input == "all entries"
    view_students
    ui_view_students
  elsif view_students_input == "search by id"
    puts "Enter the ID of the student you wish to view:"
    search_student_by_id_input = gets.chomp.to_i
    search_student_by_id(search_student_by_id_input)
    ui_view_students
  elsif view_students_input == "search by name"
    puts "Enter the last name of the student you wish to view:"
    search_student_by_name_ln = gets.chomp
    puts "Enter the first name of the student you wish to view:"
    search_students_by_name_fn = gets.chomp
    search_students_by_name(search_student_by_name_ln,search_students_by_name_fn)
    ui_view_students
  elsif view_students_input == "search by specialty"
    puts "Enter the ID of the field you wish to select students by:"
    search_students_by_field_input = gets.chomp.to_i
    search_students_by_field(search_students_by_field_input)
    ui_view_students
  elsif view_students_input == "search by advisor"
    puts "Enter the ID of the advisor you wish to select students by:"
    search_students_by_advisor_input = gets.chomp.to_i
    search_students_by_advisor(search_students_by_advisor_input)
    ui_view_students
  elsif view_students_input == "back to entry viewer menu"
    ui_view_entries
  else
    ui_main_menu
  end
end

def ui_view_grades
puts "Which entries would you like to view from the grades table? (Type one of the choices below.)
\tAll entries
\tSearch by Student
\tSearch by Class
\tBack to Entry Viewer Menu
\tBack to Main Menu"

view_grades_input = gets.chomp.downcase

  if view_grades_input == "all entries"
    view_grades 
    ui_view_grades
  elsif view_grades_input == "search by student"
    puts "Enter the ID of the student you wish to view the grades of:"
    search_grades_of_student_by_id_input = gets.chomp.to_i
    view_student_grades(search_grades_of_student_by_id_input)
    ui_view_grades
  elsif view_grades_input == "search by class"
    puts "Enter the ID of the class you wish to view the grades of:"
    search_grades_by_class_id_input = gets.chomp.to_i
    search_grades_by_class(search_grades_by_class_id_input)
    ui_view_grades
  elsif view_grades_input == "back to entry viewer menu"
    ui_view_entries
  else
    ui_main_menu
  end
end

def ui_view_fields
  view_fields 
  ui_view_entries
end

def ui_view_classes
  view_classes 
  ui_view_entries
end

def ui_add_entries
puts "For which table would you like to add entries to? (Type one of the choices below.)
\tAdvisors
\tClasses
\tGrades
\tStudents
\tBack to Main Menu"

add_entries_input = gets.chomp

  if add_entries_input == "advisors"
    ui_add_advisor
  elsif add_entries_input == "classes"
    ui_add_class
  elsif add_entries_input == "grades"
    ui_add_grade
  elsif add_entries_input == "students"
    ui_add_student
  else 
    ui_main_menu
  end
end

def ui_add_advisor
  puts "Enter the last name of the new advisor you wish to add:"
  add_advisor_ln = gets.chomp
  puts "Enter the first name of the new advisor you wish to add:"
  add_advisor_fn = gets.chomp
  puts "Enter the ID of the field that the new advisor specializes in:"
  add_advisor_field_input = gets.chomp.to_i
  add_advisor(add_advisor_ln, add_advisor_fn, add_advisor_field_input)
  ui_add_entries
end

def ui_add_class
  puts "Enter the name of the class you wish to add:"
  add_class_name_input = gets.chomp
  puts "Enter the ID of the field that the class is relevant to:"
  add_class_field_id_input = gets.chomp.to_i
  add_class(add_class_name_input, add_class_field_id_input)
  ui_add_entries
end

def ui_add_grade
  puts "Enter the ID of the student who is receiving this grade:"
  add_grade_student_id_input = gets.chomp.to_i
  puts "Enter the ID of the class for which this grade is being given:"
  add_grade_class_id_input = gets.chomp.to_i
  puts "Enter the grade that was given. (Any decimal number between 0.0 and 4.0)"
  add_grade_float_input = gets.chomp.to_i
  puts "Enter the date that the grade was given. (YYYY-MM-DD format) If it is today, then just press enter."
  add_grade_date_input = gets.chomp
  if add_grade_date_input == ""
    add_grade(add_grade_student_id_input, add_grade_class_id_input, add_grade_float_input)
  else 
    add_grade(add_grade_student_id_input, add_grade_class_id_input, add_grade_float_input, add_grade_date_input)
  end
  ui_add_entries
end

def ui_add_student
  puts "Enter the last name of the new student:"
  add_student_ln = gets.chomp
  puts "Enter the first name of the new student:"
  add_student_fn = gets.chomp
  puts "Enter the ID of the advisor of the new student:"
  add_student_advisor_id_input = gets.chomp.to_i
  puts "Enter the ID of the specialty field of the new student:"
  add_student_field_id_input = gets.chomp.to_i
  puts "Enter the matriculation date of the new student. (YYYY-MM-DD format) If it is today, then just press enter."
  add_student_matr_date_input = gets.chomp
  if add_student_matr_date_input == ""
    add_student(add_student_ln, add_student_fn, add_student_advisor_id_input, add_student_field_id_input)
  else 
    add_student(add_student_ln, add_student_fn, add_student_advisor_id_input, add_student_field_id_input, add_student_matr_date_input)
  end
  ui_add_entries
end

ui_main_menu