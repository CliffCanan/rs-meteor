$(document).ready(function ()
{
    $('body').on('focus', '.form-control.fg-input', function ()
    {
        $(this).closest('.fg-line').addClass('fg-toggled');
    })

    $('body').on('blur', '.form-control.fg-input', function ()
    {
        console.log("FG-LINE - checkpoint 2 - input blurred")

        var val = $(this).val();
        console.log(val)

        if (val.length == 0 && $(this).closest('.fg-line').hasClass('fg-toggled'))
        {
            console.log("FG-LINE - removing fg-toggled")
            $(this).closest('.fg-line').removeClass('fg-toggled');
        }
    });
});