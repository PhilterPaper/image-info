#!/usr/bin/perl -w

use strict;
use FindBin;
use Test::More 'no_plan';

use Image::Info qw(image_info);

# 2026-03-01 Strawberry Perl 5.34 has some sort of problem with this release
#   that causes this test to hard fail:
#
# Offset outside string at C:/Strawberry/perl/site/lib/Image/Info/TIFF.pm line 129.
# Unrecognised fieldtype 17, ignoring following entries
# not ok 1 - should not segfault
#   Failed test 'should not segfault'
#   at tiff_segfault.t line 10.
#   
# Other versions of Strawberry Perl work OK, and other non-Strawberry Perls 
# supposedly work OK, per RT 172758. Workaround: skip this test if MSWindows
# OS and Perl 5.34. Don't know if there's a way to detect specifically 
# Strawberry Perl, to add that check.

sub slurp ($) { open my $fh, shift or die $!; local $/; <$fh> }

SKIP: {
    skip "Do not test on Windows Perl 5.34 due to Strawberry Perl bug (RT 172758).",
      if $^O eq 'MSWin32' && $] >= 5.034 && $] < 5.036;

## test case for RT #100847
my $imgdata = slurp "$FindBin::RealBin/../img/segfault.tif";
my $info = image_info \$imgdata;
ok $info->{error}, 'should not segfault';
}
