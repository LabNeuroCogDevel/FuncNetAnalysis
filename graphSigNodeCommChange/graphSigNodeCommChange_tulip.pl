#!/usr/bin/env perl
use strict; use warnings;
use List::MoreUtils qw/distinct/;

# useful functions in RoiGraphs.pm
use lib './';
use RoiGraphs qw/roinames getContrastGraph/;
# N.B. run R script first to make txt/PCs.txt

### BUILD DATASTRUCT FROM txt

## read roi names using model in cwd
# roinames{1} => L_Gy_...
my %roinames = roinames('txt/labels_bb264_coords');

## read in graph file 
# store 3 graphs: EC LE AL
# contrast -> Network (old community) -> [  [ roi#, community, change, neg||pos], ... ]
my %graphs =  getContrastGraph('txt/sigPC_graph_long.txt'); 


### PRINT OUT GRAPH

# define colors for each community
my %nodecol=( DM=>'255,0,0', 
              SM=>'0,255,0',
              V=>'255,0,255',
              CO=>'0,0,0',
              O=>'0,0,0',
              FP=>'0,0,255'   );

# we could do this for each graph
# but we'd probably need to write out to a file for each graph

#for my $contrast (keys %graphs) {
# my $contrastHR = $graphs{$contrast};

  # define the contrast we want to work on
  my $contrastHR = $graphs{EC};

  # say that we are going to define colors
  print '(property 0 color "NodeColor"',"\n";

  # for each old community in this contrast graph (eg. SM V OC FP DM)
  for my $oldCommunity ( keys %{$contrastHR} ) {
    
    print "\t# $oldCommunity\n";
    # get all the unique rois in this community ("old community")
    my @ROIS = distinct( map {$_->[0] }  @{ $contrastHR->{$oldCommunity}  } );
    
    # print a node color line for each ROI
    print "\t(node $roinames{$_}->{name} ($nodecol{$oldCommunity}) )\n" for @ROIS;
  }

  # say we are done defining colors
  print ")\n";
#}
