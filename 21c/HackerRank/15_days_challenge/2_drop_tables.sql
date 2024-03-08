BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE hackerrank.tb_submission';
    EXECUTE IMMEDIATE 'DROP TABLE hackerrank.tb_hacker';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;