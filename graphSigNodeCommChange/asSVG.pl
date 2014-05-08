#!/usr/bin/env perl
use strict; use warnings;
use List::MoreUtils qw/distinct/;
use Data::Dumper;
use SVG;

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

my $r = 200;             # radius of the graph
my $smallDownscale = .1; # how much to downsample small brain representations
my $smallROIr = 2;       # how big rois are on small brain
my $largeROIr = 5;       # how big rois are on large brain

# define colors for each community
my %nodecol=( DM=>'red', 
              SM=>'green',
              V=>'purple',
              CO=>'black',
              O=>'black',
              FP=>'blue'   );

my @comms=qw/DM SM V CO FP/;

my %commLoc =( BB=> [ 0, 0] ,
                O=>  [0 , 0] ); # big brain and orphan

# position in a circle
for my $i (0..$#comms){
 $commLoc{$comms[$i]} = [$r * cos( ($i+1) * 2*3.14159/($#comms+1) ),
                         $r * sin( ($i+1) * 2*3.14159/($#comms+1) ) ];
}


# we could do this for each graph
# but we'd probably need to write out to a file for each graph

#for my $contrast (keys %graphs) {
# my $contrastHR = $graphs{$contrast};

  # define the contrast we want to work on
  my $contrastHR = $graphs{EC};

  # define SVG bigs
  my $svg=SVG->new(width=>500,height=>500);


  # for each old community in this contrast graph (eg. SM V OC FP DM)
  for my $oldCommunity ( keys %{$contrastHR} ) {
    
    #print "<!--# $oldCommunity-->\n";

    # get all the unique rois in this community ("old community")
    my @ROIS = distinct( map {$_->[0] }  @{ $contrastHR->{$oldCommunity}  } );

    my $color= $nodecol{$oldCommunity};

    for my $roi  (@ROIS) {

      # where we are
      #print "\t<!-- node $roinames{$roi}->{name} color $nodecol{$oldCommunity} -->\n";

      # TODO: this should be drawn first and _WITH ALL_ ROIs
      # draw dots for this community
      my @cords=@{$roinames{$roi}->{cords}}[0,1];
      $cords[1]=$cords[1]*-1;

      my @smallcords= map { $cords[$_] * $smallDownscale + $commLoc{$oldCommunity}[$_] } (0,1);
      
      # coordinate of this ROI in the plot space (using x and z)
      #print "\t", join(",",@smallcords ), " && ";
      $svg->circle(cx=>$smallcords[0], cy=>$smallcords[1], r=>$smallROIr, 
                   id=>$roi.'small'.$roinames{$roi}->{name}.$oldCommunity, fill=>$nodecol{$oldCommunity});


      # draw this ROI on big brain ( uinsg x an y maybe size by z)
      #print "\t",join(",", @cords), "\n";
      $svg->circle(cx=>$cords[0], cy=>$cords[1], r=>$largeROIr, 
                   id=>$roi.$roinames{$roi}->{name}, fill=>$nodecol{$oldCommunity});

    }

    #print "<!--# edges-->\n";
    # print a node color line for each ROI
    # contrast -> Network (old community) -> [  [ roi#, community, change, neg||pos], ... ]
    for my $edge (@{ $contrastHR->{$oldCommunity}  }) {

      my @roipos    = @{$roinames{$edge->[0]}->{cords}}[0,1];
      $roipos[1]=$roipos[1]*-1;
      my @compos    = @{$commLoc{$edge->[1]}}[0,1];
      my $edgecolor = $edge->[3] =~ /neg/?'#ffbbbb':'#bbffff'; # green if pos, red if neg

      #print  "\t", join(",",@$roipos) ," --> ",join(",",@$compos), "\n";
      $svg->line(x1=>$roipos[0], x2=>$compos[0],
                 y1=>$roipos[1], y2=>$compos[1],
                 style=>{'stroke' => $edgecolor, 'stroke-opacity'=>'0.7' } );
    }

    
  }
  print $svg->xmlify;
#}
