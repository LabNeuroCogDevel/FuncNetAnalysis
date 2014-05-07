#!/usr/bin/env perl
use strict; use warnings;
use List::MoreUtils qw/distinct/;
# N.B. run R script first to make txt/PCs.txt

### BUILD DATASTRUCT FROM txt

## read roi names
open my $labelsFH, 'txt/labels_bb264_coords';
my %roinames;
while(my @line= split(/\t/, <$labelsFH>)){
 $roinames{$line[0]} = $line[6]; 
 my %abbrvs = (Left=>'L', Right=>'R', Middle=>'Mid',Superior=>'Sup',
               Temporal=>'Temp',Frontal=>'Front',Inferior=>'Inf',Medial=>'Med',
                ) ;
 while( my ($name, $abbrv) = each %abbrvs){
   $roinames{$line[0]} =~ s/$name/${abbrv}_/;
 }
 $roinames{$line[0]} =~ s/\s+//g;
 $roinames{$line[0]} =~ s/-/m/g;
}
close $labelsFH;


## read in graph file 

my %graphs; # store 3 graphs: EC LE AL

open my $PCfh, 'txt/sigPC_graph_long.txt';
my @header = split /\s+/, <$PCfh>;

# read in all the graphs, subgraphs,and nodes
while(my @line= split(/\s+/, <$PCfh>)){
 my %line = map { $header[$_] => $line[$_] } (0..$#line);

 # for each communities degree change
 for my $comm (qw/ΔDM ΔSM ΔV ΔCO ΔFP/){
   my $change = sprintf("%.0f",$line{$comm});  # round decimal to a whole number
   next if abs($change) == 0;                # skip anything too small
   my $posneg = $change>0?"crimson":"darkgreen";      # is it positive or negative

   my $com = $comm;
   $com =~ s/Δ//;                           # get rid of the delta

   # each graph has a subgraph with an array of [ node,subgraph connection, weight,class ]
   push @{ $graphs{ $line{grpcmp} }->{ $line{OldCommunity} } }, [$line{ROI},$com,abs($change),$posneg]
 }
}
close $PCfh;


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
    print "\t(node $roinames{$_} ($nodecol{$oldCommunity}) )\n" for @ROIS;
  }

  # say we are done defining colors
  print ")\n";
#}
