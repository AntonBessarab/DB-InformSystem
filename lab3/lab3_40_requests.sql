-- lab3.sql — SQL-запити до бази "Lab2_student_grades"

-- 1. Вивести всі дані з таблиці Students
SELECT * FROM Students;

-- 2. Вивести всіх студентів, які народилися після 2004 року
SELECT * FROM Students WHERE birth_date > '2004-01-01';

-- 3. Знайти студентів з групи 1
SELECT * FROM Students WHERE group_id = 1;

-- 4. Вивести 5 перших студентів за алфавітом
SELECT * FROM Students ORDER BY full_name LIMIT 5;

-- 5. Порахувати кількість студентів
SELECT COUNT(*) FROM Students;

-- 6. Знайти мінімальну оцінку
SELECT MIN(grade) FROM Grades;

-- 7. Знайти максимальну оцінку
SELECT MAX(grade) FROM Grades;

-- 8. Знайти середню оцінку
SELECT AVG(grade) FROM Grades;

-- 9. Загальна сума оцінок
SELECT SUM(grade) FROM Grades;

-- 10. Вивести унікальні дати здачі оцінок
SELECT DISTINCT date FROM Grades;

-- 11. INNER JOIN: студент і його оцінки
SELECT s.full_name, g.grade FROM Students s
INNER JOIN Grades g ON s.id = g.student_id;

-- 12. LEFT JOIN: всі студенти з оцінками (якщо є)
SELECT s.full_name, g.grade FROM Students s
LEFT JOIN Grades g ON s.id = g.student_id;

-- 13. RIGHT JOIN: всі оцінки з відповідними студентами
SELECT s.full_name, g.grade FROM Students s
RIGHT JOIN Grades g ON s.id = g.student_id;

-- 14. FULL JOIN: всі студенти і всі оцінки (включно з null)
SELECT s.full_name, g.grade FROM Students s
FULL JOIN Grades g ON s.id = g.student_id;

-- 15. CROSS JOIN: всі можливі комбінації студентів і предметів
SELECT s.full_name, sub.name FROM Students s
CROSS JOIN Subjects sub;

-- 16. SELF JOIN: студенти з однаковими групами
SELECT s1.full_name AS student1, s2.full_name AS student2
FROM Students s1
JOIN Students s2 ON s1.group_id = s2.group_id AND s1.id < s2.id;

-- 17. Підзапит: студенти, які мають оцінки > середнього
SELECT full_name FROM Students
WHERE id IN (
  SELECT student_id FROM Grades
  WHERE grade > (SELECT AVG(grade) FROM Grades)
);

-- 18. EXISTS: викладачі, які мають предмети
SELECT * FROM Teachers t
WHERE EXISTS (
  SELECT 1 FROM Subjects s WHERE s.teacher_id = t.id
);

-- 19. NOT EXISTS: студенти без оцінок
SELECT * FROM Students s
WHERE NOT EXISTS (
  SELECT 1 FROM Grades g WHERE g.student_id = s.id
);

-- 20. UNION: усі імена студентів та викладачів
SELECT full_name FROM Students
UNION
SELECT full_name FROM Teachers;

-- 21. INTERSECT: імена, що є і серед студентів, і серед викладачів
SELECT full_name FROM Students
INTERSECT
SELECT full_name FROM Teachers;

-- 22. EXCEPT: імена студентів, що не є викладачами
SELECT full_name FROM Students
EXCEPT
SELECT full_name FROM Teachers;

-- 23. GROUP BY: середній бал по студенту
SELECT student_id, AVG(grade) FROM Grades GROUP BY student_id;

-- 24. GROUP BY + HAVING: студенти з середнім балом > 80
SELECT student_id, AVG(grade) avg_grade FROM Grades
GROUP BY student_id
HAVING AVG(grade) > 80;

-- 25. JOIN кількох таблиць: студент, предмет, оцінка
SELECT s.full_name, sub.name, g.grade
FROM Students s
JOIN Grades g ON s.id = g.student_id
JOIN Subjects sub ON g.subject_id = sub.id;

-- 26. JOIN з вчителем
SELECT s.full_name, sub.name, t.full_name AS teacher, g.grade
FROM Students s
JOIN Grades g ON s.id = g.student_id
JOIN Subjects sub ON g.subject_id = sub.id
JOIN Teachers t ON sub.teacher_id = t.id;

-- 27. Порахувати кількість предметів у кожного викладача
SELECT teacher_id, COUNT(*) FROM Subjects GROUP BY teacher_id;

-- 28. Порахувати середню оцінку по кожному предмету
SELECT subject_id, AVG(grade) FROM Grades GROUP BY subject_id;

-- 29. Обмеження записів: топ-3 оцінки
SELECT * FROM Grades ORDER BY grade DESC LIMIT 3;

-- 30. CTE: середні оцінки по студенту
WITH AvgGrades AS (
  SELECT student_id, AVG(grade) AS avg_grade
  FROM Grades
  GROUP BY student_id
)
SELECT s.full_name, a.avg_grade
FROM Students s
JOIN AvgGrades a ON s.id = a.student_id;

-- 31. CTE + фільтр
WITH ActiveTeachers AS (
  SELECT * FROM Teachers WHERE department IS NOT NULL
)
SELECT * FROM ActiveTeachers;

-- 32. Віконна функція: ранжування оцінок
SELECT student_id, grade,
  RANK() OVER (PARTITION BY student_id ORDER BY grade DESC) AS grade_rank
FROM Grades;

-- 33. Віконна функція: середня оцінка по всіх студентах (без GROUP BY)
SELECT student_id, grade,
  AVG(grade) OVER () AS avg_overall
FROM Grades;

-- 34. Віконна функція: середня по студенту
SELECT student_id, grade,
  AVG(grade) OVER (PARTITION BY student_id) AS avg_per_student
FROM Grades;

-- 35. COUNT з фільтром: скільки оцінок > 80
SELECT COUNT(*) FROM Grades WHERE grade > 80;

-- 36. Найновіша дата оцінки по кожному студенту
SELECT student_id, MAX(date) FROM Grades GROUP BY student_id;

-- 37. Середній бал по групах
SELECT s.group_id, AVG(g.grade) FROM Students s
JOIN Grades g ON s.id = g.student_id
GROUP BY s.group_id;

-- 38. Всі предмети, які читає кожен викладач
SELECT t.full_name, sub.name FROM Teachers t
JOIN Subjects sub ON t.id = sub.teacher_id;

-- 39. Студенти з кількістю оцінок > 1
SELECT student_id, COUNT(*) AS grade_count FROM Grades
GROUP BY student_id HAVING COUNT(*) > 1;

-- 40. Підзапит у SELECT: студент і його середній бал
SELECT full_name,
  (SELECT AVG(grade) FROM Grades WHERE student_id = s.id) AS avg_grade
FROM Students s;
