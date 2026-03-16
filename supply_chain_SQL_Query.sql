USE supply_chain_database;

SELECT COUNT(*) FROM supply_chain_data;

SET SQL_SAFE_UPDATES = 0;

DESCRIBE supply_chain_data;

ALTER TABLE supply_chain_data 
ADD total_cost DECIMAL(12,2);

UPDATE supply_chain_data
SET total_cost = `Manufacturing costs` + `Shipping costs`;

ALTER TABLE supply_chain_data 
ADD profit DECIMAL(12,2);

UPDATE supply_chain_data
SET profit = `Revenue generated` - total_cost;

ALTER TABLE supply_chain_data 
ADD profit_margin DECIMAL(6,2);

UPDATE supply_chain_data
SET profit_margin = (profit / `Revenue generated`) * 100;

ALTER TABLE supply_chain_data 
ADD delivery_status VARCHAR(20);

UPDATE supply_chain_data
SET delivery_status =
CASE 
    WHEN `Shipping times` <= `Lead times` THEN 'On-Time'
    ELSE 'Delayed'
END;

ALTER TABLE supply_chain_data 
ADD inventory_value DECIMAL(12,2);

UPDATE supply_chain_data
SET inventory_value = `Stock levels` * `Price`;

ALTER TABLE supply_chain_data 
MODIFY `Shipping carriers` VARCHAR(100);

ALTER TABLE supply_chain_data 
MODIFY `Supplier name` VARCHAR(150);

ALTER TABLE supply_chain_data 
MODIFY `SKU` VARCHAR(50);

CREATE INDEX idx_sku 
ON supply_chain_data(`SKU`);

CREATE INDEX idx_supplier 
ON supply_chain_data(`Supplier name`);

CREATE INDEX idx_carrier 
ON supply_chain_data(`Shipping carriers`);

CREATE VIEW vw_supplier_performance AS
SELECT 
    `Supplier name`,
    AVG(`Lead times`) AS avg_lead_time,
    AVG(`Defect rates`) AS avg_defect_rate,
    SUM(total_cost) AS total_supplier_cost,
    SUM(profit) AS total_profit
FROM supply_chain_data
GROUP BY `Supplier name`;

CREATE VIEW vw_carrier_performance AS
SELECT 
    `Shipping carriers`,
    AVG(`Shipping times`) AS avg_transit_time,
    SUM(`Shipping costs`) AS total_shipping_cost,
    COUNT(CASE WHEN delivery_status = 'Delayed' THEN 1 END) AS total_delays
FROM supply_chain_data
GROUP BY `Shipping carriers`;

CREATE VIEW vw_revenue_summary AS
SELECT 
    `Product type`,
    SUM(`Revenue generated`) AS total_revenue,
    SUM(total_cost) AS total_cost,
    SUM(profit) AS total_profit
FROM supply_chain_data
GROUP BY `Product type`;

SELECT * FROM supply_chain_data LIMIT 10;

SELECT COUNT(*) FROM vw_supplier_performance;
SELECT COUNT(*) FROM vw_carrier_performance;
SELECT COUNT(*) FROM vw_revenue_summary;

SHOW FULL TABLES 
WHERE TABLE_TYPE = 'VIEW';











