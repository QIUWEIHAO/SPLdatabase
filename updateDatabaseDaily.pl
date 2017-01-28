#!/usr/bin/perl -w

use strict;
use Encode;

my ($day, $month, $year) = (localtime(time))[3,4,5];
  $month += 1;
  $year += 1900;
system("perl /home/weihao/spldb/xmlToCsv.pl /aux/spl/data $year $month $day");
system("mysql --local-infile -u weihao -pJ89ha4q5i9hncoudn492u spl_2016 < /home/weihao/spldb/scripts/loadTables.sql");


