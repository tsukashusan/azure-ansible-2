CREATE USER '<AMBARIUSER>'@'%' IDENTIFIED BY '<AMBARIPASSWORD>';
GRANT ALL PRIVILEGES ON *.* TO '<AMBARIUSER>'@'%';
CREATE USER '<AMBARIUSER>'@'localhost' IDENTIFIED BY '<AMBARIPASSWORD>';
GRANT ALL PRIVILEGES ON *.* TO '<AMBARIUSER>'@'localhost';
CREATE USER '<AMBARIUSER>'@'<AMBARISERVERFQDN>' IDENTIFIED BY '<AMBARIPASSWORD>';
GRANT ALL PRIVILEGES ON *.* TO '<AMBARIUSER>'@'<AMBARISERVERFQDN>';
FLUSH PRIVILEGES;
