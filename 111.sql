CREATE DATABASE `store_db`;
USE `store_db`;



-- 建立中山書局資料庫

-- 1.會員資料表
CREATE TABLE `Member` (
  `mId` CHAR(8) NOT NULL,
  `pId` CHAR(20) NOT NULL,
  `name` VARCHAR(8) NOT NULL,
  `birthday` DATE,
  `phone` VARCHAR(10),
  `address` VARCHAR(40),
  `email` VARCHAR(20),
  `introducer` CHAR(8),
  PRIMARY KEY (mId),
  UNIQUE (pId),
  FOREIGN KEY (introducer) REFERENCES Member(mId)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

ALTEr TABLE `Member` MODIFY `phone` VARCHAR(20) NOT NULL; 

-- 2.交易表
CREATE TABLE `Transaction` (
  `tNo` CHAR(5) NOT NULL,
  `transMid` CHAR(8) NOT NULL,
  `transTime` DATETIME NOT NULL,
  `method` VARCHAR(5) NOT NULL,
  `bankId` VARCHAR(14),
  `bankName` VARCHAR(20),
  `cardType` VARCHAR(10),
  `cardId` VARCHAR(10),
  `dueDate` DATE,
  PRIMARY KEY (tNo),
  FOREIGN KEY (transMid) REFERENCES Member(mId)
);

-- 3.商品表
CREATE TABLE `Product` (
  `pNo` CHAR(6) NOT NULL,
  `pName` VARCHAR(30),
  `unitPrice` DECIMAL(10,2),
  `category` VARCHAR(20),
  PRIMARY KEY (pNo),
  CONSTRAINT UnitPrice_Check CHECK (unitPrice > 100)
);

-- 4.作者
CREATE TABLE `Author` (
  `pNo` CHAR(6) NOT NULL,
  `name` VARCHAR(8) NOT NULL,
  PRIMARY KEY (pNo, name),
  FOREIGN KEY (pNo) REFERENCES Product(pNo)
);

-- 5.瀏覽紀錄
CREATE TABLE `Browse` (
  `mId` CHAR(8) NOT NULL DEFAULT 'a0910001',
  `pNo` CHAR(6) NOT NULL,
  `browseTime` DATETIME NOT NULL,
  PRIMARY KEY (`mId`, `pNo`, `browseTime`),
  FOREIGN KEY (`mId`) REFERENCES Member(`mId`)
    ON DELETE SET DEFAULT
    ON UPDATE CASCADE,
  FOREIGN KEY (`pNo`) REFERENCES `Product`(`pNo`)
);

-- 6.購物車列表
CREATE TABLE `Cart` (
  `mId` CHAR(8) NOT NULL,
  `cartTime` DATETIME NOT NULL,
  `tNo` CHAR(5),
  PRIMARY KEY (`mId`, `cartTime`),
  FOREIGN KEY (`tNo`) REFERENCES `Transaction`(`tNo`)
    ON UPDATE CASCADE,
  FOREIGN KEY (`mId`) REFERENCES Member(`mId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- 7.訂單內容
CREATE TABLE `Order` (
  `pNo` CHAR(6),
  `mId` CHAR(8) NOT NULL,
  `cartTime` DATETIME NOT NULL,
  `amount` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`pNo`, `mId`, `cartTime`),
  FOREIGN KEY (`pNo`) REFERENCES `Product`(`pNo`),
  FOREIGN KEY (`mId`, `cartTime`) REFERENCES `Cart`(`mId`, `cartTime`)
);

-- 8.銷售紀錄
CREATE TABLE `Record` (
  `tNo` CHAR(5),
  `pNo` CHAR(6),
  `salePrice` DECIMAL(10,2) NOT NULL,
  `amount` INT NOT NULL,
  PRIMARY KEY (`tNo`, `pNo`),
  FOREIGN KEY (`tNo`) REFERENCES `Transaction`(`tNo`),
  FOREIGN KEY (`pNo`) REFERENCES `Product`(`pNo`)
);
USE store_db;

INSERT INTO `Member` VALUES
('b0905555','C200456789','Jennifer','1974-03-04','07-2221111','高雄市五福三路300號','jen33@ms3.hinet.net',NULL),
('b0922468','R100200300','Jackson','1980-03-30','06-3210321','台南市中華路600號','jack99@ms9.hinet.net',NULL);
INSERT INTO `Member` VALUES
('a0910001','A220123456','Jenny','1979-01-01','02-22220011','台北市中山北路100號','jenny@ms1.hinet.net','b0905555'),
('a0911234','A122555888','Tony','1980-12-12','02-22880099','台北市羅斯福路200號','tony@ms1.hinet.net','a0910001'),
('c0927777','B123123123','Su','1982-06-06','07-2345678','高雄市蓬海路70號','su88@ms2.hinet.net','b0905555'),
('a0921111','A100999777','David','1975-11-22','04-2468888','台中市中港路200號','david@ms1.hinet.net','a0911234');

INSERT INTO `Product` VALUES
('b30999','資料庫理論與實務',500,'Book'),
('d11222','任賢齊專輯三',300,'CD'),
('b20666','OLAP進階',500,'Book'),
('b10234','管理資訊系統概論',600,'Book'),
('b40555','系統分析理論與實務',550,'Book'),
('b20777','蔡依林專輯二',350,'CD'),
('v01888','哈利波特：混血王子的背叛',450,'DVD'),
('d03333','5566專輯',450,'CD'),
('b51111','電子商務理論與實務',700,'Book'),
('v00111','英雄',400,'DVD');

INSERT INTO `Author` VALUES
('b30999','Huang'),
('b10234','Lin'),
('d11222','William'),
('b20666','Sandra'),
('b40555','Wu'),
('b20777','Jolin'),
('v01888','J.K.'),
('b51111','Lai'),
('b51111','Huang'),
('b51111','Lin'),
('d03333','Jackey'),
('d03333','David'),
('d03333','Tom');

INSERT INTO `Transaction` VALUES
('91100','a0911234','2005-02-02 18:30:00','cart','010','tb','visa','987654321','2008-01-01'),
('92666','c0927777','2005-10-10 22:10:3','cart','020','fb','visa','123456789','2006-12-31'),
('91888','a0910001','2005-09-10 10:10:00','fax','040','cb','master','777888888','2007-10-10'),
('92333','c0927777','2005-10-15 09:00:00','email','070','sb','visa','111122222','2007-12-31'),
('90111','b0905555','2005-05-05 12:30:30','cart','020','fb','master','444455555','2006-01-01'),
('92555','b0922468','2005-11-11 09:10:00','cart','010','fb','visa','333300000','2007-01-01');



INSERT INTO `Browse` VALUES
('a0911234','b30999','2005-02-02 17:30:00'),
('a0911234','b20666','2005-02-02 17:50:00'),
('b0905555','v01888','2005-05-05 11:40:30'),
('c0927777','d11222','2005-10-10 21:30:30'),
('c0927777','b20777','2005-10-10 21:40:00'),
('c0927777','v00111','2005-10-10 21:50:00'),
('b0922468','b10234','2005-11-01 22:00:00'),
('b0922468','b40555','2005-11-10 12:00:30'),
('a0910001','b40555','2005-09-09 10:00:00');

INSERT INTO `Browse` VALUES
('a0911234','b10234','2006-01-05 14:12:33'),
('b0905555','b30999','2006-02-10 09:25:10'),
('c0927777','v00111','2006-03-18 20:40:55'),
('b0922468','d03333','2006-04-22 16:05:00'),
('a0921111','b51111','2006-05-30 11:33:21'),
('a0910001','b20666','2006-06-12 13:50:45'),
('c0927777','b40555','2006-07-08 18:15:05'),
('b0905555','v01888','2006-08-19 21:09:30');

INSERT INTO `Cart` VALUES
('c0927777','2005-10-10 22:00:00','92666'),
('b0905555','2005-05-05 12:00:00','90111'),
('a0911234','2005-02-02 18:00:30','91100'),
('b0922468','2005-11-11 09:00:30','92555'),
('a0910001','2005-09-09 10:00:10',NULL);

INSERT INTO `Order` VALUES
('b30999','a0911234','2005-02-02 18:00:30',1),
('v01888','b0905555','2005-05-05 12:00:00',3),
('d11222','c0927777','2005-10-10 22:00:00',1),
('b20777','c0927777','2005-10-10 22:00:00',1),
('v00111','c0927777','2005-10-10 22:00:00',2),
('b10234','b0922468','2005-11-11 09:00:30',5),
('b40555','b0922468','2005-11-11 09:00:30',10),
('d11222','a0910001','2005-09-09 10:00:10',1);

INSERT INTO `Record` VALUES
('91100','b30999',450,1),
('90111','v01888',1350,3),
('92555','b10234',3000,5),
('92555','b40555',5000,10),
('91888','b40555',1650,3),
('91888','d03333',850,2),
('91888','d11222',300,1),
('92666','b20777',350,1),
('92666','v00111',800,2),
('92333','b51111',700,1);
SELECT m.mId, m.name
FROM Member m
WHERE NOT EXISTS (
   
    SELECT 1
    FROM Author a
    WHERE a.name = 'Jackey'
    AND NOT EXISTS (
        
        SELECT 1
        FROM Record r
        JOIN Transaction t ON r.tNo = t.tNo
        WHERE r.pNo = a.pNo
        AND t.transMid = m.mId
    )
   
);


