
CREATE DATABASE Library_Management ;
USE Library_Management;

CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(13) UNIQUE NOT NULL,
    id_number VARCHAR(20) UNIQUE, 
    join_date DATE DEFAULT CURRENT_DATE,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    CONSTRAINT chk_kenyan_phone CHECK (phone REGEXP '^254[0-9]{9}$')
);


CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    published_year YEAR,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    location ENUM('Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret') DEFAULT 'Nairobi'
);

-- 3. Loans table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    status ENUM('Borrowed', 'Returned', 'Overdue') DEFAULT 'Borrowed',
    
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);


CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    loan_id INT NULL,
    amount DECIMAL(8,2) NOT NULL DEFAULT 0.00, 
    reason ENUM('Late Return', 'Book Damage', 'Lost Book') DEFAULT 'Late Return',
    fine_date DATE DEFAULT CURRENT_DATE,
    paid_date DATE NULL,
    status ENUM('Pending', 'Paid', 'Waived') DEFAULT 'Pending',
    
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE SET NULL
);


INSERT INTO members (name, email, phone, id_number) VALUES
('John Kamau', 'john.kamau@email.com', '254712345678', '12345678'),
('Mary Wanjiku', 'mary.wanjiku@email.com', '254723456789', '23456789'),
('David Omondi', 'david.omondi@email.com', '254734567890', '34567890'),
('Grace Akinyi', 'grace.akinyi@email.com', '254745678901', '45678901'),
('James Mwangi', 'james.mwangi@email.com', '254756789012', '56789012');

INSERT INTO books (isbn, title, author, genre, published_year, total_copies, available_copies, location) VALUES
('978-0439708180', 'Harry Potter and the Philosopher's Stone', 'J.K. Rowling', 'Fantasy', 1997, 5, 5, 'Nairobi'),
('978-9966258001', 'Daughter of Mombasa', 'Mwenda Micheni', 'Fiction', 2019, 3, 3, 'Mombasa'),
('978-9966258018', 'The River and the Source', 'Margaret Ogola', 'Drama', 1994, 4, 4, 'Kisumu'),
('978-0195739011', 'Weep Not Child', 'Ngũgĩ wa Thiong''o', 'Fiction', 1964, 2, 2, 'Nairobi'),
('978-9966498019', 'Unbounded', 'Boniface Mwangi', 'Autobiography', 2017, 3, 3, 'Nakuru');

INSERT INTO loans (book_id, member_id, loan_date, due_date, status) VALUES
(1, 1, '2024-01-10', '2024-01-24', 'Borrowed'),
(3, 2, '2024-01-05', '2024-01-19', 'Returned'),
(2, 3, '2024-01-08', '2024-01-22', 'Borrowed');

-- Update one book's available copies to simulate a loan
UPDATE books SET available_copies = available_copies - 1 WHERE book_id = 1;
UPDATE books SET available_copies = available_copies - 1 WHERE book_id = 2;

-- Insert sample fines
INSERT INTO fines (member_id, loan_id, amount, reason) VALUES
(2, 2, 500.00, 'Late Return'), 
(1, 1, 200.00, 'Book Damage'); 


CREATE VIEW active_loans_view AS
SELECT 
    m.name AS member_name,
    m.phone AS kenyan_phone,
    b.title AS book_title,
    b.author,
    l.loan_date,
    l.due_date,
    l.status
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
WHERE l.status IN ('Borrowed', 'Overdue');

SELECT title, author, location FROM books WHERE location = 'Nairobi';
SELECT title, author, location FROM books WHERE location = 'Mombasa';
