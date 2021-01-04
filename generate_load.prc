---------------------------------------
-- generate ticket purchase activity
---------------------------------------
PROCEDURE genActivity(delay NUMBER, max_txs IN NUMBER DEFAULT 1000) IS
 tx_count NUMBER := 0;

BEGIN
  WHILE tx_count < max_txns LOOP
    YourProcCall;
    tx_count := tx_count +1;
    dbms_lock.sleep(delay);
  END LOOP;
END;
