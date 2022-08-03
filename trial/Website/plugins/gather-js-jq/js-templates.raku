%( 
 jq-lib => sub (%prm, %tml) {
'<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>' 
},
js => sub (%prm, %tml) {'<script src="/assets/scripts/filter-script.js"></script>'
~ '<script src="/assets/scripts/ws-filter-scripts.js"></script>'
}
)
