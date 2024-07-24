USE mariadb;
-- Using the root user, grant access to the mariadb user.
GRANT ALL PRIVILEGES ON * TO 'root' @'%' IDENTIFIED BY 'mariadb';

-- Example project
CREATE OR REPLACE DATABASE example COMMENT 'example';

-- Intro project
CREATE OR REPLACE DATABASE minerva COMMENT 'minerva';
