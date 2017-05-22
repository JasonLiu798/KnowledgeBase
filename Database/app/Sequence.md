
#mysql
```sql
CREATE TABLE `t_sequence` (
`sequence_name`  varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '序列名称' ,
`value`  int(11) NULL DEFAULT NULL COMMENT '当前值' ,
PRIMARY KEY (`sequence_name`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=COMPACT
;

--获取当前值
CREATE DEFINER = `root`@`localhost` FUNCTION `currval`(sequence_name varchar(64))
 RETURNS int(11)
BEGIN
    declare current integer;
    set current = 0;
    select t.value into current from t_sequence t where t.sequence_name = sequence_name;
    return current;
end;

--get next
CREATE DEFINER = `root`@`localhost` FUNCTION `nextval`(sequence_name varchar(64))
 RETURNS int(11)
BEGIN
    declare current integer;
    set current = 0;
    
    update t_sequence t set t.value = t.value + 1 where t.sequence_name = sequence_name;
    select t.value into current from t_sequence t where t.sequence_name = sequence_name;

    return current;
end;

--排它锁
CREATE DEFINER = `root`@`localhost` FUNCTION `nextval_safe`(sequence_name varchar(64))
 RETURNS int(11)
BEGIN
    declare current integer;
    set current = 0;
    
    select t.value into current from t_sequence t where t.sequence_name = sequence_name for update;
    update t_sequence t set t.value = t.value + 1 where t.sequence_name = sequence_name;
    set current = current + 1;

    return current;
end;
```
