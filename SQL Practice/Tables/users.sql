DROP TABLE USERS;

create table users (
    USER_ID VARCHAR(40),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    gender VARCHAR(50),
    ip_address VARCHAR(20)
);

SELECT * from USERS;

insert into
    USERS (
        USER_ID,
        FIRST_NAME,
        LAST_NAME,
        email,
        gender,
        ip_address
    )
values (
        'ee995cae-bdc0-4baa-8d3f-3dc2ef5bc4ad',
        'Deane',
        'Skittle',
        'dskittle0@parallels.com',
        'Male',
        '108.105.223.242'
    );