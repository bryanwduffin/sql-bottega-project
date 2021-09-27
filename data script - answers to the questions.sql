-- Answering Questions - SQL Query Scripts
USE devcamp_sql_course_schema;

-- -----------------------------------------------------------------------------------------
-- The average grade that is given by each professor
-- -----------------------------------------------------------------------------------------
SELECT professors.profs_id, professors.profs_fname, professors.profs_lname, AVG(grades.grades_grade) AS 'Avg Grade' 
FROM grades
LEFT JOIN professors ON grades.grades_profs_id = professors.profs_id
GROUP BY professors.profs_id
ORDER BY AVG(grades.grades_grade) DESC;
-- -----------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------
-- The top grades for each student
-- -----------------------------------------------------------------------------------------
SELECT students.students_id, students.students_fname, students.students_lname, MAX(grades.grades_grade) AS 'Highest Grade'
FROM grades
LEFT JOIN students ON grades.grades_students_id = students.students_id
GROUP BY students.students_id
ORDER BY MAX(grades.grades_grade) DESC;
-- -----------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------
-- Group students by the courses that they are enrolled in
-- -----------------------------------------------------------------------------------------
SELECT courses.courses_course, students.students_fname, students.students_lname
FROM grades
INNER JOIN courses ON grades.grades_courses_id = courses.courses_id
INNER JOIN students ON grades.grades_students_id = students.students_id
GROUP BY grades.grades_courses_id, grades.grades_students_id
ORDER BY grades.grades_courses_id;
-- -----------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------
-- Create a summary report of courses and their average grades, sorted by the most
-- challenging course (course with the lowest average grade) to the easiest course
-- -----------------------------------------------------------------------------------------
SELECT courses.courses_course AS 'Course', AVG(grades.grades_grade) AS 'Average Grade'
FROM grades
LEFT JOIN courses ON grades.grades_courses_id = courses.courses_id
GROUP BY courses.courses_course
ORDER BY AVG(grades.grades_grade) DESC;
-- -----------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------
-- Finding which student and professor have the most courses in common
-- -----------------------------------------------------------------------------------------
WITH counter AS (
  SELECT
    students.students_fname, students.students_lname,
    professors.profs_fname, professors.profs_lname, 
    count(DISTINCT courses.courses_id) counter 
  FROM grades
  JOIN students ON grades.grades_students_id = students.students_id
  JOIN courses ON grades.grades_courses_id = courses.courses_id
  JOIN professors ON courses.courses_profs_id = professors.profs_id
  GROUP BY
    students.students_fname, students.students_lname,
    professors.profs_fname, professors.profs_lname
)
SELECT * FROM counter
WHERE counter.counter = (
  SELECT max(counter) FROM counter
)
-- -----------------------------------------------------------------------------------------
