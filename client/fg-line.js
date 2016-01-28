console.log("Reached FG-LINE.js")

$(document).ready(function ()
{
    console.log("Fg-Line.js -> document is ready");

    $('body').on('focus', '.form-control.fg-input', function ()
    {
        console.log("FG-LINE - Checkpoint #1 - Input Focused")
        $(this).closest('.fg-line').addClass('fg-toggled');
    })

    $('body').on('blur', '.form-control.fg-input', function ()
    {
        console.log("FG-LINE - checkpoint 2 - input blurred")

        var val = $(this).val();

        if (val.length == 0 && $(this).closest('.fg-line').hasClass('fg-toggled'))
        {
            $(this).closest('.fg-line').removeClass('fg-toggled');
        }
    });
});