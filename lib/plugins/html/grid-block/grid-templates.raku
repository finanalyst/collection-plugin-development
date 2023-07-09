#!/usr/bin/env raku
use v6.d;
%(
    grid => sub (%prm, %tml) {
        %prm<grid-block>.push: {
            pos => [0,0],
            dir => 'left',
            align => <left middle>
        }
    },
    row => sub (%prm, %tml) {

    },
    column => sub (%prm, %tml) {

    },
    cell => sub (%prm, %tml) {

    }
)