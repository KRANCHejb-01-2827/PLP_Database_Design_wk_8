
CREATE DATABASE LibraryDB;
USE LibraryDB;


CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE
);


CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category_id INT,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    status ENUM('Borrowed',' Returned', 'Overdue') DEFAULT 'Borrowed',
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    reason ENUM('Late Return', 'Book Damage',' Lost Book') DEFAULT 'Late Return',
    paid_status ENUM('Pending',' Paid') DEFAULT 'Pending',
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);


INSERT INTO members (name, email, phone) VALUES
('John Kamau', 'john@email.com', '254712345678'),
('Mary Wanjiku', 'mary@email.com', '254723456789'),
('David Omondi', 'david@email.com', '254734567890');

INSERT INTO categories (category_name) VALUES
('Fiction'),
('Science'),
('Autobiography');

INSERT INTO books (title, author, category_id, total_copies, available_copies) VALUES
('Harry Potter', 'J.K. Rowling', 1, 3, 3),
('The River and the Source', 'Margaret Ogola', 1, 2, 2),
('Brief Answers to the Big Questions', 'Stephen Hawking', 2, 4, 4);

INSERT INTO loans (member_id, book_id, loan_date, due_date, status) VALUES
(1, 1, '2025-09-01', '2025-09-14', 'Borrowed'),
(2, 2, '2025-08-20', '2025-09-05', 'Returned'),
(3, 3, '2025-09-05', '2025-09-19', 'Borrowed');

INSERT INTO fines (loan_id, amount, reason, paid_status) VALUES
(2, 300.00, 'Late Return', 'Paid'),
(1, 500.00, 'Book Damage', 'Pending');
