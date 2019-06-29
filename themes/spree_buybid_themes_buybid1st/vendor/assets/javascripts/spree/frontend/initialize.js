$(document).ready(function () {
    "use strict";

    $(window).load(function () {
        var scroll = $(window).scrollTop();

        if (scroll > 0) {
            $('#header').addClass('scroll');
        } else {
            $('#header').removeClass('scroll');
        }

        if ($(window).width() <= 974) {
            if (scroll > 150) {
                $('#cat-list').addClass('scroll');
            } else {
                $('#cat-list').removeClass('scroll');
            }
        }

        $('.more-less').each(function () {
            var dataMaxHeight = $(this).attr("data-max-height");
            if ($(this).children(".more-block").height() <= dataMaxHeight) {
                $(this).children(".btn-expander").hide();
            } else {
                $(this).children(".btn-expander").show();
            }
        });
    });

    $(window).resize(function () {
        var scroll = $(window).scrollTop();

        if ($(window).width() <= 974) {

            if (scroll > 150) {
                $('#cat-list').addClass('scroll');
            }
        } else {
            $('#cat-list').removeClass('scroll');
        }

        $('.more-less').each(function () {
            var dataMaxHeight = $(this).attr("data-max-height");
            if ($(this).children(".more-block").height() <= dataMaxHeight) {
                $(this).children(".btn-expander").hide();
            } else {
                $(this).children(".btn-expander").show();
            }
        });
    });

    $(window).scroll(function () {
        var scroll = $(window).scrollTop();

        if (scroll > 0) {
            $('#header').addClass('scroll');
        } else {
            $('#header').removeClass('scroll');
        }

        if ($(window).width() <= 974) {
            if (scroll > 150) {
                $('#cat-list').addClass('scroll');
            } else {
                $('#cat-list').removeClass('scroll');
            }
        }
    });

    $('.scrollTopButton').on("click", function () {
        $("body,html").animate({
            scrollTop: 0
        }, 1200);
        return false;
    });

    $('.h-head-menu-link').on("click", function (e) {
        var menulink = $(this);
        $(this).parent().toggleClass('open');
        $(this).parent().siblings().removeClass('open');

        //now set up an event listener so that clicking anywhere outside will close the menu
        $('html').click(function (event) {
            //check up the tree of the click target to check whether user has clicked outside of menu
            if ($(event.target).parents('.h-head-menu-item').length == 0 && $(event.target).siblings('.pop-hover-open').length == 0) {
                // your code to hide menu
                menulink.parent().removeClass('open');
                //this event liste`ner has done its job so we can unbind it.
                $(this).unbind(event);
            }
        })
    });

    if ($('.banner-carousel').length > 0) {
        $('.banner-carousel').owlCarousel({
            animateOut: 'fadeOut',
            animateIn: 'fadeIn',
            loops: true,
            margin: 0,
            navigation: true,
            pagination: false,
            autoPlay: true,
            autoPlayInterval: 3500,
            autoPlayHoverPause: true,
            items: 1,
            singleItem: true,
            navigationText: ['<img alt="Prev" src="https://s3-ap-southeast-1.amazonaws.com/buybid-jp-devs/public/statics/assets/images/prev.png">', '<img alt="Next" src="https://s3-ap-southeast-1.amazonaws.com/buybid-jp-devs/public/statics/assets/images/next.png">']
        });
    }

    if ($('.pro-img-carousel').length > 0) {
        var sync1 = $('.pro-img-carousel');
        var sync2 = $('.pro-img-thumbs');

        $('.pro-img-carousel').owlCarousel({
            //animateOut: 'fadeOut',
            //animateIn: 'fadeIn',
            smartSpeed: 100,
            slideTransition: 'linear',
            loops: true,
            margin: 0,
            navigation: false,
            dots: false,
            items: 1,
            singleItem: true,
            responsiveRefreshRate: 200,
            mouseDrag: false,
            afterAction: syncPosition,
        });

        $('.pro-img-thumbs').owlCarousel({
            loops: false,
            margin: 0,
            navigation: true,
            dots: false,
            items: 3,
            itemsDesktop: [1199, 3],
            itemsDesktopSmall: [979, 3],
            itemsTablet: [768, 3],
            itemsMobile: [479, 3],
            navigationText: ['<div class="slider_nav_left slider_nav"><i class="fa fa-chevron-left" aria-hidden="true"></i></div>', '<div class="slider_nav_right slider_nav"><i class="fa fa-chevron-right" aria-hidden="true"></i></div>'],
            afterInit: function (el) {
                el.find(".owl-item").eq(0).find(".pro-thumb-item").addClass("active");
            }
        });

        $(".pro-img-thumbs").on("click", ".owl-item", function (e) {
            e.preventDefault();
            var number = $(this).data("owlItem");
            sync1.trigger("owl.goTo", number);
        });

        $('.pro-img-carousel').magnificPopup({
            delegate: 'a',
            type: 'image',
            closeOnContentClick: false,
            closeBtnInside: false,
            mainClass: 'mfp-with-zoom mfp-img-mobile',
            image: {
                verticalFit: true,
                titleSrc: function (item) {
                    return item.el.attr('title');
                }
            },
            gallery: {
                enabled: true
            },
            zoom: {
                enabled: true,
                duration: 300, // don't foget to change the duration also in CSS
                opener: function (element) {
                    return element.find('img');
                }
            }

        });
    }

    function syncPosition(el) {
        var current = this.currentItem;
        $(".pro-img-thumbs")
            .find(".pro-thumb-item")
            .removeClass("active");

        $(".pro-img-thumbs")
            .find(".owl-item")
            .eq(current)
            .find(".pro-thumb-item")
            .addClass("active");

        if ($(".pro-img-thumbs").data("owlCarousel") !== undefined) {
            center(current);
        }
    };

    function center(number) {
        var sync2visible = sync2.data("owlCarousel").owl.visibleItems;
        var num = number;
        var found = false;
        for (var i in sync2visible) {
            if (num === sync2visible[i]) {
                found = true;
            }
        }

        if (found === false) {
            if (num > sync2visible[sync2visible.length - 1]) {
                sync2.trigger("owl.goTo", num - sync2visible.length + 2);
            } else {
                if (num - 1 === -1) {
                    num = 0;
                }
                sync2.trigger("owl.goTo", num);
            }
        } else if (num === sync2visible[sync2visible.length - 1]) {
            sync2.trigger("owl.goTo", sync2visible[1]);
        } else if (num === sync2visible[0]) {
            sync2.trigger("owl.goTo", num - 1);
        }

    };

    // Get the modal Menu
    var menu = document.getElementById('menu-mobile');

    // When the user clicks on the button, open the modal 
    $(".modal-button").on("click", function (e) {
        e.preventDefault();
        var target = $(this).attr('data-target');
        var modal = $("#" + target);
        console.log(modal);
        modal.addClass("show");
        $('html').css({
            overflow: 'hidden'
        });
    });

    // When the user clicks on the close button, close the modal
    $(".modal-background .close").on("click", function (e) {
        e.preventDefault();
        var modal = $(this).parents('.modal-background').attr('id');
        //document.getElementById(modal).style.display = "none";
        $(this).parents('.modal-background').removeClass("show");
        $('html').css({
            overflow: ''
        });
    });

    // When the user clicks anywhere outside of the modal, close it
    document.onclick = function (e) {
        if (e.target === menu) {
            //menu.style.display = "none";
            $("#menu-mobile").removeClass("show");
            $('html').css({
                overflow: ''
            });
        }
    };

    $(".support-menu-header").on("click", function () {
        if (!$(this).siblings(".support-menu-cont").is(":visible")) {
            $(this).siblings(".support-menu-cont").slideDown();
            $(this).parents(".support-menu-item").addClass("active")
        } else if ($(this).siblings(".support-menu-cont").is(":visible")) {
            $(this).siblings(".support-menu-cont").slideUp();
            $(this).parents(".support-menu-item").removeClass("active")
        }
    });

    /* 

    Category menu

    */

    $("#cat-button").on("click", function () {
        $(this).parents(".sec-page-cat-area").find(".sec-cat-body").slideToggle();
    });

    /* 

    Fixed height

    */

    $(document).on("click", ".btn-expander", function () {
        var dataType = $(this).attr("data-type");
        var dataText = $(this).attr("data-text");
        var dataMaxHeight = $(this).parents(".more-less").attr("data-max-height")
        var dataHtml = $(this).html();
        $(this).attr("data-text", dataHtml);
        $(this).html(dataText);
        if (dataType === "1") {
            $(this).attr("data-type", "2");
            $(this).removeClass("expand");
            $(this).parents(".more-less").css("max-height", "none");
        } else {
            $(this).attr("data-type", "1");
            $(this).addClass("expand");
            $(this).parents(".more-less").css("max-height", dataMaxHeight + "px");
        }
    });

    /* 

    Init Quantity

    */
    if ($('.plus').length && $('.minus').length) {
        var plus = $('.plus');
        var minus = $('.minus');
        var value = $('#quantity_value');

        plus.on('click', function () {
            var x = parseInt(value.text());
            value.text(x + 1);
        });

        minus.on('click', function () {
            var x = parseInt(value.text());
            if (x > 1) {
                value.text(x - 1);
            }
        });
    }
});
