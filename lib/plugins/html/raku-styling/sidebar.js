$().ready( function() {
    $('#rakuCheckBox').click( function(e) {
        const sidebar = $('#raku-sidebar-cont');
        if (this.checked) {
            sidebar.width(0);
            sidebar.height(0);
        }
        else {
            sidebar.width('25vw');
            sidebar.height('auto');
        }
    });
    $('#sidebar-filter').keyup(function(e) {
        sText = $(this).val().toLowerCase();
        if (sText.length === 0) return;
        tocSel = 'td.toc-text a';
        $(tocSel).each(
            function() {
                if ($(this).text().toLowerCase().indexOf(sText) == -1) {
                    $(this).parent().parent().hide();
                } else {
                    $(this).parent().parent().show();
                }
        });
        $('.glossary-defn').each(
            function() {
                if ($(this).text().toLowerCase().indexOf(sText) > -1) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            }
        );
        $('.glossary-place a').each(
            function() {
                if ($(this).text().toLowerCase().indexOf(sText) > -1) {
                    $(this).parent().show();
                    $(this).parent().parent().prev().show();
                } else {
                    $(this).parent().hide();
                }
            }
        );
    });
});