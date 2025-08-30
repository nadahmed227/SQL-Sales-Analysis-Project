CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    SignupDate DATE
);

-- Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    UnitPrice DECIMAL(10,2)
);

-- Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers VALUES
(1, 'Ahmed Ali', '2024-01-05'),
(2, 'Sara Mohamed', '2024-01-20'),
(3, 'Omar Khaled', '2024-02-10'),
(4, 'Mona Youssef', '2024-03-15'),
(5, 'Khaled Hassan', '2024-04-02'),
(6, 'Huda Mostafa', '2024-05-08'),
(7, 'Youssef Adel', '2024-05-12'),
(8, 'Laila Hassan', '2024-06-25'),
(9, 'Mohamed Tarek', '2024-07-05'),
(10, 'Nour Ahmed', '2024-07-18'),
(11, 'Ola Ibrahim', '2024-08-01'),
(12, 'Karim Fathy', '2024-08-12'),
(13, 'Samir Lotfy', '2024-09-05'),
(14, 'Dina Magdy', '2024-09-19'),
(15, 'Hassan Gamal', '2024-10-02'),
(16, 'Eman Saeed', '2024-10-15'),
(17, 'Mostafa Adel', '2024-11-01'),
(18, 'Hanaa Youssef', '2024-11-10'),
(19, 'Tamer Fouad', '2024-12-01'),
(20, 'Nadia Samir', '2024-12-15');

INSERT INTO Products VALUES
(1, 'Laptop', 1200.00),
(2, 'Headphones', 150.00),
(3, 'Keyboard', 80.00),
(4, 'Mouse', 50.00),
(5, 'Monitor', 300.00),
(6, 'Smartphone', 900.00),
(7, 'Printer', 400.00),
(8, 'Desk Chair', 180.00),
(9, 'Tablet', 600.00),
(10, 'USB Flash Drive', 25.00),
(11, 'External Hard Drive', 100.00),
(12, 'Webcam', 70.00),
(13, 'Speakers', 120.00),
(14, 'Router', 90.00),
(15, 'Projector', 450.00),
(16, 'Smartwatch', 250.00),
(17, 'Docking Station', 200.00),
(18, 'Microphone', 110.00),
(19, 'Graphics Card', 700.00),
(20, 'Office Desk', 350.00);

-- Orders (10 طلبات كبداية)
INSERT INTO Orders VALUES
(1, 1, '2024-01-10'),
(2, 2, '2024-01-25'),
(3, 3, '2024-02-15'),
(4, 4, '2024-03-20'),
(5, 5, '2024-04-05'),
(6, 6, '2024-04-18'),
(7, 7, '2024-05-10'),
(8, 8, '2024-06-25'),
(9, 9, '2024-07-05'),
(10, 10, '2024-07-18');

-- OrderDetails (منتجات لكل طلب)
INSERT INTO OrderDetails VALUES
(1, 1, 1, 1),   -- Ahmed bought 1 Laptop
(2, 1, 2, 2),   -- Ahmed bought 2 Headphones
(3, 2, 6, 1),   -- Sara bought 1 Smartphone
(4, 3, 5, 2),   -- Omar bought 2 Monitors
(5, 4, 4, 1),   -- Mona bought 1 Mouse
(6, 5, 1, 1),   -- Khaled bought 1 Laptop
(7, 6, 7, 1),   -- Huda bought 1 Printer
(8, 7, 9, 1),   -- Youssef bought 1 Tablet
(9, 8, 10, 5),  -- Laila bought 5 USB Drives
(10, 9, 3, 2),  -- Mohamed bought 2 Keyboards
(11, 10, 8, 1); -- Nour bought 1 Desk Chair

--📊 1) إجمالي الإيرادات (Total Revenue)
SELECT 
   SUM(od.Quantity* p.UnitPrice)  TotalRevenue
FROM OrderDetails od 
JOIN Products p ON od.ProductID=p.ProductID  


--📊 2) أفضل 5 منتجات مبيعًا (Top 5 Best-Selling Products)
SELECT TOP 5 
        p.ProductName,
        SUM(od.Quantity) AS TotalQuantitySold,
       SUM(od.Quantity* p.UnitPrice)  TotalRevenue

FROM OrderDetails od 
JOIN Products p ON od.ProductID=p.ProductID  
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC; 

--📊 3) عدد العملاء الجدد شهريًا (New Customers per Month)
SELECT 
FORMAT(SignupDate,'YYYY-MM') AS Month  ,
COUNT(CustomerID) AS NewCustomers
FROM Customers 
GROUP BY FORMAT(SignupDate,'YYYY-MM') 
ORDER BY Month
--📊 4) متوسط قيمة الطلب (Average Order Value)
SELECT 
AVG(OrderTotal)AS AvgOrderValue

FROM(
SELECT o.OrderID, 
SUM(od.Quantity* p.UnitPrice)  AS OrderTotal
  FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY o.OrderID
) AS OrderTotals;

--📊 5) المبيعات الشهرية (Monthly Sales Trend)
SELECT 
FORMAT(o.OrderDate,'YYYY-MM') AS Month  ,
SUM(od.Quantity* p.UnitPrice)  AS MonthlyRevenue
FROM Orders o 
 JOIN OrderDetails od ON o.OrderID = od.OrderID
  JOIN Products p ON od.ProductID = p.ProductID
GROUP BY FORMAT(OrderDate,'YYYY-MM') 
ORDER BY Month