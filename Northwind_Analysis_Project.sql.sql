
-- Sipariþ bazlý satýr toplamlarýný hesaplayarak en yüksek cirolu kalemleri bulur.
SELECT OrderID, ProductID, (UnitPrice * Quantity) AS SatirToplami
FROM [Order Details]
ORDER BY SatirToplami DESC;

-- 15.000 birimden fazla harcama yapan VIP müþterileri listeler.
SELECT c.CompanyName AS Musteri, SUM(od.UnitPrice * od.Quantity) AS ToplamCiro
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName
HAVING SUM(od.UnitPrice * od.Quantity) > 15000
ORDER BY ToplamCiro DESC;

-- Þirketin yýllýk ciro geliþimini kronolojik olarak sunar.
SELECT YEAR(OrderDate) AS Yil, SUM(od.UnitPrice * od.Quantity) AS YillikCiro
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY YEAR(OrderDate)
ORDER BY Yil;


-- 1993 sonrasý iþe giren çalýþanlarý kýdemlerine göre sýralar.
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE HireDate > '1993-12-31'
ORDER BY HireDate ASC;

-- Þirket içi hiyerarþiyi (Kimin kime rapor verdiðini) isimlerle eþleþtirir.
SELECT e.FirstName + ' ' + e.LastName AS Personel,
m.FirstName + ' ' + m.LastName AS Yonetici
FROM Employees e
INNER JOIN Employees m ON e.ReportsTo = m.EmployeeID;

-- Çalýþanlarý ciro performanslarýna göre 'Efsane', 'Yýldýz' ve 'Geliþmekte' olarak segmente eder.
SELECT (e.FirstName + ' ' + e.LastName) AS Personel,
SUM(od.UnitPrice * od.Quantity) AS ToplamCiro,
CASE
WHEN SUM(od.UnitPrice * od.Quantity) > 200000 THEN 'Efsane'
WHEN SUM(od.UnitPrice * od.Quantity) BETWEEN 100000 AND 200000 THEN 'Yýldýz'
ELSE 'Geliþmekte'
END AS Durum
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY (e.FirstName + ' ' + e.LastName)
ORDER BY ToplamCiro DESC;

-- Kargo þirketlerinin paketleri ortalama kaç günde teslim ettiðini hesaplar.
SELECT s.CompanyName, AVG(DATEDIFF(DAY, o.OrderDate, o.ShippedDate)) AS OrtalamaHiz
FROM Shippers s
JOIN Orders o ON s.ShipperID = o.ShipVia
GROUP BY s.CompanyName
ORDER BY OrtalamaHiz ASC;

-- Stokta duran ama hiç sipariþ almamýþ 'ölü stok' ürünleri tespit eder.
SELECT p.ProductName, od.OrderID
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE od.OrderID IS NULL;

-- Ülke bazlý ortalama navlun maliyetlerini yüksekten düþüðe sýralar.
SELECT ShipCountry AS Ulke, AVG(Freight) AS OrtalamaNakliye
FROM Orders
GROUP BY ShipCountry
HAVING AVG(Freight) > 50
ORDER BY OrtalamaNakliye DESC;


-- Müþterileri toplam harcamalarýna göre segmentlere ayýrýr (Pazarlama stratejisi için).
SELECT o.CustomerID, SUM(od.UnitPrice * od.Quantity) AS Ciro,
CASE
WHEN SUM(od.UnitPrice * od.Quantity) > 10000 THEN 'VIP'
WHEN SUM(od.UnitPrice * od.Quantity) BETWEEN 5000 AND 10000 THEN 'Altýn'
ELSE 'Standart'
END AS Segment
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID;

-- Tedarikçilerin kaç farklý kategoride ürün saðladýðýný (ürün yelpazesi çeþitliliðini) bulur.
SELECT s.CompanyName, COUNT(DISTINCT p.CategoryID) AS KategoriCesitliligi
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.CompanyName
ORDER BY KategoriCesitliligi DESC