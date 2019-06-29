var $animation_elements = $('.check-in-view');
var $window = $(window);
function check_if_in_view() {
    var window_height = $window.height();
    var window_top_position = $window.scrollTop();
    var window_bottom_position = (window_top_position + window_height);

    $.each($animation_elements, function () {
        var $element = $(this);
        var element_height = $element.outerHeight();
        var element_top_position = $element.offset().top;
        var element_bottom_position = (element_top_position + element_height);

        //check to see if this current container is within viewport
        if ((element_bottom_position >= window_top_position) &&
            (element_top_position <= window_bottom_position) && ($(window).width() > 991)) {
            $(".it-tm").find(".slide-tm-1").stop(true, true).delay(500).animate({
                right: '5%',
                opacity:'1'
            }, 600, "easeOutQuart");

            $(".it-dv").find(".slide-dv-1").stop(true, true).delay(500).animate({
                right: '30%',
                opacity: '1'
            }, 600, "easeOutQuart");

            $(".it-dv").find(".slide-dv-2").stop(true, true).delay(900).animate({
                right: '5%',
                opacity: '1'
            }, 600, "easeOutQuart");
        //} else {
        //    $(".it-tm").find(".slide-tm-1").stop(true, true).delay(500).animate({
        //        right: '-100%',
        //        opacity: '0'
        //    }, 600, "easeOutQuart");

        //    $(".it-dv").find(".slide-dv-1").stop(true, true).delay(500).animate({
        //        right: '-100%',
        //        opacity: '0'
        //    }, 600, "easeOutQuart");

        //    $(".it-dv").find(".slide-dv-2").stop(true, true).delay(900).animate({
        //        right: '-100%',
        //        opacity: '0'
        //    }, 600, "easeOutQuart");
        }
    });
};
$window.on('scroll resize', check_if_in_view);
$window.trigger('scroll');