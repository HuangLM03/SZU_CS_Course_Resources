/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2024/12/13 19:18:30                          */
/*==============================================================*/


drop table if exists activity;

drop table if exists application;

drop table if exists audit;

drop table if exists log;

drop table if exists log_type;

drop table if exists manager;

drop table if exists manager_audit;

drop table if exists ordinary_user;

drop table if exists status;

drop table if exists student;

drop table if exists user_type;

/*==============================================================*/
/* Table: activity                                              */
/*==============================================================*/
create table activity
(
   activity_no          int not null auto_increment unique,
   status_no            int not null,
   log_ID               int,
   user_account         varchar(20) not null,
   activity_start_time  datetime,
   activity_location    varchar(64),
   activity_total_spots int,
   activity_content     text,
   activity_title       varchar(64) not null,
   activity_spots       int not null,
   activity_end_time    datetime,
   activity_leader      varchar(64),
   primary key (activity_no)
);

/*==============================================================*/
/* Table: application                                           */
/*==============================================================*/
create table application
(
   application_no       int not null auto_increment unique,
   activity_no          int not null,
   status_no            int not null,
   log_ID               int,
   user_account         varchar(20) not null,
   application_time     datetime,
   primary key (application_no)
);

/*==============================================================*/
/* Table: audit                                                 */
/*==============================================================*/
create table audit
(
   audit_no             int not null auto_increment unique,
   application_no       int,
   activity_no          int not null,
   status_no            int not null,
   log_ID               int,
   audit_time           datetime,
   primary key (audit_no)
);

/*==============================================================*/
/* Table: log                                                   */
/*==============================================================*/
create table log
(
   log_ID               int not null auto_increment unique,
   log_type_ID          int not null,
   application_no       int,
   activity_no          int,
   audit_no             int,
   log_content          text,
   primary key (log_ID)
);

/*==============================================================*/
/* Table: log_type                                              */
/*==============================================================*/
create table log_type
(
   log_type_ID          int not null auto_increment unique,
   log_type_name        varchar(64),
   primary key (log_type_ID)
);

/*==============================================================*/
/* Table: manager                                               */
/*==============================================================*/
create table manager
(
   user_account         varchar(20) not null,
   user_type_no         int not null,
   student_number       char(10) not null,
   user_password        varchar(20) not null,
   manager_ID           int not null auto_increment unique,
   primary key (user_account)
);

/*==============================================================*/
/* Table: manager_audit                                         */
/*==============================================================*/
create table manager_audit
(
   audit_no             int not null,
   user_account         varchar(20) not null,
   primary key (audit_no, user_account)
);

/*==============================================================*/
/* Table: ordinary_user                                         */
/*==============================================================*/
create table ordinary_user
(
   user_account         varchar(20) not null,
   user_type_no         int not null,
   student_number       char(10) not null,
   user_password        varchar(20) not null,
   ordinary_user_ID     int not null auto_increment unique,
   primary key (user_account)
);

/*==============================================================*/
/* Table: status                                                */
/*==============================================================*/
create table status
(
   status_no            int not null auto_increment unique,
   status_name          varchar(64) not null,
   primary key (status_no)
);

/*==============================================================*/
/* Table: student                                               */
/*==============================================================*/
create table student
(
   student_number       char(10) not null,
   student_name         varchar(64) not null,
   primary key (student_number)
);

/*==============================================================*/
/* Table: user_type                                             */
/*==============================================================*/
create table user_type
(
   user_type_no         int not null auto_increment unique,
   user_type_name       varchar(64) not null,
   primary key (user_type_no)
);

alter table activity add constraint FK_activity_log2 foreign key (log_ID)
      references log (log_ID) on delete restrict on update restrict;

alter table activity add constraint FK_activity_status foreign key (status_no)
      references status (status_no) on delete restrict on update restrict;

alter table activity add constraint FK_manager_activity foreign key (user_account)
      references manager (user_account) on delete restrict on update restrict;

alter table application add constraint FK_activity_application foreign key (activity_no)
      references activity (activity_no) on delete restrict on update restrict;

alter table application add constraint FK_application_log2 foreign key (log_ID)
      references log (log_ID) on delete restrict on update restrict;

alter table application add constraint FK_application_status foreign key (status_no)
      references status (status_no) on delete restrict on update restrict;

alter table application add constraint FK_ordinary_user_application foreign key (user_account)
      references ordinary_user (user_account) on delete restrict on update restrict;

alter table audit add constraint FK_audit_activity foreign key (activity_no)
      references activity (activity_no) on delete restrict on update restrict;

alter table audit add constraint FK_audit_log2 foreign key (log_ID)
      references log (log_ID) on delete restrict on update restrict;

alter table audit add constraint FK_audit_status foreign key (status_no)
      references status (status_no) on delete restrict on update restrict;

alter table log add constraint FK_activity_log foreign key (activity_no)
      references activity (activity_no) on delete restrict on update restrict;

alter table log add constraint FK_application_log foreign key (application_no)
      references application (application_no) on delete restrict on update restrict;

alter table log add constraint FK_audit_log foreign key (audit_no)
      references audit (audit_no) on delete restrict on update restrict;

alter table log add constraint FK_log_log_type foreign key (log_type_ID)
      references log_type (log_type_ID) on delete restrict on update restrict;

alter table manager add constraint FK_user_category foreign key (user_type_no)
      references user_type (user_type_no) on delete restrict on update restrict;

alter table manager add constraint FK_user_student foreign key (student_number)
      references student (student_number) on delete restrict on update restrict;

alter table manager_audit add constraint FK_manager_audit foreign key (audit_no)
      references audit (audit_no) on delete restrict on update restrict;

alter table manager_audit add constraint FK_manager_audit2 foreign key (user_account)
      references manager (user_account) on delete restrict on update restrict;

alter table ordinary_user add constraint FK_user_category2 foreign key (user_type_no)
      references user_type (user_type_no) on delete restrict on update restrict;

alter table ordinary_user add constraint FK_user_student2 foreign key (student_number)
      references student (student_number) on delete restrict on update restrict;

/* 触发器：在插入活动记录前根据时间判断活动的状态 */
DELIMITER $$

CREATE TRIGGER before_activity_insert
BEFORE INSERT ON activity
FOR EACH ROW
BEGIN
    DECLARE currentTime DATETIME;
    SET currentTime = NOW();

    IF currentTime < NEW.activity_start_time THEN
        SET NEW.status_no = 1;
    ELSEIF currentTime >= NEW.activity_start_time AND currentTime <= NEW.activity_end_time THEN
        SET NEW.status_no = 2;
    ELSE
        SET NEW.status_no = 3;
    END IF;
END$$

DELIMITER ;

/* 触发器：在更新活动记录前根据时间判断活动的状态 */
DELIMITER $$

CREATE TRIGGER after_activity_update
BEFORE UPDATE ON activity
FOR EACH ROW
BEGIN
    DECLARE currentTime DATETIME;
    SET currentTime = NOW();

    IF currentTime < NEW.activity_start_time THEN
        SET NEW.status_no = 1;
    ELSEIF currentTime >= NEW.activity_start_time AND currentTime <= NEW.activity_end_time THEN
        SET NEW.status_no = 2;
    ELSE
        SET NEW.status_no = 3;
    END IF;
END$$

DELIMITER ;

/* 触发器：在插入申请记录之前设置申请时间，申请状态，日志 */
DELIMITER $$

CREATE TRIGGER before_application_insert
BEFORE INSERT ON application
FOR EACH ROW
BEGIN
    SET NEW.status_no = 6;
    SET NEW.application_time = NOW();
    SET NEW.log_ID = NULL;
END$$

DELIMITER ;

/* 触发器：在插入申请记录后会同时生成一条审核记录 */
DELIMITER $$

CREATE TRIGGER after_application_insert
AFTER INSERT ON application
FOR EACH ROW
BEGIN
    INSERT INTO audit (application_no, status_no, log_ID, audit_time, activity_no)
    VALUES (NEW.application_no, 6, NULL, NULL, NEW.activity_no);
END$$

DELIMITER ;

/* 触发器：修改申请记录的状态，同时根据修改后的申请记录状态修改活动报名成功人数和审核状态 */
DELIMITER $$

CREATE TRIGGER after_application_update
AFTER UPDATE ON application
FOR EACH ROW
BEGIN
    IF OLD.status_no = 6 AND NEW.status_no = 4 THEN
        CALL updateActivitySpots(NEW.activity_no);
    END IF;
END$$

DELIMITER ;


/* 视图：在Activity表和status表中建立 */
CREATE VIEW activity_with_status AS
SELECT 
    a.activity_no,
    a.activity_start_time,
    a.activity_location,
    a.activity_total_spots,
    a.activity_content,
    a.activity_title,
    a.activity_spots,
    a.activity_end_time,
    a.activity_leader,
    s.status_name
FROM 
    activity a
LEFT JOIN 
    status s ON a.status_no = s.status_no;

/* 视图：包含前端审核记录需要的各种信息 */
CREATE VIEW audit_record_view AS
SELECT 
    s.student_name AS student_name,
    s.student_number AS student_number,
    app.user_account AS user_account,
    app.application_time AS application_time,
    ac.activity_title AS activity_title,
    st1.status_name AS application_status_name,
    st2.status_name AS audit_status_name,
    au.activity_no AS activity_no,
    au.application_no AS application_no,
    au.audit_no AS audit_no
FROM 
    audit au
JOIN application app ON au.application_no = app.application_no
JOIN activity ac ON app.activity_no = ac.activity_no
JOIN ordinary_user o_user ON app.user_account = o_user.user_account
JOIN status st1 ON app.status_no = st1.status_no
JOIN status st2 ON au.status_no = st2.status_no
JOIN student s ON o_user.student_number = s.student_number;


/* 存储过程：活动人数+1 */
DELIMITER $$

CREATE PROCEDURE updateActivitySpots(IN activityNo INT)
BEGIN
    UPDATE activity
    SET activity_spots = activity_spots + 1
    WHERE activity_no = activityNo;
END$$

DELIMITER ;

/* 索引：降序排序开始时间和结束时间 */
CREATE INDEX idx_activity_start_end_time ON activity (activity_start_time DESC, activity_end_time DESC);


/* 补充内容 */
DELIMITER $$

CREATE PROCEDURE UpdateActivityStatus()
BEGIN
    DECLARE currentTime DATETIME;
    SET currentTime = NOW();
    UPDATE activity
    SET status_no = CASE
        WHEN activity_end_time < currentTime THEN 3
        ELSE status_no
  END;
END$$

DELIMITER ;

DELIMITER $$

CREATE EVENT IF NOT EXISTS UpdateActivityStatusEvent
ON SCHEDULE EVERY 1 HOUR -- 每小时检查一次
DO CALL UpdateActivityStatus()$$

DELIMITER ;

SET GLOBAL event_scheduler = ON;