sqlplus a/b <<EQ

declare
l_site tablea.site%TYPE;

v_count number;
v_sql varchar(4000);

begin
for l1 in (select s, b, a from taba)
loop
    for l2 in (select s, b, a from tabb b 
       where l1.a=b.counter
    loop
       dbms_output.put_line ('dfdd' || value);
   end loop;
end loop;
end;
/
exit;
EQ
