use spl_2016;
DROP TABLE IF EXISTS callNumber;
CREATE TABLE callNumber (
  itemNumber int(8) unsigned NOT NULL,
  callNumber varchar(64) NOT NULL DEFAULT '',
  UNIQUE KEY itemNumber_callNumber (itemNumber,callNumber),
  KEY itemNumber (itemNumber),
  KEY callNumber (callNumber)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS collectionCode;
CREATE TABLE collectionCode (
  itemNumber int(8) unsigned NOT NULL,
  collectionCode char(8) NOT NULL DEFAULT '',
  UNIQUE KEY itemNumber_collectionCode (itemNumber,collectionCode),
  KEY itemNumber (itemNumber),
  KEY collectionCode (collectionCode)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS deweyClass;
CREATE TABLE deweyClass (
  bibNumber int(8) unsigned NOT NULL,
  deweyClass char(3) DEFAULT NULL,
  UNIQUE KEY bibNumber_deweyClass (bibNumber,deweyClass),
  KEY bibNumber (bibNumber),
  KEY deweyClass (deweyClass)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS itemToBib;
CREATE TABLE itemToBib (
  itemNumber int(8) unsigned NOT NULL,
  bibNumber int(8) unsigned NOT NULL,
  UNIQUE KEY itemNumber_bibNumber (itemNumber,bibNumber),
  KEY itemNumber (itemNumber),
  KEY bibNumber (bibNumber)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS itemType;
CREATE TABLE itemType (
  itemNumber int(8) unsigned NOT NULL,
  itemType char(8) NOT NULL DEFAULT '',
  UNIQUE KEY itemNumber_itemType (itemNumber,itemType),
  KEY itemNumber (itemNumber),
  KEY itemType (itemType)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS subject;
CREATE TABLE subject (
  bibNumber int(8) unsigned NOT NULL,
  subject varchar(255) DEFAULT NULL,
  UNIQUE KEY bibNumber_subject (bibNumber,subject),
  KEY bibNumber (bibNumber),
  KEY subject (subject)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS title;
CREATE TABLE title (
  bibNumber int(8) unsigned NOT NULL,
  title varchar(255) DEFAULT NULL,
  UNIQUE KEY bibNumber_title (bibNumber,title),
  KEY bibNumber (bibNumber),
  KEY title (title)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
  checkOut datetime NOT NULL,
  checkIn datetime DEFAULT NULL,
  itemNumber int(10) unsigned NOT NULL,
  bibNumber int(10) unsigned NOT NULL,
  UNIQUE KEY primary_key (checkOut,checkIn,itemNumber,bibNumber),
  KEY checkOut (checkOut),
  KEY checkIn (checkIn),
  KEY bibNumber (bibNumber),
  KEY itemNumber (itemNumber)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

drop table if exists inraw;
create table inraw (
  id int(8) unsigned not null auto_increment,
  itemNumber int(8) unsigned default null,
  bibNumber int(8) unsigned default null,
  cout datetime default null,
  cin datetime default null,
  collcode char(8) default null,
  itemtype char(8) default null,
  barcode char(16) default null,
  title varchar(255) default null,
  callNumber varchar(64) default null,
  deweyClass varchar(12) default null,
  subj varchar(2047) default null,
  primary key (id),
  key itemNumber (itemNumber),
  key bibNumber (bibNumber),
  key cout (cout),
  key cin (cin),
  key collcode (collcode),
  key itemtype (itemtype),
  key barcode (barcode),
  key title (title),
  key callNumber (callNumber),
  key deweyClass (deweyClass)
) engine=MyISAM default charset=utf8;

drop table if exists outraw;
create table outraw (
  id int(8) unsigned not null auto_increment,
  itemNumber int(8) unsigned default null,
  bibNumber int(8) unsigned default null,
  cout datetime default null,
  cin datetime default null,
  collcode char(8) default null,
  itemtype char(8) default null,
  barcode char(16) default null,
  title varchar(255) default null,
  callNumber varchar(64) default null,
  deweyClass varchar(12) default null,
  subj varchar(2047) default null,
  primary key (id),
  key itemNumber (itemNumber),
  key bibNumber (bibNumber),
  key cout (cout),
  key cin (cin),
  key collcode (collcode),
  key itemtype (itemtype),
  key barcode (barcode),
  key title (title),
  key callNumber (callNumber),
  key deweyClass (deweyClass)
) engine=MyISAM default charset=utf8;
