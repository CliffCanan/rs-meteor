console.log("Reached FG-LINE.js")

$(document).ready(function ()
{
    console.log("Fg-Line.js -> document is ready");

    $('body').on('focus', '.form-control', function ()
    {
        console.log("FG-LINE - Checkpoint #1 - Input Focused")
        $(this).closest('.fg-line').addClass('fg-toggled');
    })

    $('body').on('blur', '.form-control', function ()
    {
        console.log("FG-LINE - checkpoint 2 - input blurred")

        var fgrp = $(this).closest('.form-group');
        var ipgrp = $(this).closest('.input-group');

        var val = $(this).val();

        if (fgrp.hasClass('fg-float') && val.length == 0) {
            $(this).closest('.fg-line').removeClass('fg-toggled');
        }
        else if (ipgrp.hasClass('fg-float') && val.length == 0) {
            $(this).closest('.fg-line').removeClass('fg-toggled');
        }
        else {
            $(this).closest('.fg-line').removeClass('fg-toggled');
        }
    });
});