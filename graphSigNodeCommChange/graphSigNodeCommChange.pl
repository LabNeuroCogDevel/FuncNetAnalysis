#!/usr/bin/env perl
use strict; use warnings;

# useful functions in RoiGraphs.pm
use lib './';
use RoiGraphs qw/roinames getContrastGraph/;
# N.B. run R script first to make txt/PCs.txt

## read roi names using model in cwd
# roinames{1} => L_Gy_...
my %roinames = roinames('txt/labels_bb264_coords');

## read in graph file 
# store 3 graphs: EC LE AL
# contrast -> Network (old community) -> [  [ roi#, community, change, neg||pos], ... ]
my %graphs =  getContrastGraph('txt/sigPC_graph_long.txt'); 



my %nodecol= (DM=>'red', SM=>'green',V=>'purple', CO=>'black', FP=>'blue');
# print graph
for my $graphtype (keys %graphs) {

   open my $graphout ,">txt/PC_sigGraph_$graphtype.dot";
   print $graphout "digraph G {\n";
   print $graphout "\toverlap = false\n";

   # print the intial nodes
   print $graphout "\tsubgraph cluster_clusters {\n";
   print $graphout qq(\t\t$_ [label="$_"  color=$nodecol{$_}  shape=box]\n) for (keys %nodecol);
   print $graphout "\t}\n";

   for my $sgname (qw/DM SM V CO FP/) {
     print  $graphout "\tsubgraph cluster_$sgname {\n";

     # if subgraph does not have any nodes end it here
     if(! $graphs{$graphtype}->{$sgname}){
      print $graphout "}\n" ;
      next;
     }
     
     # declare nodes so we can color them
     print $graphout "\t\tnode [color=$nodecol{$sgname}]"; #for (distinct(map {@$_[0]} @{ $graphs{$graphtype}->{$sgname} }))

     # draw each edge between a node in this subgraph and the subgraph it changes with
     for my $edges (@{ $graphs{$graphtype}->{$sgname} }) {
       print  $graphout "\t\t$roinames{@$edges[0]}->{name} -> @$edges[1] [width=@$edges[2], color=@$edges[3]]\n"
     }
     # close the subgraph
     print  $graphout "\t}\n";
   }
   # close the graph
   print  $graphout "}\n";
   close $graphout;
}
