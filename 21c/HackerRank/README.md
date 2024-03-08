The projects here were based in the HackerRank challenges that I solved.

I recommend you to create an user for those projects.

So, log into your Oracle environment as admin and run this:
<code>
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER [YOUR USERNAME] IDENTIFIED BY [YOUR PASSWORD] DEFAULT TABLESPACE USERS;
GRANT CREATE SESSION TO hackerrank;
GRANT DBA TO [YOUR USERNAME];
</code>
