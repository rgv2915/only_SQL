create database windowFunctions;

use windowFunctions;

CREATE TABLE student_grades (
    student_id INT,
    student_name VARCHAR(50),
    subject VARCHAR(50),
    grade FLOAT
);

INSERT INTO student_grades (student_id, student_name, subject, grade) VALUES
(1, 'Alice', 'Math', 85.5),
(2, 'Bob', 'Math', 90.0),
(3, 'Charlie', 'Math', 75.0),
(1, 'Alice', 'Science', 92.0),
(2, 'Bob', 'Science', 78.5),
(3, 'Charlie', 'Science', 80.0);

select * from student_grades;

/*
Suppose you want to know each student's grade and the average grade for each subject, but without losing any individual rows.
*/
SELECT student_id, 
		student_name, 
		subject, 
		grade,
		AVG(grade) OVER (PARTITION BY subject) as avg_grade
FROM
student_grades;

/*
EXPLANATIOn for the above
--------------------------
🪜 Step-by-Step Explanation
✅ 1. SELECT student_id, student_name, subject, grade
----------------------------------------------------------
	These columns are selected as-is from the table.
	They represent each student’s individual performance.

✅ 2. AVG(grade) OVER (PARTITION BY subject)
---------------------------------------------
🔍 This is a window function.
	➤ AVG(grade):
	Calculates the average of the grade column.

	➤ OVER (PARTITION BY subject):
	   --------------------------
		This tells SQL to group the data temporarily by subject (Math or Science),
		but without collapsing the rows (unlike GROUP BY).

		So, for each student’s row:
			SQL looks at all other rows within the same subject
			Then it computes the average grade for that subject.
		
			output table here
		✅ See how the avg_grade is repeated for all rows of the same subject.

✅ 3. Why use OVER() and not GROUP BY?
---------------------------------------
		If you used GROUP BY subject, you would only get 2 rows (one per subject) — losing student-level detail.
		Window functions let you preserve row-level data while still doing aggregations over "groups".

		OVER(PARTITION BY subject)	Does this within each subject group, without removing rows

*/

-- from chatgpt
-- Avg grade per subject
SELECT subject, 
		AVG(grade) AS avg_grade
FROM student_grades
GROUP BY subject;

--Highest grade per subject,
SELECT subject, MAX(grade) AS highest_grade
FROM student_grades
GROUP BY subject;

-- AVG grade poer student
SELECT student_id, student_name, AVG(grade) AS avg_grade
FROM student_grades
GROUP BY student_id, student_name;

-- Pivot
SELECT
    student_id,
    student_name,
    MAX(CASE WHEN subject = 'Math' THEN grade END) AS Math_Grade,
    MAX(CASE WHEN subject = 'Science' THEN grade END) AS Science_Grade
FROM student_grades
GROUP BY student_id, student_name;
