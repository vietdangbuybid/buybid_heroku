jQuery(document).ready(function ($) {
    "use strict";

    // LazyLoad
    if ($(".lazy").length > 0) {
        var lazyLoadInstance = new LazyLoad({
            elements_selector: ".lazy"
            // ... more custom settings?
        });
    }

    if ($(".sidebar").length > 0) {
        var sidebar = new StickySidebar('.sidebar', {
            topSpacing: 125,
            containerSelector: '#main-content .sec-page-body',
            innerWrapperSelector: '.sidebar__inner',
            resizeSensor: true
        });
    }

    $(window).load(function () {
        var scroll = $(window).scrollTop();

        if (scroll > 0) {
            $('#header').addClass('scroll');
        } else {
            $('#header').removeClass('scroll');
        }

        if ($(window).width() <= 974) {
            if (scroll > 50) {
                $('#cat-list').addClass('scroll');
            } else {
                $('#cat-list').removeClass('scroll');
            }
        } else {

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
            if (scroll > 50) {
                $('#cat-list').addClass('scroll');
            }
        } else {
            $('#cat-list').removeClass('scroll');
            $("#menu-mobile").removeClass("show");
            $('html').css({
                overflow: ''
            });
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

        if (scroll > 150) {
            $('.top-scroll').fadeIn();
        } else {
            $('.top-scroll').fadeOut();
        }

        if ($(window).width() <= 974) {
            if (scroll > 50) {
                $('#cat-list').addClass('scroll');
            } else {
                $('#cat-list').removeClass('scroll');
            }
        }
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
                //this event listener has done its job so we can unbind it.
                $(this).unbind(event);
            }
        })
    });

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

    /* Dropdown list */
    $(".bb-ddl").each(function(e, i) {
        var $ddl = $(this);
        var $items = $(this).find(".item");
        var text;
        var value;
        
        function bindData(t, v) {
            $ddl.find(".data-value").val(v);
            $ddl.find(".data-text").html(t);
            BuybidSearch.sortList(v);
        }

        $items.each(function (e, i) {
            if($(this).hasClass("selected")) {
                text = $(this).html();
                value = $(this).attr("data-value");
                bindData(text, value);
            }
        });

        $items.on("click", function(e) {
            e.preventDefault();
            $ddl.find(".item").removeClass("selected");
            $(this).addClass("selected");
            text = $(this).html();
            value = $(this).attr("data-value");
            bindData(text, value);
        });
    })

    /* Category menu */
    $("#cat-button").on("click", function () {
        $(this).parents(".sec-page-cat-area").find(".sec-cat-body").slideToggle();
    });

    /* Filter text */
    $(".filter-text-box .filter-text-input").on("keyup", function () {
        var value = $(this).val().toLowerCase();
        $(this).parents(".filter-text-box").find(".filter-item-label").filter(function () {
            $(this).parents(".filter-item").toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
    });

    /* Tooltips */
    //$('[data-toggle="tooltip"]').tooltip();


    $('.scrollTopButton').on("click", function () {
        $("body,html").animate({
            scrollTop: 0
        }, 1200);
        return false;
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
            navigationText: ['<div class="slider_nav_left slider_nav"><i class="fa fa-arrow-left" aria- hidden="true"></i></div>', '<div class="slider_nav_right slider_nav"><i class="fa fa-arrow-right" aria- hidden="true"></i></div>']
        });
    }

    if ($('.product-carousel').length > 0) {
        $('.product-carousel').owlCarousel({
            loops: true,
            margin: 0,
            navigation: true,
            dots: false,
            autoPlay: true,
            autoPlayInterval: 4000,
            stopOnHover: true,
            items: 5,
            itemsDesktop: [974, 4],
            itemsDesktopSmall: [768, 4],
            itemsTablet: [600, 2],
            itemsMobile: [0, 1],
            navigationText: ['<div class="slider_nav_left slider_nav"><i class="fa fa-chevron-left" aria- hidden="true"></i></div>', '<div class="slider_nav_right slider_nav"><i class="fa fa-chevron-right" aria- hidden="true"></i></div>']
        });
    }

    if ($('.categories-carousel').length > 0) {
        $('.categories-carousel').owlCarousel({
            loops: false,
            margin: 0,
            navigation: true,
            dots: false,
            items: 6,
            itemsDesktop: [974, 4],
            itemsDesktopSmall: [768, 4],
            itemsTablet: [600, 2],
            itemsMobile: [0, 1],
            navigationText: ['<div class="slider_nav_left slider_nav"><i class="fa fa-chevron-left" aria- hidden="true"></i></div>', '<div class="slider_nav_right slider_nav"><i class="fa fa-chevron-right" aria- hidden="true"></i></div>']
        });
    }

    if ($('.sellers-carousel').length > 0) {
        $('.sellers-carousel').owlCarousel({
            loops: false,
            navigation: true,
            dots: false,
            items: 6,
            itemsDesktop: [974, 5],
            itemsDesktopSmall: [768, 4],
            itemsTablet: [600, 2],
            itemsMobile: [0, 1],
            navigationText: ['<div class="slider_nav_left slider_nav"><i class="fa fa-chevron-left" aria- hidden="true"></i></div>', '<div class="slider_nav_right slider_nav"><i class="fa fa-chevron-right" aria- hidden="true"></i></div>']
        });
    }

    if ($('.partner-carousel').length > 0) {
        $('.partner-carousel').owlCarousel({
            loops: false,
            margin: 0,
            navigation: false,
            dots: false,
            autoPlay: true,
            autoPlayInterval: 4000,
            stopOnHover: false,
            items: 4,
            itemsDesktop: [1199, 3],
            itemsDesktopSmall: [974, 2],
            itemsTablet: [768, 2],
            itemsMobile: [479, 2],
            navigationText: ['<div class="slider_nav_left slider_nav"><i class="fa fa-chevron-left" aria- hidden="true"></i></div>', '<div class="slider_nav_right slider_nav"><i class="fa fa-chevron-right" aria- hidden="true"></i></div>'],
        });
    }

    if ($('.hastags-carousel').length > 0) {
        $('.hastags-carousel').owlCarousel({
            loops: false,
            navigation: true,
            dots: false,
            scrollPerPage: true,
            items: 6,
            itemsDesktop: [974, 5],
            itemsDesktopSmall: [768, 4],
            itemsTablet: [600, 2],
            itemsMobile: [0, 1],
            navigationText: ['<div class="slider_nav_left slider_nav"><i class="fa fa-chevron-left" aria- hidden="true"></i></div>', '<div class="slider_nav_right slider_nav"><i class="fa fa-chevron-right" aria- hidden="true"></i></div>']
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
            navigationText: ['<div class="slider_nav_left slider_nav"><i class="fa fa-chevron-left" aria- hidden="true"></i></div>', '<div class="slider_nav_right slider_nav"><i class="fa fa-chevron-right" aria- hidden="true"></i></div>'],
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

    /* Fixed height */

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

    /* Init Quantity */
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