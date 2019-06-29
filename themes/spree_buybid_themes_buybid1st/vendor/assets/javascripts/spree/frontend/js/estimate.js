(function ($) {

    document.body.onselectstart = function () {
        return true;
    };

    function getTotalEstimate() {
        $("#pdf-export").addClass("disable");
        var tg = parseFloat($("#exrate").val()); // Tỷ giá
        var ptpdv = parseFloat($("#pdv").val()); // Phần trăm Phí dịch vụ
        var pbh = parseFloat($("#pbh").val()); // Phí bảo hiểm
        var dgpvcqt = parseFloat($("#pvcqt").val()); // Đơn giá Phí vận chuyển quốc tế

        var tdh = 0; // Tổng đơn hàng
        var pdv = 0; // Phí dịch vụ
        var pdg = 0; //Phí đấu giá
        var kg = 0; // Số kg
        var pvcnd = 0; // Phí vận chuyển nội địa
        var pvcqt = parseFloat($("#pvcqt").val()); // Phí vận chuyển quốc tế
        var ppt = 0; // Phí phụ thu
        var ttd1 = 0; // Thanh toán lần 1
        var ttd2 = 0; // Thanh toán lần 2

        if ($("#shop-auction").is(":checked")) {
            pdg = parseFloat($("#pdg").val());
            $("#aufee-jpy").html(pdg);
        } else if ($("#shop-order").is(":checked")) {
            pdg = 0;
            $("#aufee-jpy").html(0);
        }
        
        if ($("#total-order-input").val()) {
            tdh = parseFloat($("#total-order-input").val());
            pdv = tdh * ptpdv / 100;
            if (pdv < pbh) {
                pdv = pbh;
            }
            $("#order-jpy").html(currencyja_format(tdh, 0));
            $("#svfee-jpy").html(currencyja_format(pdv, 0));
            $("#pdf-export").removeClass("disable");
        }

        if ($("#package-kg-input").val()) {
            if ($("#package-kg-input").val() < 0.5) {
                $("#package-kg-input").val(0.5);
            }
            kg = parseFloat($("#package-kg-input").val());
            pvcqt = Math.round(dgpvcqt * kg);
            $("#package-kg").html(kg);
            $("#package-kg-jpy").html(currencyja_format(pvcqt, 0));
        } else {
            kg = 1;
            pvcqt = Math.round(dgpvcqt * kg);
            $("#package-kg").html(kg);
            $("#package-kg-jpy").html(currencyja_format(pvcqt, 0));
        }

        if ($("#transport-jp-input").val()) {
            pvcnd = parseFloat($("#transport-jp-input").val());
            $("#transport-jp-jpy").html(currencyja_format(pvcnd, 0));
            $("#total-transport-jp-jpy").html(currencyja_format(pvcnd, 0));
        }

        if ($("#exfee-input").val()) {
            ppt = parseFloat($("#exfee-input").val());
            $("#exfee-jpy").html(currencyja_format(ppt, 0));
            $("#total-exfee-jpy").html(currencyja_format(ppt, 0));
        }
        
        ttd1 = Math.round(tdh + pdv + pdg);
        ttd2 = Math.round(pvcnd + pvcqt + ppt);

        var ttd1vnd = ttd1 * tg;
        var ttd2vnd = ttd2 * tg;
        var tcpdkjpy = ttd1 + ttd2;
        var tcpdkvnd = ttd1vnd + ttd2vnd;

        $("#total1-jpy").html(currencyja_format(ttd1, 0));
        $("#total1-vnd").html(currencyvi_format(ttd1vnd, 0));
        $("#total2-jpy").html(currencyja_format(ttd2, 0));
        $("#total2-vnd").html(currencyvi_format(ttd2vnd, 0));
        $("#total-jpy").html(currencyja_format(tcpdkjpy, 0));
        $("#total-vnd").html(currencyvi_format(tcpdkvnd, 0));
    }

    function alertError(modalId, title, message) {
        $("#" + modalId + " .modal-link-header h5").html(title);
        $("#" + modalId + " .modal-link-body p").html(message);
        $("#" + modalId).css("display", "block");
    }
    //alertError("modal-alert-estimate", "Thông báo", "Vui lòng nhập <strong>Số kg</strong> là số!");

    $(".close").on("click", function () {
        $(this).parents(".modal-link").css("display", "none");
    });

    $(".modal-btn-close").on("click", function () {
        $(".modal-link").css("display", "none");
    });

    function currencyja_format(num, rounding) {
        if (!$.isNumeric(num)) {
            return num;
        }
        if (rounding === null || typeof rounding === 'undefined' || rounding === false) {
            var roundingConfig = 1;
            num = Math.round(num / roundingConfig) * roundingConfig;
        }
        num = num.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');

        return (num);
    }

    function currencyvi_format(num, rounding) {
        if (!$.isNumeric(num)) {
            return num;
        }
        if (rounding === null || typeof rounding === 'undefined' || rounding === false) {
            var roundingConfig = 1;
            num = Math.round(num / roundingConfig) * roundingConfig;
        }
        num = num.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1.');

        return (num);
    }

    $(window).load(function () {
    });

    $("#mainform").submit(function (e) {
        e.preventDefault();
        getTotalEstimate();
    });

    $("#dutoan-form").change(function (e) {
        e.preventDefault();
        $("#pdf-export").addClass("disable");
    });

    $("#pdf-export").click(function (e) {
        e.preventDefault();
        $("#pdf-append").show();
        $("#pdf-export").addClass("disable");

        kendo.drawing.drawDOM("#estimate").then(function (group) {
            kendo.drawing.pdf.saveAs(group, "Buybid - BaoGia_" + moment().format('YYYYMMDDHHmmss') + ".pdf");
        }).then(function () {
            $("#pdf-append").hide();
        });

        $("#pdf-export").removeClass("disable");
    });
    
})(jQuery);