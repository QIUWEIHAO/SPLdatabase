#!/usr/bin/perl -w

# Copyright 2012 Karl Yerkes

use strict;
use Encode;

# describe the usage of this program
#
my $USAGE =<<EOF;

Process George Legrady's SPL data (XML) into several CSV files
suitable for building a database.

  xmlToCsv.pl /path/to/spl/data

-- Karl Yerkes
EOF

# check for a known file to test out the path given
#
#@ARGV == 1 or die $USAGE;
my $dataFolderPath = $ARGV[0];
my $theYear = $ARGV[1];
my $theMonth = $ARGV[2];
my $theDay = $ARGV[3];
-d $dataFolderPath or die $!;
# -e "$dataFolderPath/2010/09/14/in-2010-09-14-19.xml" or die "bad data folder path";

# figure out what day it is
#
sub today {
  my ($day, $month, $year) = (localtime(time))[3,4,5];
  $month += 1;
  $year += 1900;
  return sprintf("%u %02u %02u", $year, $month, $day);
}
my $today = today();

# make a list of all the dates
#
sub numberOfDaysIn {
  my ($month, $year) = @_;
  if ($month == 2 && $year % 4 == 0) {
    return 29;
  }
  else {
    return (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[$month - 1];
  }
}
my @date = ();
#LOOP: {
#  for my $year (2006 .. 2024) {
#    for my $month (1 .. 12) {
#      for my $day (1 .. numberOfDaysIn($month, $year)) {
#        my $date = sprintf("%u %02u %02u", $year, $month, $day);
#        if ($date eq $today) {
#          last LOOP;
#        }
#        push @date, $date;
#      }
#    }
#  }
#}
my $theDate = sprintf("%u %02u %02u", $theYear, $theMonth, $theDay);
push @date, $theDate;
      print "$theDate\n";
# we'll use this later to escape strings
#
sub esc {
  my $s = shift;
  $s =~ s/\\/\\\\/sg;
  $s =~ s/,/\\,/sg;
  return $s;
}

# open all the output files
#

open ITEMTOBIB, '>:utf8', "/home/weihao/csv/itemToBib.csv" or die $!;
open TRANSACTIONS, '>:utf8', "/home/weihao/csv/transactions.csv" or die $!;
open COLLECTIONCODE, '>:utf8', "/home/weihao/csv/collectionCode.csv" or die $!;
open ITEMTYPE, '>:utf8', "/home/weihao/csv/itemType.csv" or die $!;
open ITEMTOBARCODE, '>:utf8', "/home/weihao/csv/itemToBarcode.csv" or die $!;
open TITLE, '>:utf8', "/home/weihao/csv/title.csv" or die $!;
open CALLNUMBER, '>:utf8', "/home/weihao/csv/callNumber.csv" or die $!;
open DEWEYCLASS, '>:utf8', "/home/weihao/csv/deweyClass.csv" or die $!;
open SUBJECT, '>:utf8', "/home/weihao/csv/subject.csv" or die $!;


# for all the 'in' files, then all the 'out' files
#
for my $inOut ('out', 'in') {

  # open a log to say stuff about each file
  #
  open LOG, ">$inOut-log.csv" or die $!;

  my $endTag = "</check$inOut" . 's>';

  my $transactionCount = 0;

  # open a utf8 file to save the rows (use latin1 instead?)
  #
  if ($inOut eq 'in') {
    open MAINOUTPUT, '>:utf8', "/home/weihao/csv/inraw.csv" or die $!;
  } else {
    open MAINOUTPUT, '>:utf8', "/home/weihao/csv/outraw.csv" or die $!;
  }

  # for each (year month day) including leap days
  #
  for my $date (@date) {
    my ($year, $month, $day) = split(' ', $date);
    my $path = "$dataFolderPath/$year/$month/$day";

    # for each hour
    #
    for my $hour (qw(00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23)) {
      my $fileName = "$inOut-$year-$month-$day-$hour.xml";

      # file is missing
      #
      if (! -e "$path/$fileName") {
        print LOG "$fileName,m,0,0\n";
        next;
      }

      # get file size
      #
      my $size = (stat "$path/$fileName")[7];

      # file has zero size
      #
      if ($size == 0) {
        print LOG "$fileName,z,0,0\n";
        next;
      }

      # slurp in the whole file raw, then decode as UTF-16LE
      #
      open IN, '<:raw', "$path/$fileName" || die "Couldn't open file: $!";
      $_ = decode('UTF-16LE', do { local $/; <IN> });
      close IN;

      my $state = '';

      # delete everything before the one-and-only xml header
      #
      my $x = 0;
      $x++ for /<\?xml/sg;
      if ($x > 1) {
        s/.*<\?xml version="1\.0" encoding="UTF-16"\?>//sg;
        $state .= 'x'; # (x)ml conjoined
      }

      # apply any/all single captured backspace. some titles and/or
      # call numbers have backspaces in them! so we have to repair those
      # by applying those backspaces
      #
      if (s/.[\b]//sg) {
        $state .= 'b'; # (b)ackspace found/corrected
      }

      # delete any/all of these silly characters. for some reason
      # (probably encoding mismatches) some titles and/or call numbers
      # have silly characters in them. delete those.
      #
      if (s/[\x01]//sg) {
        $state .= 'a'; # control-(a) found/corrected
      }
      if (s/[\x12]//sg) {
        $state .= 'h' # control-(h) found/corrected
      }

      # detect no end tag. some xml files are damaged (truncated, early
      # end of file), so we mark them as such.
      #
      if (! /$endTag/s) {
        $state .= 't'; # end (t)ag missing suggests damage
      }

      # delete incomplete final transaction if one exists
      #
      if (s|<transaction>(?:(?:(?!</transaction>).)*)\z||s) {
        $state .= 'i'; # (i)ncomplete transaction found, deleted
      }

      # convert to UTF-8 (use latin1 instead?)
      #
      $_ = encode('UTF-8', $_);

      # make a list of all transactions
      #
      my @transaction = m#<transaction>(.*?)</transaction>#sg;

      if (@transaction == 0) {
        $state .= 'e'; # (e)mpty, no transactions found
        print LOG "$fileName,$state,$size,0\n";
        next;
      }

      if ($state eq '') {
        $state = 'n';
      }

      my $n = scalar @transaction;
      print LOG "$fileName,$state,$size,$n\n";
      $transactionCount += $n;

      # for each transaction
      #
      for (@transaction) {

        my $itemNumber = '\\N';
        if (m#<itemNumber>(.+?)</itemNumber>#s) {
          $itemNumber = $1;
        }

        my $bibNumber = '\\N';
        if (m#<bibNumber>(.+?)</bibNumber>#s) {
          $bibNumber = $1;
        }
        print ITEMTOBIB "$itemNumber,$bibNumber\n";

        my $ckodate = '\\N';
        my $ckotime = '';
        if (m#<ckodate>(.+?)</ckodate>#s) {
          if ('20p5-12-02' eq $1) { # fix this one record with a botched date
            $ckodate = '2005-12-02';
          }
          else {
            $ckodate = $1;
          }
        }

        if (m#<ckotime>(.+?)</ckotime>#s) {
          $ckotime = $1;
        }

        my $ckidate = '\\N';
        my $ckitime = '\\N';

        if ($inOut eq 'in') {
          if (m#<ckidate>(.+?)</ckidate>#s) {
            $ckidate = $1;
          }
          if (m#<ckitime>(.+?)</ckitime>#s) {
            $ckitime = $1;
          }
        }
        if ($inOut eq 'in') {
          print TRANSACTIONS "$itemNumber,$ckodate $ckotime,$ckidate $ckitime,$bibNumber\n";
        }
        else {
          print TRANSACTIONS "$itemNumber,$ckodate $ckotime,\\N,$bibNumber\n";
        }

        my $collcode = '\\N';
        if (m#<collcode>(.+?)</collcode>#s) {
          $collcode = $1;
        }
        print COLLECTIONCODE "$itemNumber,$collcode\n";

        my $itemtype = '\\N';
        if (m#<itemtype>(.+?)</itemtype>#s) {
          $itemtype = $1;
        }
        print ITEMTYPE "$itemNumber,$itemtype\n";

        my $barcode = '\\N';
        if (m#<barcode>(.+?)</barcode>#s) {
          $barcode = $1;
        }
        print ITEMTOBARCODE "$itemNumber,$barcode\n";

        my $title = '';
        if (m#<title>(.+?)</title>#s) {
          $title = esc($1);
        }
        print TITLE "$bibNumber,$title\n";

        my $callNumber = '';
        if (m#<callNumber>(.+?)</callNumber>#s) {
          $callNumber = esc($1);
        }
        print CALLNUMBER "$itemNumber,$callNumber\n";

        my $deweyClass = '';
        if (m#<deweyClass>(.+?)</deweyClass>#s) {
          $deweyClass = esc($1);
        }
        print DEWEYCLASS "$bibNumber,$deweyClass\n";

        my @subject = m#<subject>(.+?)</subject>#sg;

        if (scalar @subject == 0) {
          print SUBJECT "$bibNumber,\n";
        }
        else {
          for (@subject) {
            my $subject = esc($_);
            print SUBJECT "$bibNumber,$subject\n";
          }
        }

        if ($inOut eq 'in') {
          print MAINOUTPUT "$itemNumber,$bibNumber,$ckodate $ckotime,$ckidate $ckitime,$collcode,$itemtype,$barcode,$title,$callNumber,$deweyClass\n";
        }
        else {
          print MAINOUTPUT "$itemNumber,$bibNumber,$ckodate $ckotime,\\N,$collcode,$itemtype,$barcode,$title,$callNumber,$deweyClass\n";
        }
      }

      print "$fileName: $transactionCount\n";
    }
  }

  close MAINOUTPUT;
}

close LOG;
