CREATE DATABASE IF NOT EXISTS students;

USE students;

CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL
);

INSERT IGNORE INTO students (name, state, country) VALUES
('Mohammad', 'VA', 'USA'),
('Omar', 'VA', 'USA'),
('Zia', 'VA', 'USA');
