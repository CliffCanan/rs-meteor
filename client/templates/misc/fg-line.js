console.log("Reached FG-LINE.js")

$('body').on('focus', '.form-control', function ()
{
    console.log("FG-LINE - Checkpoint #1 - Input Focused")
    $(this).closest('.fg-line').addClass('fg-toggled');
})

$('input.form-control.fg-input').focus(function ()
{
    console.log("FG-LINE - Checkpoint #2 - Input Focused")
    $(this).closest('.fg-line').addClass('fg-toggled');
})

$('input.form-control.fg-input').blur(function ()
{
    console.log("FG-LINE B - Checkpoint B - input blurred")

    var fgrp = $(this).closest('.form-group');

    console.log("FG-LINE B: this.val() is: ")
    console.log($(this).val());

    var val = fgrp.find('.form-control').val();

    console.log("FG-LINE B: val() is: ")
    console.log(val);

    if (fgrp.hasClass('fg-float')) {
        if (val.length == 0) {
            $(this).closest('.fg-line').removeClass('fg-toggled');
        }
    }
    else {
        $(this).closest('.fg-line').removeClass('fg-toggled');
    }
})

$('body').on('blur', '.form-control', function ()
{
    console.log("FG-LINE - checkpoint 2 - input blurred")

    var fgrp = $(this).closest('.form-group');
    var ipgrp = $(this).closest('.input-group');

    console.log("FG-LINE: this.val() is: ")
    console.log($(this).val());

    var val = fgrp.find('.form-control').val();
    var val2 = ipgrp.find('.form-control').val();

    console.log("FG-LINE: val() is: ")
    console.log(val);

    if (fgrp.hasClass('fg-float')) {
        if (val.length == 0) {
            $(this).closest('.fg-line').removeClass('fg-toggled');
        }
    }
    else if (ipgrp.hasClass('fg-float')) {
        if (val2.length == 0) {
            $(this).closest('.fg-line').removeClass('fg-toggled');
        }
    }
    else {
        $(this).closest('.fg-line').removeClass('fg-toggled');
    }
});