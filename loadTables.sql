use spl_2016;

LOAD DATA
LOCAL INFILE '/home/weihao/csv/callNumber.csv' IGNORE
INTO TABLE callNumber
FIELDS TERMINATED BY ',' ESCAPED BY '\\'
LINES TERMINATED BY '\n' (
  itemNumber,
  callNumber
);

LOAD DATA
LOCAL INFILE '/home/weihao/csv/collectionCode.csv' IGNORE
INTO TABLE collectionCode
FIELDS TERMINATED BY ',' ESCAPED BY '\\'
LINES TERMINATED BY '\n' (
  itemNumber,
  collectionCode
);


LOAD DATA
LOCAL INFILE '/home/weihao/csv/deweyClass.csv' IGNORE
INTO TABLE deweyClass
FIELDS TERMINATED BY ',' ESCAPED BY '\\'
LINES TERMINATED BY '\n' (
  bibNumber,
  deweyClass
);

    
LOAD DATA
LOCAL INFILE '/home/weihao/csv/itemToBib.csv' IGNORE
INTO TABLE itemToBib
FIELDS TERMINATED BY ',' ESCAPED BY '\\'
LINES TERMINATED BY '\n' (
  itemNumber,
  bibNumber
);

LOAD DATA
LOCAL INFILE '/home/weihao/csv/itemType.csv' IGNORE
INTO TABLE itemType
FIELDS TERMINATED BY ',' ESCAPED BY '\\'
LINES TERMINATED BY '\n' (
  itemNumber,
  itemType
);

LOAD DATA
LOCAL INFILE '/home/weihao/csv/subject.csv' IGNORE
INTO TABLE subject
FIELDS TERMINATED BY ',' ESCAPED BY '\\'
LINES TERMINATED BY '\n' (
  bibNumber,
  subject
);

LOAD DATA
LOCAL INFILE '/home/weihao/csv/title.csv' IGNORE
INTO TABLE title
FIELDS TERMINATED BY ',' ESCAPED BY '\\'
LINES TERMINATED BY '\n' (
  bibNumber,
  title
);

LOAD DATA
LOCAL INFILE '/home/weihao/csv/transactions.csv' IGNORE
INTO TABLE transactions
FIELDS TERMINATED BY ',' ESCAPED BY '\\'
LINES TERMINATED BY '\n' (
  itemNumber,
  checkOut,
  checkIn,
  bibNumber
);


load data
local infile '/home/weihao/csv/inraw.csv'
into table inraw
  fields
    terminated by ','
    escaped by '\\'
    lines terminated by '\n'
  (
    itemNumber,
    bibNumber,
    cout,
    cin,
    collcode,
    itemtype,
    barcode,
    title,
    callNumber,
    deweyClass,
    subj
  );

load data
local infile '/home/weihao/csv/outraw.csv'
into table outraw
  fields
    terminated by ','
    escaped by '\\'
    lines terminated by '\n'
  (
    itemNumber,
    bibNumber,
    cout,
    cin,
    collcode,
    itemtype,
    barcode,
    title,
    callNumber,
    deweyClass,
    subj
  );
