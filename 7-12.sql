-- 7.  В подключенном MySQL репозитории создать базу данных “Друзья человека”
CREATE SCHEMA humans_friends;

USE humans_friends;

-- 8. Создать таблицы с иерархией из диаграммы в БД
CREATE TABLE animals (
id INT PRIMARY KEY AUTO_INCREMENT,
class CHAR(30)
);

INSERT INTO animals (class) VALUES
('home_animals'), ('pack_animals');

CREATE TABLE cats (
id INT PRIMARY KEY AUTO_INCREMENT,
name_animal CHAR(20),
birthday DATE,
command TEXT,
id_class_animal INT NOT NULL,
FOREIGN KEY (id_class_animal) REFERENCES animals (id) ON DELETE CASCADE
);

CREATE TABLE dogs (
id INT PRIMARY KEY AUTO_INCREMENT,
name_animal CHAR(20),
birthday DATE,
command TEXT,
id_class_animal INT NOT NULL,
FOREIGN KEY (id_class_animal) REFERENCES animals (id) ON DELETE CASCADE
);

CREATE TABLE hamsters (
id INT PRIMARY KEY AUTO_INCREMENT,
name_animal CHAR(20),
birthday DATE,
command TEXT,
id_class_animal INT NOT NULL,
FOREIGN KEY (id_class_animal) REFERENCES animals (id) ON DELETE CASCADE
);

CREATE TABLE horses (
id INT PRIMARY KEY AUTO_INCREMENT,
name_animal CHAR(20),
birthday DATE,
command TEXT,
id_class_animal INT NOT NULL,
FOREIGN KEY (id_class_animal) REFERENCES animals (id) ON DELETE CASCADE
);

CREATE TABLE camels (
id INT PRIMARY KEY AUTO_INCREMENT,
name_animal CHAR(20),
birthday DATE,
command TEXT,
id_class_animal INT NOT NULL,
FOREIGN KEY (id_class_animal) REFERENCES animals (id) ON DELETE CASCADE
);

CREATE TABLE donkeys (
id INT PRIMARY KEY AUTO_INCREMENT,
name_animal CHAR(20),
birthday DATE,
command TEXT,
id_class_animal INT NOT NULL,
FOREIGN KEY (id_class_animal) REFERENCES animals (id) ON DELETE CASCADE
);

-- 9. Заполнить низкоуровневые таблицы именами(животных), командами которые они выполняют и датами рождения
INSERT INTO cats (name_animal, birthday, command, id_class_animal) VALUES
('Barsik', '2022-03-21', 'слезай', 1),
('Murzik', '2021-04-23', 'кыс-кыс', 1),
('Mufasa', '2020-09-17', 'брысь', 1),
('Archi', '2017-01-03', 'кыс-кыс', 1);

INSERT INTO dogs (name_animal, birthday, command, id_class_animal) VALUES
('Sharik', '2019-05-28', 'лапу', 1),
('Graf', '2022-11-13', 'сидеть', 1),
('Barbos', '2018-01-03', 'посчитай интеграл', 1);

INSERT INTO hamsters (name_animal, birthday, command, id_class_animal) VALUES
('Homa', '2022-01-02', 'в колесо', 1),
('Businka', '2023-06-14', 'иди в домик', 1),
('Jora', '2022-12-18', 'держи вкусняшку', 1);

INSERT INTO horses (name_animal, birthday, command, id_class_animal) VALUES
('Saharok', '2017-06-21', 'пошел рысью', 2),
('Mathilda', '2015-07-11', 'голос', 2),
('Raketa', '2012-01-30', 'галопом', 2);

INSERT INTO camels (name_animal, birthday, command, id_class_animal) VALUES
('Harchok', '2020-08-03', 'не плюйся', 2),
('Plevok', '2017-09-16', 'не снимайся в рекламе сигарет', 2),
('Al-ahli', '2015-02-02', 'купи Роналду', 2);

INSERT INTO donkeys (name_animal, birthday, command, id_class_animal) VALUES
('Hey_you', '2022-05-15', 'хватит', 2),
('Ishak', '2016-07-25', 'ну пошли!!!!', 2),
('Osel', '2017-08-19', 'сальто назад!', 2);

-- 10. Удалив из таблицы верблюдов, т.к. верблюдов решили перевезти в другой питомник на зимовку. Объединить таблицы лошади, и ослы в одну таблицу.
TRUNCATE TABLE camels;

INSERT INTO horses (name_animal, birthday, command, id_class_animal) SELECT name_animal, birthday, command, id_class_animal FROM donkeys;

DROP TABLE donkeys;

RENAME TABLE horses TO horses_and_donkeys;

-- 11.Создать новую таблицу “молодые животные” в которую попадут все животные старше 1 года, но младше 3 лет и в отдельном столбце с точностью до месяца подсчитать возраст животных в новой таблице
CREATE TABLE young_animals (
id INT PRIMARY KEY AUTO_INCREMENT,
name_animal CHAR(20),
birthday DATE,
command TEXT,
id_class_animal INT NOT NULL,
age TEXT
);

DELIMITER $$
CREATE FUNCTION years_old (date_b DATE)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE res TEXT DEFAULT '';
		SET res = CONCAT(
            TIMESTAMPDIFF(YEAR, date_b, CURDATE()),
            ' years ',
            TIMESTAMPDIFF(MONTH, date_b, CURDATE()) % 12,
            ' month'
		);
	RETURN res;
END $$
DELIMITER ;

INSERT INTO young_animals (name_animal, birthday, command, id_class_animal, age)
SELECT name_animal, birthday, command, id_class_animal, years_old(birthday)
FROM cats
WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 1 AND 3
UNION ALL
SELECT name_animal, birthday, command, id_class_animal, years_old(birthday)
FROM dogs
WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 1 AND 3
UNION ALL
SELECT name_animal, birthday, command, id_class_animal, years_old(birthday)
FROM hamsters
WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 1 AND 3
UNION ALL
SELECT name_animal, birthday, command, id_class_animal, years_old(birthday)
FROM horses_and_donkeys
WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 1 AND 3;

-- 12. Объединить все таблицы в одну, при этом сохраняя поля, указывающие на прошлую принадлежность к старым таблицам. 
CREATE TABLE all_animals (
id INT PRIMARY KEY AUTO_INCREMENT,
name_animal CHAR(20),
birthday DATE,
command TEXT,
id_class_animal INT NOT NULL,
age TEXT
);

DELETE FROM cats WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 1 AND 3;
DELETE FROM dogs WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 1 AND 3;
DELETE FROM hamsters WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 1 AND 3;
DELETE FROM horses_and_donkeys WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 1 AND 3;

INSERT INTO all_animals (name_animal, birthday, command, id_class_animal, age)
SELECT name_animal, birthday, command, id_class_animal, years_old(birthday)
FROM cats;

INSERT INTO all_animals (name_animal, birthday, command, id_class_animal, age)
SELECT name_animal, birthday, command, id_class_animal, years_old(birthday)
FROM dogs;

INSERT INTO all_animals (name_animal, birthday, command, id_class_animal, age)
SELECT name_animal, birthday, command, id_class_animal, years_old(birthday)
FROM hamsters;

INSERT INTO all_animals (name_animal, birthday, command, id_class_animal, age)
SELECT name_animal, birthday, command, id_class_animal, years_old(birthday)
FROM horses_and_donkeys;

INSERT INTO all_animals (name_animal, birthday, command, id_class_animal, age)
SELECT name_animal, birthday, command, id_class_animal, years_old(birthday)
FROM young_animals;

SELECT * FROM all_animals;
