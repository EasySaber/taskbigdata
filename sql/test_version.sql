INSERT INTO category(title)
VALUES ('Ноутбуки'),
       ('Бытовая техника');

INSERT INTO article(title)
VALUES ('001'),
       ('002');

INSERT INTO product(article_id, category_id, title, description, price, specification)
VALUES ((SELECT id FROM article WHERE title = '001'), (SELECT id FROM category WHERE title = 'Ноутбуки'), 'MacBook', 'Высока производительность', 40000.00, 'Процессор, ОЗУ'),
       ((SELECT id FROM article WHERE title = '002'), (SELECT id FROM category WHERE title = 'Бытовая техника'), 'Чайник', 'Современный дизайн', 2000.00, 'Мощность, объем');

UPDATE product SET title = 'MacBook Pro' WHERE title = 'MacBook';
UPDATE product SET price = 120000.00 WHERE article_id = (SELECT id FROM article WHERE title = '001');

UPDATE product SET description = 'Современный дизайн, большой объем.' WHERE title = 'Чайник';

DELETE FROM product WHERE article_id = (SELECT id FROM article WHERE title = '002');

INSERT INTO product(article_id, category_id, title, description, price, specification)
VALUES ((SELECT id FROM article WHERE title = '002'), (SELECT id FROM category WHERE title = 'Бытовая техника'), 'Чайник', 'Современный дизайн', 2000.00, 'Мощность, объем');

INSERT INTO product(article_id, category_id, title, description, price, specification)
VALUES ((SELECT id FROM article WHERE title = '001'), (SELECT id FROM category WHERE title = 'Ноутбуки'), 'MacBook', 'Высока производительность', 40000.00, 'Процессор, ОЗУ');

