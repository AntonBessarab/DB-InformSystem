-- Створення ENUM типу для статусу оцінки
CREATE TYPE grade_status AS ENUM ('not_graded', 'graded', 'resit');

-- Додавання цього типу до таблиці Grades
ALTER TABLE Grades ADD COLUMN status grade_status DEFAULT 'not_graded';

-- Функція для розрахунку середнього балу для конкретного студента
CREATE OR REPLACE FUNCTION calculate_average_grade(p_student_id INT) RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT AVG(grade)
        FROM Grades
        WHERE student_id = p_student_id
    );
END;
$$ LANGUAGE plpgsql;


-- Використання функції для конкретного студента
SELECT calculate_average_grade(1);


-- Створення таблиці для логування змін
CREATE TABLE grade_log (
    log_id SERIAL PRIMARY KEY,
    grade_id INT,
    operation VARCHAR(10),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Тригерна функція для логування змін в таблиці Grades
CREATE OR REPLACE FUNCTION log_grade_changes() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO grade_log (grade_id, operation)
    VALUES (NEW.id, TG_OP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Створення тригера для таблиці Grades
CREATE TRIGGER track_grade_changes
AFTER INSERT OR UPDATE OR DELETE ON Grades
FOR EACH ROW
EXECUTE FUNCTION log_grade_changes();


-- Тест для перевірки логування змін
INSERT INTO Grades (student_id, subject_id, teacher_id, grade, date, status)
VALUES (1, 1, 1, 90, '2024-12-15', 'graded');

-- Перевірка записів в таблиці журналу
SELECT * FROM grade_log;

-- Тест для перевірки функції середнього балу
SELECT calculate_average_grade(1);

-- Тест для перевірки логування зміни
UPDATE Grades SET grade = 95 WHERE student_id = 1 AND subject_id = 1;

