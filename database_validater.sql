
select itemNumber,callNumber from callNumber where (itemNumber,callNumber) not in (select distinct  itemNumber,callNumber from outraw) and (itemNumber,callNumber) not in (select distinct  itemNumber,callNumber from inraw) ;
select itemNumber,callNumber from inraw where (itemNumber,callNumber) not in (select itemNumber,callNumber from callNumber);
select itemNumber,callNumber from outraw where (itemNumber,callNumber) not in (select itemNumber,callNumber from callNumber);


select itemNumber,collectionCode from collectionCode where (itemNumber,collectionCode) not in (select distinct  itemNumber,collectionCode from outraw) and (itemNumber,collectionCode) not in (select distinct  itemNumber,collectionCode from inraw);
select itemNumber,collcode from outraw where (itemNumber,collcode) not in (select itemNumber,collectionCode from collectionCode);
select itemNumber,collcode from inraw where (itemNumber,collcode) not in (select itemNumber,collectionCode from collectionCode);


select bibNumber,deweyClass from deweyClass where (bibNumber,deweyClass) not in (select distinct  bibNumber,left(deweyClass,3) from outraw) and (bibNumber,deweyClass) not in (select distinct  bibNumber, left(deweyClass,3) from inraw) ;
select bibNumber, left(deweyClass , 3) from outraw where (bibNumber, left(deweyClass,3)) not in (select bibNumber,deweyClass from deweyClass);
select bibNumber, left(deweyClass , 3) from inraw where (bibNumber, left(deweyClass , 3)) not in (select bibNumber,deweyClass from deweyClass);


select itemNumber,bibNumber from itemToBib where (itemNumber,bibNumber) not in (select distinct  itemNumber,bibNumber from outraw) and (itemNumber,bibNumber) not in (select distinct  itemNumber,bibNumber from inraw) ;
select itemNumber,bibNumber from outraw where (itemNumber,bibNumber) not in (select itemNumber,bibNumber from itemToBib);
select itemNumber,bibNumber from inraw where (itemNumber,bibNumber) not in (select itemNumber,bibNumber from itemToBib);


select itemNumber,itemType from itemType where (itemNumber,itemType) not in (select distinct  itemNumber,itemType from outraw) and (itemNumber,itemType) not in (select distinct  itemNumber,itemType from inraw) ;
select itemNumber,itemType from outraw where (itemNumber,itemType) not in (select itemNumber,itemType from itemType);
select itemNumber,itemType from inraw where (itemNumber,itemType) not in (select itemNumber,itemType from itemType);



select bibNumber,title from title where (bibNumber,title) not in (select distinct  bibNumber,title from outraw) and (bibNumber,title) not in (select distinct  bibNumber,title from inraw) ;
select bibNumber,title from outraw where (bibNumber,title) not in (select bibNumber,title from title);
select bibNumber,title from inraw where (bibNumber,title) not in (select bibNumber,title from title);



