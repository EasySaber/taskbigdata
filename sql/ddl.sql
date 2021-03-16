CREATE TABLE product (
                         id BIGSERIAL PRIMARY KEY,
                         article_id BIGINT NOT NULL,
                         category_id BIGINT NOT NULL,
                         title VARCHAR(200) NOT NULL,
                         description TEXT NOT NULL,
                         specification TEXT NOT NULL,
                         price DECIMAL DEFAULT 0 NOT NULL,
                         CONSTRAINT article_unique UNIQUE (article_id)
);

CREATE TABLE article (
                         id BIGSERIAL PRIMARY KEY,
                         title VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE category (
                          id BIGSERIAL PRIMARY KEY,
                          title VARCHAR(30) UNIQUE NOT NULL,
                          parent_id BIGINT DEFAULT 0 NOT NULL
);

CREATE TABLE feedback (
                          id BIGSERIAL PRIMARY KEY,
                          date_publication TIMESTAMPTZ DEFAULT now() NOT NULL,
                          content VARCHAR(500) NOT NULL,
                          article_id BIGINT NOT NULL,
                          customer_id BIGINT,
                          author VARCHAR(100) NOT NULL
);

CREATE TABLE address (
                         id BIGSERIAL PRIMARY KEY,
                         customer_id BIGINT NOT NULL,
                         index_home VARCHAR(10) NOT NULL,
                         country VARCHAR(50) NOT NULL,
                         city VARCHAR(50) NOT NULL,
                         street VARCHAR(50) NOT NULL,
                         house_number VARCHAR(10) NOT NULL,
                         apartment_number VARCHAR(10)
);

CREATE TABLE customer (
                          id BIGSERIAL PRIMARY KEY,
                          first_name VARCHAR(50) NOT NULL,
                          middle_name VARCHAR(50),
                          last_name VARCHAR(50)NOT NULL,
                          date_of_birth DATE,
                          email VARCHAR(100) NOT NULL,
                          login VARCHAR(50) NOT NULL,
                          password VARCHAR(500) NOT NULL,
                          phone VARCHAR(30) NOT NULL
);

CREATE TABLE ordering (
                          id BIGSERIAL PRIMARY KEY,
                          date_order TIMESTAMPTZ DEFAULT now() NOT NULL,
                          customer_id BIGINT NOT NULL,
                          status_id INT NOT NULL,
                          delivery_id BIGINT UNIQUE NOT NULL,
                          total DECIMAL DEFAULT 0 NOT NULL
);

CREATE TABLE order_status (
                              id SERIAL PRIMARY KEY,
                              title VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE order_line (
                            id BIGSERIAL PRIMARY KEY,
                            order_id BIGINT NOT NULL,
                            product_id BIGINT NOT NULL,
                            quantity BIGINT DEFAULT 1 NOT NULL CHECK ( quantity >= 1 )
);

CREATE TABLE delivery (
                          id BIGSERIAL PRIMARY KEY,
                          description VARCHAR(150) NOT NULL,
                          address_id BIGINT NOT NULL,
                          price DECIMAL DEFAULT 0 NOT NULL
);

ALTER TABLE product ADD CONSTRAINT fk_product_article
    FOREIGN KEY (article_id) REFERENCES article (id);

ALTER TABLE product ADD CONSTRAINT fk_product_category
    FOREIGN KEY (category_id) REFERENCES category (id);

ALTER TABLE feedback ADD CONSTRAINT fk_feedback_article
    FOREIGN KEY (article_id) REFERENCES article (id);

ALTER TABLE feedback ADD CONSTRAINT fk_feedback_customer
    FOREIGN KEY (customer_id) REFERENCES customer (id)
        ON DELETE SET NULL;

ALTER TABLE address ADD CONSTRAINT fk_address_customer
    FOREIGN KEY (customer_id) REFERENCES customer (id);

ALTER TABLE ordering ADD CONSTRAINT fk_ordering_customer
    FOREIGN KEY (customer_id) REFERENCES customer (id);

ALTER TABLE ordering ADD CONSTRAINT fk_ordering_status
    FOREIGN KEY (status_id) REFERENCES order_status (id);

ALTER TABLE ordering ADD CONSTRAINT fk_ordering_delivery
    FOREIGN KEY (delivery_id) REFERENCES delivery (id);

ALTER TABLE order_line ADD CONSTRAINT fk_order_line_order
    FOREIGN KEY (order_id) REFERENCES ordering (id);

ALTER TABLE order_line ADD CONSTRAINT fk_order_line_product
    FOREIGN KEY (product_id) REFERENCES product (id);

ALTER TABLE delivery ADD CONSTRAINT fk_delivery_address
    FOREIGN KEY (address_id) REFERENCES address (id);