


# 批量
## 更新
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






