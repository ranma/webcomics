#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $url = 'http://www.pvponline.com/';

get_comics($url,
          { 'div' => sub { my ($tag, $parser, $info) = @_;
                           if (tag_property($tag, 'id', 'comic')) {
                               $info->{'image'} = $parser->get_tag('img')->[1]->{'src'};
                               $info->{'filename'} = basename($info->{'image'});
                           } elsif (tag_property($tag, 'id', 'navbar')) {
                               $info->{'next'} = $parser->get_tag('a')->[1]->{'href'};
                           }
                       }
          },
          \&file_exists);