#!/usr/bin/env raku
use v6.d;
say $=pod.raku;
=begin pod

=begin grid
    =row :header
        =for cell :row-span(2)
        Date
        =for cell :column-span(3)
        Samples
        =for cell :row-span(2)
        Mean
    =row :header
        =cell I<Sample 1>
        =cell I<Sample 2>
        =cell I<Sample 3>
    =row
    =column
        =cell 2023-03-08
        =cell 2023-04-14
        =cell 2023-06-23
    =column
        =cell 0.4
        =cell 0.8
        =cell 0.2
    =column
        =cell 0.1
        =cell 0.6
        =cell 0.9
    =column
        =cell 0.3
        =cell 0.5
        =cell 0.0
    =column
        =cell 0.26667
        =cell 0.63333
        =cell 0.36667
    =row
        =for cell :label
        Mean:
        =cell 0.46667
        =cell 0.53333
        =cell 0.26667
        =cell 0.42222
=end grid

=end pod