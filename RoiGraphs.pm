#!/usr/bin/env perl

package RoiGraphs;

use strict; use warnings;
use Exporter qw(import);
our @EXPORT_OK = qw/roinames getContrastGraph/;

## read roi names
# $roinames{1} => 'L_Mid'
sub roinames {
   # give me a file name or i'll try txt/labels_bb264_coords
   my $filename=shift || 'txt/labels_bb264_coords';

   my $labelsFH;
   open $labelsFH, $filename;

   my %roinames;
   while(my @line= split(/\t/, <$labelsFH>)){
    $roinames{$line[0]} = $line[6]; 
    my %abbrvs = (Left=>'L', Right=>'R', Middle=>'Mid',Superior=>'Sup',
                  Temporal=>'Temp',Frontal=>'Front',Inferior=>'Inf',Medial=>'Med',
                  Nucleus=>'Nuc',Anterior=>'Ant',Cingulate=>'Cing',
                  Occipital=>'Occ',Gyrus=>'Gy'
                   ) ;
    while( my ($name, $abbrv) = each %abbrvs){
      $roinames{$line[0]} =~ s/$name/${abbrv}_/;
    }
    $roinames{$line[0]} =~ s/\s+//g;
    $roinames{$line[0]} =~ s/-/m/g;
    $roinames{$line[0]} =~ s/_$//g;
   }
   close $labelsFH;
   return %roinames;
};

# store 3 graphs: EC LE AL
# contrast -> Network (old community) -> [  [ roi#, community, change, neg||pos], ... ]
sub getContrastGraph{
  # get graph file from input or try reading from default location
  my $filename=shift||'txt/sigPC_graph_long.txt';

  my ($PCfh,%graphs);
  open $PCfh, $filename;
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
  return(%graphs);
};

1;
