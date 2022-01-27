$(document).ready(function(){
    $('input[type=checkbox].singlecheck').on('change', function (e) {
        if ($("input[type=checkbox][name="+this.name+"]:checked").length > 1) {
            $(this).prop('checked', false);
        }
    });
}); 