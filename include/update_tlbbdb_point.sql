UPDATE `tlbbdb`.`t_char` 
SET POINT_PARAM = POINT_NUM 
WHERE
	aid IN ( SELECT aid FROM ( SELECT aid FROM t_char WHERE accname = ACCNAME LIMIT 1 OFFSET USER_INDEX ) AS aids );
	