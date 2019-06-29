(function ($) {
    $(window).load(function () {
        EqualSizer('.bot-head .policy .item');
        EqualSizer_1('.wrap-recom .item .wrap-item');
        line_height();
        re_img();
        addNum();

    });
    $(window).resize(function () {
        line_height();
        re_img();
    });
    $(function () {
        myfunload();
        EqualSizer('.bot-head .policy .item');
        EqualSizer_1('.wrap-recom .item .wrap-item');

        //AsideMenu();
        logUser();
        get_val();
        getEmail();
        $('.content-slide .owl-item:last-child()').find('.item').append('<div class="show-more"><a href="#">Xem tất cả</a></div>');
    });
})(jQuery);
//function===============================================================================================
/*=============================fun=========================================*/
function myfunload() {
    $(".panel-a").mobilepanel();
    $("#menu > li").not(".home").clone().appendTo($("#menuMobiles"));
    $("#menuMobiles input").remove();
    $("#menuMobiles > li > a").append('<span class="fa fa-chevron-circle-right iconar"></span>');
    $("#menuMobiles li li a").append('<span class="fa fa-angle-right iconl"></span>');
    $("#menu > li:last-child").addClass("last");
    $("#menu > li:first-child").addClass("fisrt");

    $("#menu > li").find("ul").addClass("menu-level");

    $('#menu li').hover(function () {
        $(this).children('ul').stop(true, false, true).slideToggle(300);
    });

    $('.link-web li').hover(function () {
        $(this).children('ul').stop(true, false, true).slideToggle(300);
    });

    $('.form-left > p').click(function () {
        var n = $(this).parent();
        n.children('.choice-option').children('ul').stop(true, false, true).slideToggle(300);

        EqualSizer_1('.choice-option ul li');
    });

    $('.head-ul').owlCarousel({
        margin: 10,
        //loop: true,
        nav: true,
        autoplay: false,
        autoplayTimeout: 1000,
        autoplayHoverPause: true,
        responsive: {
            0: {
                items: 2
            },
            600: {
                items: 4
            },
            1000: {
                items: 6
            }
        }
    });

    $('.content-slide').owlCarousel({
        //loop: true,
        slideBy: 5,
        nav: true,
        autoplay: false,
        autoplayTimeout: 1000,
        autoplayHoverPause: true,
        mouseDrag: false,
        responsive: {
            0: {
                items: 1
            },
            480: {
                items: 2
            },
            640: {
                items: 3
            },
            1000: {
                items: 5
            }
        }
    });

    $('a[data-toggle="tab"]').off('shown.bs.tab');
    $('a[data-toggle="tab"]').on('shown.bs.tab', function () {
        re_img();
    });

}
function line_height() {
    $('.bot-head .policy .item:not(:first)').each(function () {
        var n = $(this).height();
        $(this).css('line-height', n + "px");
    })
}

function re_img() {
    $('.content-slide .item .re-img').each(function () {
        var n = $(this).width();
        $(this).height(n);
    });

    $('.wrap-recom .item .re-img').each(function () {
        var n = $(this).width();
        $(this).height(n);
    });

    var x = $('.content-slide').height();
    var y = $('.content-slide .item').width();
    //console.log(x, y);
    $('.carousel-wrap .content-slide .owl-item .show-more').height(x);
    $('.carousel-wrap .content-slide .owl-item .show-more').width(y);

}

function addNum() {
    //debugger;
    //var leng = $('.df-carousel .content-slide .owl-item').length;
    ////console.log(leng);
    //for (i = 0; i <= leng; i++) {
    //    //console.log();
    //    var ad = $('.df-carousel .content-slide .owl-item:nth-of-type(' + i + ') .item .wrap-item').append('<div class="num">' + i + '</div>');
    //}
    var len = $('.head-ul .owl-item').length;
    for (u = 0; u <= len; u++) {
        //console.log();
        $('<div class="num">' + u + '</div>').insertBefore($('.head-ul .owl-item:nth-of-type(' + (u + 1) + ') .item > a'));
    }
}

/*=========================================================================*/
//================== scroll top
$(window).scroll(function () {
    if ($(this).scrollTop() > 100) {
        $('.scroll-to-top').fadeIn();
    } else {
        $('.scroll-to-top').fadeOut();
    }
});

$('.scroll-to-top').on('click', function (e) {
    e.preventDefault();
    $('html, body').animate({ scrollTop: 0 }, 800);
    return false;
});


function DoEqualSizer(myclass) {
    var heights = $(myclass).map(function () {
        $(this).height('auto');
        return $(this).height();
    }).get(),
    maxHeight = Math.max.apply(null, heights);
    $(myclass).height(maxHeight);
};

function EqualSizer_2(myclass) {
    $(document).ready(DoEqualSizer(myclass));
    window.addEventListener('resize', function () {
        DoEqualSizer(myclass);
    });
};

function EqualSizer_1(myclass) {
    $(document).ready(DoEqualSizer(myclass));
    window.addEventListener('resize', function () {
        DoEqualSizer(myclass);
    });
};

function EqualSizer(myclass) {
    $(document).ready(DoEqualSizer(myclass));
    window.addEventListener('resize', function () {
        DoEqualSizer(myclass);
    });
};


//function activeMenu() {
//    $('.link-web li a').click(function () {
//        $('.link-web li').removeClass('active');
//        $('.link-web li').removeClass('mgb-70');
//        $(this).parent('li').addClass('active');
//        $(this).parent('li').addClass('mgb-70');
//        var parent = $(this).parent();
//        var answer = parent.find('.form-select');
//        if ($(answer).hasClass('show')) {
//            $('.link-web li').removeClass('active');
//            $('.link-web li').removeClass('mgb-70');
//            $(answer).slideUp();
//            $(answer).removeClass('show');
//        } else {
//            $('.form-select').removeClass('show');
//            $('.form-select').slideUp();
//            $(this).parent('li').addClass('active');
//            $(this).parent('li').addClass('mgb-70');

//            $(answer).slideDown();
//            $(answer).addClass('show');
//        }

//    });
//}

//function AsideMenu() {
//    $('.aside > ul > li a').click(function (e) {
//        e.preventDefault();
//        $('.aside > ul > li').removeClass('active');
//        $(this).parent('li').addClass('active');
//        var parent = $(this).parent();
//        var answer = parent.find('ul');
//        if ($(answer).hasClass('show')) {
//            $('.aside > ul > li').removeClass('active');
//            $(answer).slideUp();
//            $(answer).removeClass('show');
//        } else {
//            $('.aside > ul > li > ul').removeClass('show');
//            $('.aside > ul > li > ul').slideUp();
//            $(this).parent('li').addClass('active');

//            $(answer).slideDown();
//            $(answer).addClass('show');
//        }
//    });
//}

function logUser() {
    $('.user-control .user-name').hover(function () {
        //var n = $(this).parent();
        $(this).children('ul').stop(true, false, true).slideToggle(300);
    });
    $('.user-name ul > li > ul').addClass('has-sub');
    $('.has-sub').parent().addClass('li-parent');
}

function get_val() {
    var n = $('.form-left > p').html();
    $('.choice-option ul li').click(function () {
        var x = $(this).html();
        $('.form-left > p').html(x);
        $('.choice-option ul').slideUp(300);
    });
}

function getEmail() {
    $('.wrap-content-footer .form-ft .form-left .form .button-answer').click(function () {
        var n = $('.wrap-content-footer .form-ft .form-left .form input[type="text"]').val();
        $('.popup .popup-content .wrap-cont input[type="text"]').val(n);
    });
}

/** popup **/
$('.button-answer').click(function () {
    $('#main-content').append('<div id="overlay-screen-active">');
    $('.popup-content').css('top', '20px');
});
$(document).on('click', ".popup-btn-close, #overlay-screen-active", function () {
    $('.popup-content').css('top', '-250%');
    $('#overlay-screen-active').fadeOut();
    $('#overlay-screen-active').remove();
    return false;
});
$(document).ready(function () {
    $(window).resize(function () {
        $('.button-answer').click(function () {
            $('#main-content').append('<div id="overlay-screen-active">');
            $('#overlay-screen-active').remove();
            $('.popup-content').css('top', '20px');
        });
        $(document).on('click', ".btn-Close, #overlay-screen-active", function () {
            $('.popup-content').css('top', '-250%');
            $('#overlay-screen-active').fadeOut();
            $('#overlay-screen-active').remove();
            return false;
        });
    }).resize();
});