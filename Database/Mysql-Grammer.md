


#批量相关
##批量更新
###replace into
```sql
  replace into test_tbl (id,dr) values (1,'2'),(2,'3'),...(x,'y');
```

###insert into ...on duplicate key update批量更新
```sql
  insert into test_tbl (id,dr) values (1,'2'),(2,'3'),...(x,'y') on duplicate key update dr=values(dr);
```
例子：insert into book (`Id`,`Author`,`CreatedTime`,`UpdatedTime`) values (1,'张飞2','2017-12-12 12:20','2017-12-12 12:20'),(2,'关羽2','2017-12-12 12:20','2017-12-12 12:20') on duplicate key update Author=values(Author),CreatedTime=values(CreatedTime),UpdatedTime=values(UpdatedTime);

replace into  和 insert into on duplicate key update的不同在于：
replace into 操作本质是对重复的记录先delete 后insert，如果更新的字段不全会将缺失的字段置为缺省值，用这个要悠着点否则不小心清空大量数据可不是闹着玩的。
insert into 则是只update重复记录，不会改变其它字段。



###update case
```sql
UPDATE categories 
    SET display_order = CASE id 
        WHEN 1 THEN 3 
        WHEN 2 THEN 4 
        WHEN 3 THEN 5 
    END, 
    title = CASE id 
        WHEN 1 THEN 'New Title 1'
        WHEN 2 THEN 'New Title 2'
        WHEN 3 THEN 'New Title 3'
    END
WHERE id IN (1,2,3)
```

###创建临时表，先更新临时表，然后从临时表中update
create temporary table tmp(id int(4) primary key,dr varchar(50));
insert into tmp values  (0,'gone'), (1,'xx'),...(m,'yy');
update test_tbl, tmp set test_tbl.dr=tmp.dr where test_tbl.id=tmp.id;
注意：这种方法需要用户有temporary 表的create 权限。






