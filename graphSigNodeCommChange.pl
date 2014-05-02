#!/usr/bin/env perl
use strict; use warnings;
# N.B. run R script first to make txt/PCs.txt

# read roi names
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
}
close $labelsFH;


my %graphs; # store 3 graphs: EC LE AL

open my $PCfh, 'txt/PCs.txt';
my @header = split /\s+/, <$PCfh>;

# read in all the graphs, subgraphs,and nodes
while(my @line= split(/\s+/, <$PCfh>)){
 my %line = map { $header[$_] => $line[$_] } (0..$#line);

 # for each communities degree change
 for my $comm (qw/ΔDM ΔSM ΔV ΔCO ΔFP/){
   my $change = sprintf("%.0f",$line{$comm});  # round decimal to a whole number
   next if abs($change) == 0;                # skip anything too small
   my $posneg = $change>0?"red":"blue";      # is it positive or negative

   my $com = $comm;
   $com =~ s/Δ//;                           # get rid of the delta

   # each graph has a subgraph with an array of [ node,subgraph connection, weight,class ]
   push @{ $graphs{ $line{grpcmp} }->{ $line{OldCommunity} } }, [$line{ROI},$com,abs($change),$posneg]
 }
}
close $PCfh;

# print graph
for my $graphtype (keys %graphs) {

   open my $graphout ,">txt/PC_sigGraph_$graphtype.dot";
   print $graphout "digraph G {\n";
   # TODO: add colored nodes outside subgraph: qw/DM SM V CO FP/
   #print $graphout "node $_;\n" for (qw/DM SM V CO FP/);
   for my $sgname (qw/DM SM V CO FP/) {
     print  $graphout "\tsubgraph cluster_$sgname {\n";

     # if subgraph does not have any nodes end it here
     if(! $graphs{$graphtype}->{$sgname}){
      print $graphout "}\n" ;
      next;
     }
     
     # draw each edge between a node in this subgraph and the subgraph it changes with
     for my $edges (@{ $graphs{$graphtype}->{$sgname} }) {
       print  $graphout "\t\t$roinames{@$edges[0]} -> @$edges[1] [width=@$edges[2], color=@$edges[3]]\n"
     }
     # close the subgraph
     print  $graphout "\t}\n";
   }
   # close the graph
   print  $graphout "}\n";
   close $graphout;
}
