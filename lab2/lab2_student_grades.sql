-- Створення користувачів з різними правами доступу
CREATE ROLE admin_user WITH LOGIN PASSWORD 'admin_pass';
CREATE ROLE moderator_user WITH LOGIN PASSWORD 'mod_pass';
CREATE ROLE regular_user WITH LOGIN PASSWORD 'user_pass';

-- Призначення ролей
GRANT ALL PRIVILEGES ON DATABASE lab2_student_grades TO admin_user;
GRANT CONNECT ON DATABASE lab2_student_grades TO moderator_user;
GRANT CONNECT ON DATABASE lab2_student_grades TO regular_user;


-- Створення таблиць
CREATE TABLE Groups (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  course INT NOT NULL
);

CREATE TABLE Teachers (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  department VARCHAR(255) NOT NULL
);

CREATE TABLE Subjects (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  teacher_id INT REFERENCES Teachers(id)
);

CREATE TABLE Students (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  birth_date DATE NOT NULL,
  group_id INT REFERENCES Groups(id)
);

CREATE TABLE Grades (
  id SERIAL PRIMARY KEY,
  student_id INT REFERENCES Students(id),
  subject_id INT REFERENCES Subjects(id),
  teacher_id INT REFERENCES Teachers(id),
  grade INT CHECK (grade >= 0 AND grade <= 100),
  date DATE NOT NULL
);

-- Наповнення таблиць тестовими даними
INSERT INTO Groups (name, course) VALUES ('ІПЗ-21', 2), ('КН-22', 1);

INSERT INTO Teachers (full_name, department) VALUES
('Іваненко Степан Сергійович', 'Інформатика'),
('Петренко Антон Микитович', 'Математика'),
('Коваленко Надія Михайлівна', 'Фізика'),
('Гончар Олександр Юрійович', 'Хімія');

INSERT INTO Subjects (name, teacher_id) VALUES
('Програмування', 1),
('Математика', 2),
('Фізика', 3),
('Хімія', 4);

INSERT INTO Students (full_name, birth_date, group_id) VALUES
('Сидоренко Олег Васильович', '2003-04-12', 1),
('Іванчук Марина Олександрівна', '2004-01-22', 2);
('Мельник Ірина Олегівна', '2003-11-03', 1),
('Ткаченко Дмитро Ігорович', '2004-06-14', 2),
('Лисенко Андрій Сергійович', '2003-02-09', 1),
('Шевченко Наталія Василівна', '2004-12-21', 2);

INSERT INTO Grades (student_id, subject_id, teacher_id, grade, date) VALUES
(1, 1, 1, 88, '2024-12-15'),
(2, 2, 2, 92, '2024-12-15');
(3, 1, 1, 75, '2024-12-16'),
(4, 2, 2, 83, '2024-12-16'),
(5, 3, 3, 90, '2024-12-17'),
(6, 4, 4, 78, '2024-12-17'),
(1, 3, 3, 88, '2024-12-18'),
(2, 4, 4, 85, '2024-12-18');

-- SQL-запити SELECT
-- 1. Вибірка всіх даних зі студентів
SELECT * FROM Students;

-- 2. Вибірка студентів певної групи
SELECT * FROM Students WHERE group_id = 1;

-- 3. Сортування оцінок по спаданню
SELECT * FROM Grades ORDER BY grade DESC;

-- 4. Групування за предметом з середньою оцінкою
SELECT subject_id, AVG(grade) as avg_grade FROM Grades GROUP BY subject_id;

-- 5. Групування з умовою (тільки предмети, де середній бал > 90)
SELECT subject_id, AVG(grade) as avg_grade FROM Grades GROUP BY subject_id HAVING AVG(grade) > 90;

-- 6. Об'єднання таблиць: студенти з їх оцінками та предметами
SELECT s.full_name, sub.name AS subject, g.grade
FROM Grades g
JOIN Students s ON g.student_id = s.id
JOIN Subjects sub ON g.subject_id = sub.id;

-- 7. Унікальні значення предметів
SELECT DISTINCT name FROM Subjects;

-- 8. Максимальний та мінімальний бал
SELECT MAX(grade) AS max_grade, MIN(grade) AS min_grade FROM Grades;

-- 9. Середня кількість оцінок на студента
SELECT AVG(counts) AS avg_grades_per_student FROM (
  SELECT COUNT(*) AS counts FROM Grades GROUP BY student_id
) AS sub;

-- 10. Скільки студентів має оцінку більше 90
SELECT COUNT(*) FROM Grades WHERE grade > 90;

-- 11. Загальна сума всіх оцінок
SELECT SUM(grade) AS total_grades FROM Grades;
