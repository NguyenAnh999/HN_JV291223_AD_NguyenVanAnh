create database QUANLYBANHANG;
use QUANLYBANHANG;
create table CUSTOMERS
(
    customer_id varchar(4) primary key not null,
    name        varchar(100)           not null,
    email       varchar(100)           not null,
    phone       varchar(25)            not null,
    address     varchar(255)
);
create table ORDERS
(
    order_id     varchar(4) primary key not null,
    customer_id  varchar(4)             not null,
    foreign key (customer_id) references CUSTOMERS (customer_id),
    order_date   date                   not null,
    total_amount double                 not null

);
create table PRODUCTS
(
    product_id  varchar(4) primary key not null,
    name        varchar(255),
    description text,
    price       double                 not null,
    status      bit(1)
);
create table ORDERS_DETAILS
(
    order_id   varchar(4) not null,
    foreign key (order_id) references ORDERS (order_id),
    product_id varchar(4) not null,
    foreign key (product_id) references PRODUCTS (product_id),
    quantity   int(11)    not null,
    price      double     not null,
    primary key (order_id, product_id)
);
insert into CUSTOMERS (customer_id, name, email, phone, address)
values ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầy Giấy, Hà Nội'),
       ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
       ('C003', 'Tô Ngọc Vữ', 'Ivutn@gmail.com', '904725784', 'Mộc Châu, Sơn La'),
       ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
       ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng , Hà Nội');
insert into PRODUCTS (product_id, name, description, price, status)
values ('P001', 'Iphone 13 ProMax', 'Bản 512 GB xanh lá', 22999999, true),
       ('P002', 'Dell Vostro V3510', 'Core i5 RAM 8GB', 14999999, true),
       ('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', 28999999, true),
       ('P004', 'Apple Watch Ultra ', 'Titanium Alpine Loop Small', 18999999, true),
       ('P005', ' Airpods 2 2022', 'JSpatial Audio', 4090000, true);

INSERT INTO ORDERS (order_Id, customer_Id, total_amount, order_date)
VALUES ('H001', 'C001', 52999997, '2023-02-22'),
       ('H002', 'C001', 80999997, '2023-03-11'),
       ('H003', 'C002', 54359998, '2023-01-22'),
       ('H004', 'C003', 102999995, '2023-03-14'),
       ('H005', 'C003', 80999997, '2022-03-12'),
       ('H006', 'C004', 110449994, '2023-02-01'),
       ('H007', 'C004', 79999996, '2023-03-29'),
       ('H008', 'C005', 29999998, '2023-02-14'),
       ('H009', 'C005', 28999999, '2023-01-10'),
       ('H010', 'C005', 149999994, '2023-04-01');

INSERT INTO ORDERS_DETAILS (order_Id, product_Id, price, quantity)
VALUES ('H001', 'P002', 14999999, 1),
       ('H001', 'P004', 18999999, 2),
       ('H002', 'P001', 22999999, 1),
       ('H002', 'P003', 28999999, 2),
       ('H003', 'P004', 18999999, 2),
       ('H003', 'P005', 4090000, 4),
       ('H004', 'P002', 14999999, 3),
       ('H004', 'P003', 28999999, 2),
       ('H005', 'P001', 22999999, 1),
       ('H005', 'P003', 28999999, 2),
       ('H006', 'P005', 4090000, 5),
       ('H006', 'P002', 14999999, 6),
       ('H007', 'P004', 18999999, 3),
       ('H007', 'P001', 22999999, 1),
       ('H008', 'P002', 14999999, 2),
       ('H009', 'P003', 28999999, 1),
       ('H010', 'P003', 28999999, 2),
       ('H010', 'P001', 22999999, 4);
# Bài 3: Truy vấn dữ liệu [30 điểm]:
# 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
# [4 điểm]
select c.name, c.email, c.phone, c.address
from Customers c;

# 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
# thoại và địa chỉ khách hàng). [4 điểm]

select c.name, c.phone, c.address
from Customers c
where c.customer_id = any (select customer_id
                           from orders
                           where year(order_date) = 2023
                             and month(order_date) = 3);

# 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
# tháng và tổng doanh thu ). [4 điểm]

select month(o.order_date) as 'tháng', sum(o.total_amount) as 'tổng tiền'
from orders o
group by month(o.order_date), year(o.order_date);

# 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
# hàng, địa chỉ , email và số điên thoại). [4 điểm]

select c.name, c.phone, c.address
from Customers c
where c.customer_id not in (select customer_id
                            from orders
                            where year(order_date) = 2023
                              and month(order_date) = 2);

# 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
# sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]

select p.product_id, p.name, sum(o.quantity) as 'số lượng bán ra'
from ORDERS_DETAILS o
         join PRODUCTS P on o.product_id = P.product_id
         join ORDERS O2 on O2.order_id = o.order_id
where year(order_date) = 2023
  and month(order_date) = 3
group by o.product_id;

# 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
# tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]

select c.customer_id, c.name, sum(o.total_amount) 'mức tiêu'
from CUSTOMERS C
         join ORDERS O on c.customer_id = O.customer_id
where year(order_date) = 2023
group by c.customer_id;

# 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
# tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]

select c.name, o.total_amount, o.order_date, sum(od.quantity)
from CUSTOMERS c
         join ORDERS O on c.customer_id = O.customer_id
         join ORDERS_DETAILS OD on O.order_id = OD.order_id
group by o.order_id, c.customer_id, o.total_amount, o.order_date
having sum(od.quantity) >= 5;

# Bài 4:  Tạo View, Procedure [30 điểm]:
# 1. Tạo VIEW  lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
# tiền và ngày tạo hoá đơn . [3 điểm]

create view VIEW_HOADON as
select c.name, c.phone, c.address, o.order_date, o.total_amount
from CUSTOMERS c
         join ORDERS O on c.customer_id = O.customer_id;
select *
from VIEW_HOADON;
# 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
# số đơn đã đặt. [3 điểm]
create view TONG_HOADON as
select c.name, c.address, c.phone, count(o.order_id) 'số đơn đã đặt'
from ORDERS o
         join CUSTOMERS C on C.customer_id = o.customer_id
group by c.customer_id;
select *
from TONG_HOADON;
# 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
# bán ra của mỗi sản phẩm.
create view THONGTIN_SANPHAM as
select p.name, p.description, p.price, sum(od.quantity) 'lượng bán ra'
from PRODUCTS p
         join ORDERS_DETAILS OD on p.product_id = OD.product_id
group by p.product_id;
select *
from THONGTIN_SANPHAM;
# 4. Đánh Index cho trường `phone` và `email` của bảng Customer. [3 điểm]

create index phone_index on Customers (phone);
create index emai_index on Customers (email);

# 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]
delimiter //
create procedure VIEW_ALL(customeIdIn varchar(4))
begin
    select * from customers where customer_id = customeIdIn;
end//
delimiter ;

# 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]

delimiter //
create procedure GET_ALL_OF_PRODUCT()
begin
    select * from products;
end//
delimiter ;

# 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]
delimiter //
create procedure BILL_OF_CUSTOMER(customeIdIn varchar(4))
begin
    select * from ORDERS o where customeIdIn = o.customer_id;
end//
delimiter ;
# 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
# tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]

# delimiter //
# create procedure CREATE_ORDER(customerIDIn varchar(4), total_money double, oderDateIn date)
# begin
#     insert into ORDERS (order_id, customer_id, order_date, total_amount)
#     values (if(max(SUBSTRING(order_id, 2, 3)) < 9, concat('H00', max(SUBSTRING(order_id, 2, 3)) + 1), (
#         if(max(substring(order_id, 2, 3)) > 9, concat('H0', max(SUBSTRING(order_id, 2, 3)) + 1),
#            if(max(substring(order_id, 2, 3)) > 99, concat('H', max(SUBSTRING(order_id, 2, 3)) + 1),'hmax'
#            )))), customerIDIn, total_money, oderDateIn);
# end//
# delimiter ;
DELIMITER //
CREATE PROCEDURE CREATE_ORDER(customerIDIn VARCHAR(4), total_money DOUBLE, orderDateIn DATE)
BEGIN
    DECLARE new_order_id VARCHAR(4);
    SET new_order_id = (SELECT MAX(SUBSTRING(order_id, 2, 3)) FROM ORDERS);

    IF new_order_id < 9 THEN
        SET new_order_id = CONCAT('H00', (new_order_id + 1));
    ELSEIF new_order_id < 99 THEN
        SET new_order_id = CONCAT('H0', (new_order_id + 1));
    ELSEIF new_order_id < 999 THEN
        SET new_order_id = CONCAT('H', (new_order_id + 1));
    ELSE
        SET new_order_id = 'Hmax';
    END IF;

    INSERT INTO ORDERS (order_id, customer_id, order_date, total_amount)
    VALUES (new_order_id, customerIDIn, orderDateIn, total_money);
END //
DELIMITER ;
 call CREATE_ORDER('c005',28999998,'2023-02-01');
# 9. Tạo PROCEDURE  thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
# thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm]

delimiter //
create procedure GET_PRODUCT_OF_DATE(statDateIn date, endDateIn date)
begin
    select p.product_id, p.name, sum(o.quantity) as 'số lượng bán ra'
    from ORDERS_DETAILS o
             join PRODUCTS P on o.product_id = P.product_id
             join ORDERS O2 on O2.order_id = o.order_id
    where order_date between statDateIn and endDateIn
    group by o.product_id;
end//
delimiter ;

# 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
# giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. [3 điểm]

delimiter //
create procedure GET_PRODUCT_QUANTITY(yearIn int, monthIn int)
begin
    select p.product_id, p.name, sum(o.quantity) as 'số lượng bán ra'
    from ORDERS_DETAILS o
             join PRODUCTS P on o.product_id = P.product_id
             join ORDERS O2 on O2.order_id = o.order_id
    where year(order_date) = yearIn
      and month(order_date) = monthIn
    group by o.product_id;
end//
delimiter ;
call GET_PRODUCT_QUANTITY(2023,3);