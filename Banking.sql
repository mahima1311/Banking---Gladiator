create table bankuser(
    userId number,
    title varchar2(10),
    firstName varchar(50),
    middleName varchar(50),
    lastName varchar(50),
    mobileNo varchar(12),
    email varchar(50),
    aadhar varchar(50),
    dob date,
    netBankingEnabled number(1),
    debitEnabled number(1),
    constraint user_pk primary key (userId)
);

update bankuser set NetBankingEnabled = 0 where userId = 10006;
commit;

alter table bankuser add fatherName varchar2(100);
commit;

CREATE SEQUENCE bankUser_seq
START WITH     10001
INCREMENT BY   1;


update address set isPermanent = 1 where addressId = 2;

create table state(
    stateId number primary key,
    countryId number,
    stateName varchar2(50),
    constraint state_fk foreign key (countryId) references country(countryId)
);

alter table state add stateName varchar2(50);
alter table city add cityName varchar2(50);

create table city(
    cityId number primary key,
    stateId number,
    cityName varchar2(50),
    constraint city_fk foreign key (stateId) references state(stateId)
);

create table address(
    addressId number primary key,
    userId number not null,
    stateId number not null,
    cityId number not null,
    line1 varchar2(200),
    line2 varchar2(200),
    landmark varchar2(50),
    pincode number(7),
    isPermanent number(1),
    constraint address_user_fk foreign key (userId) references bankuser(userId),
    constraint address_state_fk foreign key (stateId) references state(stateId),
    constraint address_city_fk foreign key (cityId) references city(cityId)
);

CREATE SEQUENCE userAddress_seq
START WITH     1
INCREMENT BY   1;
select * from address;

create table occupation(
    occupationId number primary key,
    userId number not null,
    occupationType varchar2(50),
    sourceOfIncome varchar2(50),
    grossAnnual number,
    constraint occupation_user_fk foreign key (userId) references bankuser(userId)
);

CREATE SEQUENCE occupation_seq
START WITH     1
INCREMENT BY   1;

create table branch(
    branchId number primary key,
    branchName varchar2(100),
    ifsc varchar2(20)
);

create table branchAddress(
    addressId number primary key,
    branchId number not null,
    stateId number not null,
    cityId number not null,
    line1 varchar2(200),
    line2 varchar2(200),
    landmark varchar2(50),
    pincode number(7),
    constraint branchAddress_branch_fk foreign key (branchId) references branch(branchId),
    constraint branchAddress_state_fk foreign key (stateId) references state(stateId),
    constraint branchAddress_city_fk foreign key (cityId) references city(cityId)
);

create table account(
    accountNo number primary key,
    userId number not null,
    branchId number not null,
    accountType varchar2(50),
    balance number(8,2),
    constraint account_user_fk foreign key (userId) references bankuser(userId),
    constraint account_branch_fk foreign key (branchId) references branch(branchId)
);

CREATE SEQUENCE account_seq
START WITH  1600001   
INCREMENT BY 1;

CREATE SEQUENCE addBene_seq
START WITH     1
INCREMENT BY   1;

create table beneficiaries(
    beneficiaryAccNo number primary key,
    accountNo not null,
    beneficiaryName varchar2(200),
    bankName varchar2(100),
    ifsc varchar2(20),
    nickName varchar2(50),
    constraint beneficiary_account_fk foreign key (accountNo) references account(accountNo)
);


create table internetBanking(
    id number primary key,
    accountNo number not null,
    username number,
    password varchar2(50),
    transPass varchar2(50),
    impsUpperLimit number DEFAULT 50000,
    neftUpperLimit number DEFAULT 1000000,
    rtgsUpperLimit number DEFAULT 1000000,
    isBlocked number(1) DEFAULT 0,
    constraint internet_user_fk foreign key (username) references bankuser(userId),
    constraint internet_account_fk foreign key (accountNo) references account(accountNo)
);

CREATE SEQUENCE internetBanking_seq
START WITH     1
INCREMENT BY   1;

create table debit(
    debitId number primary key,
    accountNo number not null,
    debitCardNumber varchar(20),
    cvv number(4),
    pin number(6),
    isBlocked number(1),
    constraint debit_account_fk foreign key (accountNo) references account(accountNo)
);

CREATE SEQUENCE transaction_seq
START WITH     140001
INCREMENT BY   1;

create table transactions(
    transactionId number primary key,
    accountNo number not null,
    reason varchar2(200),
    type varchar2(10),
    startDate date,
    endDate date,
    amount number,
    flow varchar2(10),
    constraint transactions_account_fk foreign key (accountNo) references account(accountNo)
);

create table admin(
    adminId number primary key,
    name varchar2(200),
    username varchar2(50),
    password varchar2(50),
    role varchar2(20)
);

create table cust_repres(
    cId number primary key,
    name varchar2(200),
    username varchar2(50),
    password varchar2(50)
);

create table service_reference(
    serviceId number primary key,
    userId number not null,
    adminId number,
    cId number,
    status varchar2(20),
    remark varchar2(50),
    constraint service_user_fk foreign key (userId) references bankuser(userId),
    constraint service_admin_fk foreign key (adminId) references admin(adminId),
    constraint service_cust_fk foreign key (cId) references cust_repres(cId)
);

CREATE SEQUENCE service_reference_seq
START WITH     20001
INCREMENT BY   1;
