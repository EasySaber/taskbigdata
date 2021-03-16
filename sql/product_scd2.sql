/* SCD Type 2 для сущности <product>
   - сохранение истории изменения: описания, харахтеристик, цены продукта. Для последующего анализа.
*/

ALTER TABLE product DROP CONSTRAINT IF EXISTS article_unique;

ALTER TABLE product
    ADD COLUMN active VARCHAR(15) DEFAULT 'relevant' NOT NULL,
    ADD COLUMN date_start TIMESTAMPTZ DEFAULT now() NOT NULL,
    ADD COLUMN date_end TIMESTAMPTZ;

CREATE OR REPLACE FUNCTION p_product_before_ud() RETURNS TRIGGER
AS $$
DECLARE
    date_now TIMESTAMPTZ;
    status_active VARCHAR;
BEGIN
    date_now = now();

    IF (OLD.date_end IS NOT NULL) THEN
        RAISE NOTICE 'Обновление невозможно, запись неактуальна: id -> %', OLD.id;
        RETURN NULL;
    END IF;

    IF (TG_OP = 'UPDATE') THEN

        IF ((NEW.article_id = OLD.article_id) AND
            (NEW.category_id = OLD.category_id) AND
            (NEW.title = OLD.title) AND
            (NEW.description = OLD.description) AND
            (NEW.specification = OLD.specification) AND
            (NEW.price = OLD.price)) THEN
            RAISE NOTICE 'Изменений в данных не обнаружено. id -> %', NEW.id;
            RETURN NULL;
        ELSE
            INSERT INTO product(article_id, category_id, title, description, specification, price, date_start)
            VALUES (NEW.article_id, NEW.category_id, NEW.title, NEW.description, NEW.specification, NEW.price, date_now);
            status_active = 'archive';
        END IF;
    ELSE
        status_active = 'delete';
    END IF;

    UPDATE product SET active = status_active, date_end = date_now WHERE id = OLD.id;
    RETURN NULL;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION p_product_before_insert() RETURNS TRIGGER
AS $$
BEGIN
    IF ((SELECT count(*) FROM product WHERE ((article_id = NEW.article_id) AND (active = 'relevant'))) = 0) THEN
        INSERT INTO product(article_id, category_id, title, description, specification, price)
        VALUES (NEW.article_id, NEW.category_id, NEW.title, NEW.description, NEW.specification, NEW.price);
        RETURN NULL;
    END IF;
    RAISE EXCEPTION 'Нарушение уникальности артикула. Уже присвоен активному товару. Артикул -> %',
        (SELECT title FROM article WHERE id = NEW.article_id)
        USING HINT = 'Замените артикул.';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_product_before_ud
    BEFORE UPDATE OR DELETE ON product
    FOR EACH ROW
    WHEN ( pg_trigger_depth() = 0 )
EXECUTE PROCEDURE p_product_before_ud();

CREATE TRIGGER t_product_before_insert
    BEFORE INSERT ON product
    FOR EACH ROW
    WHEN ( pg_trigger_depth() = 0 )
EXECUTE PROCEDURE p_product_before_insert();
