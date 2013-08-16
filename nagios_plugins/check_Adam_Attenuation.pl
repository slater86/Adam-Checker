#!/usr/bin/perl

# Copyright (C) 2013  Matt Organ
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/
#
# This program uses the publicly available XML API offered by Adam Internet Pty. Ltd to gather and report usage information.
# details over at http://www.adam.com.au/info/api

use warnings;

# use modules
use XML::Simple;
use Data::Dumper;
use XML::LibXML;
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use DateTime;

# Token from your Adam Members Area https://members.adam.com.au/ to be taken from CMD
# e.g. username@pc:~$ Adam-Checker.pl ABCDEF123456
$Token = $ARGV[0] || die "No Token Given...Exiting!"; 

my $YesterdaysDate = DateTime->today()->subtract( days => 1 );

my $ua = LWP::UserAgent->new;

  $req = HTTP::Request->new(
     GET => 'https://members.adam.com.au/api');
  $req->header('Accept' => 'text/html');
  $req->authorization_basic('', $Token);

  # send request
  $res = $ua->request($req);

  # check the outcome and save the successful output
  if ($res->is_success) {
      $rawdata = $res->decoded_content ;
  }
  else {
     print "Error: " . $res->status_line . "\n";
  }

# read XML file
my $data = new XML::Simple->XMLin("$rawdata",);

my $Attenuation_Up=$data->{Customer}{Account}{ADSL}{AttenuationUp};
my $Attenuation_Down=$data->{Customer}{Account}{ADSL}{AttenuationDown};

print "OK - Attenuation is $Attenuation_Up Up, $Attenuation_Down Down |Attenuation_Up=$Attenuation_Up; Attenuation_Down=$Attenuation_Down;";

# access XML data
print "\n~~~~~~~~~~~~\nPlan Details\n~~~~~~~~~~~~\n\n";
print "$data->{Customer}{Account}{username} - $data->{Customer}{Account}{type} ";
print "$data->{Customer}{Account}{PlanType}\n";
print "$data->{Customer}{Account}{ByteQuota} Quota\n";
print "$data->{Customer}{Account}{SessionStart} Rollover Date\n";

print "$data->{Customer}{Account}{Usage}{LastUsageUpdate} - last Update\n";
foreach my $TotalUsage (@{$data->{Customer}->{Account}->{Usage}->{Bucket}}) {
        print $TotalUsage->{Usage}->{content} . " - ";
        print $TotalUsage->{desc} . " \n";
}

print "\n~~~~~~~~~~~~~~~~~~~~~~~\nCurrent Line Statistics\n~~~~~~~~~~~~~~~~~~~~~~~\n\n";
print "$data->{Customer}{Account}{ADSL}{SyncUp} Upload Speed\n";
print "$data->{Customer}{Account}{ADSL}{SyncDown} Download Speed\n";
print "$data->{Customer}{Account}{ADSL}{SNRUp} SNR Up\n";
print "$data->{Customer}{Account}{ADSL}{SNRDown} SNR Down\n";
print "$data->{Customer}{Account}{ADSL}{AttenuationUp} Attenuation up\n";
print "$data->{Customer}{Account}{ADSL}{AttenuationDown} Attenuation down\n";
print "Current IP Address - $data->{Customer}{Account}{IPAddresses}{IPv4Address}\n";

#print "\n~~~~~~~~~~~~~~~\nDaily Summaries\n~~~~~~~~~~~~~~~\n\n";
#foreach my $DailySummary (@{$data->{Customer}->{Account}->{DailySummary}->{Day}}) {
#        if ( $DailySummary->{date} =~ /$YesterdaysDate/ )
#        {
#        print "Summary for Yesterday - $DailySummary->{date} \n";
#        print $DailySummary->{Terminations} . " Dropouts\n";
#        print $DailySummary->{Bucket}{content} . " Download (Bytes)\n";
#        }
#}

#Debug (Prints all data returned and processed)
#print Dumper $data;

