select a.inst_id,b.Total_MB, b.Total_MB - round(a.used_blocks*8/1024) Current_Free_MB,        
round(used_blocks*8/1024) Current_Used_MB, round(max_used_blocks*8/1024)             
Max_used_MB from gv$sort_segment a,  
(select round(sum(bytes)/1024/1024) Total_MB from dba_temp_files ) b; 

SELECT a.username, a.sid, a.serial#, a.osuser, b.tablespace, b.blocks, c.sql_text
FROM gv$session a, gv$tempseg_usage b, gv$sqlarea c
WHERE a.saddr = b.session_addr
AND c.address= a.sql_address
AND c.hash_value = a.sql_hash_value
ORDER BY b.tablespace, b.blocks

select s.sid, s.osuser, s. process, s.sql_id, tmp.segtype, ((tmp.blocks*8)/1024)MB, tmp.tablespace
from gv$tempseg_usage tmp, gv$session s
where tmp.session_num=s.serial# and segtype in ('HASH','SORT')
order by blocks desc;

select sql_id,sum(blocks) from gv$tempseg_usage group by sql_id order by 2 desc;

 SELECT   A.inst_id,A.tablespace_name tablespace, D.mb_total,
SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_used,
D.mb_total - SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_free
FROM     gv$sort_segment A,
(
SELECT   B.INST_ID,B.name, C.block_size, SUM (C.bytes) / 1024 / 1024 mb_total
FROM     gv$tablespace B, gv$tempfile C
WHERE    B.ts#= C.ts# and c.inst_id=b.inst_id
GROUP BY B.INST_ID,B.name, C.block_size
) D
WHERE   A.tablespace_name = D.name and A.inst_id=D.inst_id
GROUP by a.inst_id,A.tablespace_name, D.mb_total;

SELECT   S.INST_ID,S.sid || ',' || S.serial# sid_serial, S.username, S.osuser, 
P.spid pid, s.service_name,T.segtype ,
SUM (T.blocks)* TBS.block_size / 1024 / 1024 mb_used, T.tablespace,
COUNT(*) statements
FROM     gv$tempseg_usage T, gv$session S, dba_tablespaces TBS, gv$process P
WHERE    T.session_addr = S.saddr
AND      S.paddr = P.addr AND	 s.inst_id=p.inst_id and	 t.inst_id=p.inst_id
and	 s.inst_id=t.inst_id AND      T.tablespace = TBS.tablespace_name
having SUM (T.blocks) * TBS.block_size / 1024 / 1024>10
GROUP BY s.inst_id, S.sid, S.serial#, S.username, S.osuser, P.spid, 
S.Service_name,S.module,P.program, 
TBS.block_size, T.tablespace,segtype
ORDER BY mb_used;

SELECT A.tablespace_name tablespace, D.mb_total,
SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_used,
D.mb_total – SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_free
FROM v$sort_segment A,
( SELECT B.name, C.block_size, SUM (C.bytes) / 1024 / 1024 mb_total
FROM v$tablespace B, v$tempfile C
WHERE B.ts#= C.ts# GROUP BY B.name, C.block_size) D
WHERE A.tablespace_name = D.name GROUP by A.tablespace_name, D.mb_total;

– Temp segment usage per session.–
SELECT S.sid || ‘,’ || S.serial# sid_serial, S.username, S.osuser, P.spid, S.module,
P.program, SUM (T.blocks) * TBS.block_size / 1024 / 1024 mb_used, T.tablespace,
COUNT(*) statements
FROM v$sort_usage T, v$session S, dba_tablespaces TBS, v$process P
WHERE T.session_addr = S.saddr
AND S.paddr = P.addr
AND T.tablespace = TBS.tablespace_name
GROUP BY S.sid, S.serial#, S.username, S.osuser, P.spid, S.module,
P.program, TBS.block_size, T.tablespace
ORDER BY sid_serial;


SET PAUSE ON
SET PAUSE 'Press Return to Continue'
SET PAGESIZE 60
SET LINESIZE 300
 
SELECT 
   A.tablespace_name tablespace, 
   D.mb_total,
   SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_used,
   D.mb_total - SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_free
FROM    v$sort_segment A,
(SELECT    B.name,    C.block_size,    SUM (C.bytes) / 1024 / 1024 mb_total
FROM    v$tablespace B,    v$tempfile C
WHERE    B.ts#= C.ts# GROUP BY    B.name,    C.block_size) D
WHERE 
   A.tablespace_name = D.name
GROUP by    A.tablespace_name,    D.mb_total

-- temp usage by session
SELECT   S.sid || ',' || S.serial# sid_serial, S.username, S.osuser, P.spid, S.module,
         S.program, SUM (T.blocks) * TBS.block_size / 1024 / 1024 mb_used, T.tablespace,
         COUNT(*) sort_ops
FROM     v$sort_usage T, v$session S, dba_tablespaces TBS, v$process P
WHERE    T.session_addr = S.saddr
AND      S.paddr = P.addr
AND      T.tablespace = TBS.tablespace_name
GROUP BY S.sid, S.serial#, S.username, S.osuser, P.spid, S.module,
         S.program, TBS.block_size, T.tablespace
ORDER BY sid_serial;

-- sort space usage by statement
SELECT   S.sid || ',' || S.serial# sid_serial, S.username,
         T.blocks * TBS.block_size / 1024 / 1024 mb_used, T.tablespace,
         T.sqladdr address, Q.hash_value, Q.sql_text
FROM     v$sort_usage T, v$session S, v$sqlarea Q, dba_tablespaces TBS
WHERE    T.session_addr = S.saddr
AND      T.sqladdr = Q.address (+)
AND      T.tablespace = TBS.tablespace_name
ORDER BY S.sid;

