DECLARE      
v_count VARCHAR2(100);      

BEGIN      
UPDATE "FLY1"."awsdms_status" 
SET "server_name"='localhost.localdomain' 
    , "task_name"='ZRIP2CYWWJ7TSUGR3OVAVRY7MJWO53W6LI6X4QY' 
    , "task_status"='CHANGE PROCESSING' 
    , "status_time"='2020-08-31 20:24:39.000000000' 
    , "pending_changes"='0' 
    , "disk_swap_size"='0' 
    , "task_memory"='1010' 
    , "source_current_position"='000000000003E4A4010000010000003F000001D200100000000000000003E46F' 
    , "source_current_timestamp"='2020-08-31 20:24:35.000000000' 
    , "source_tail_position"='000000000003E4A4010000010000003F000001D200100000000000000003E46F' 
    , "source_tail_timestamp"='2020-08-31 20:24:35.000000000' 
    , "source_timestamp_applied"='2020-08-31 20:04:09.000000000' 
    WHERE "server_name"='localhost.localdomain' 
        AND "task_name"='ZRIP2CYWWJ7TSUGR3OVAVRY7MJWO53W6LI6X4QY'; 
    
    v_count:= SQL%ROWCOUNT; 
    if v_count = 0 then 
        INSERT INTO "FLY1"."awsdms_status" ( "server_name","task_name","task_status","status_time"
            ,"pending_changes","disk_swap_size","task_memory","source_current_position","source_current_timestamp"
            ,"source_tail_position","source_tail_timestamp","source_timestamp_applied" )  
        VALUES ( 'localhost.localdomain','ZRIP2CYWWJ7TSUGR3OVAVRY7MJWO53W6LI6X4QY','CHANGE PROCESSING'
            ,'2020-08-31 20:24:39.000000000','0','0','1010','000000000003E4A4010000010000003F000001D200100000000000000003E46F'
            ,'2020-08-31 20:24:35.000000000','000000000003E4A4010000010000003F000001D200100000000000000003E46F'
            ,'2020-08-31 20:24:35.000000000','2020-08-31 20:04:09.000000000'); 
    end if; 
END;
