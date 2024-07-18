// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BookLoversDAO {
    // Struct to represent a Book
    struct Book {
        uint256 id;
        string title;
        string author;
        string ISBN;
        address owner; // Address of the current owner of the physical book
        bool isPhysical; // Flag to differentiate physical vs digital book
        bool isAvailable; // Flag to indicate if the physical book is available for borrowing
    }
    
    // Array to store all books in the DAO
    Book[] public books;

    // Mapping to track ownership of physical books
    mapping(uint256 => address) public bookOwners;

    // Events for book operations
    event BookAdded(uint256 indexed id, string title, string author, string ISBN, bool isPhysical);
    event BookBorrowed(uint256 indexed id, address indexed borrower);
    event BookReturned(uint256 indexed id);

    // Function to add a new book to the DAO
    function addBook(string memory _title, string memory _author, string memory _ISBN, bool _isPhysical) external {
        uint256 newBookId = books.length;
        books.push(Book(newBookId, _title, _author, _ISBN, msg.sender, _isPhysical, true));
        bookOwners[newBookId] = msg.sender;
        emit BookAdded(newBookId, _title, _author, _ISBN, _isPhysical);
    }

    // Function to borrow a physical book
    function borrowBook(uint256 _bookId) external {
        require(books[_bookId].isPhysical, "Only physical books can be borrowed");
        require(books[_bookId].isAvailable, "Book is not available for borrowing");
        books[_bookId].isAvailable = false;
        bookOwners[_bookId] = msg.sender;
        emit BookBorrowed(_bookId, msg.sender);
    }

    // Function to return a borrowed book
    function returnBook(uint256 _bookId) external {
        require(bookOwners[_bookId] == msg.sender, "You are not the borrower of this book");
        books[_bookId].isAvailable = true;
        emit BookReturned(_bookId);
    }

    // Function to get total number of books in the DAO
    function getTotalBooks() external view returns (uint256) {
        return books.length;
    }

    // Function to get details of a specific book
    function getBookDetails(uint256 _bookId) external view returns (
        string memory title,
        string memory author,
        string memory ISBN,
        address owner,
        bool isPhysical,
        bool isAvailable
    ) {
        require(_bookId < books.length, "Book ID does not exist");
        Book memory book = books[_bookId];
        return (book.title, book.author, book.ISBN, book.owner, book.isPhysical, book.isAvailable);
    }
}
