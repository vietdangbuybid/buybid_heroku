$('.qtyplus').click(function (e) {
    var qtyField = $(this).siblings(".qtyValue");
    var max = qtyField.attr("max");
    e.preventDefault();
    var currentVal = parseInt(qtyField.val());
    var val2 = currentVal + 1;
    if (max) {
        if (!isNaN(currentVal) && currentVal < max) {
            qtyField.val(val2);
            qtyField.attr("value", val2);
        } else {
            qtyField.val(max);
            qtyField.attr("value", max);
        }
    } else {
        if (!isNaN(val2)) {
            qtyField.val(val2);
            qtyField.attr("value", val2);
        }
        else {
            qtyField.val(1);
            qtyField.attr("value", 1);
        }
    }
    $(this).parents(".quantity").change();
});

$(".qtyminus").click(function (e) {
    var qtyField = $(this).siblings(".qtyValue");
    var min = qtyField.attr("min");
    e.preventDefault();
    fieldName = $(this).attr('field');
    var currentVal = parseInt(qtyField.val());
    if (min) {
        if (!isNaN(currentVal) && currentVal > min) {
            qtyField.val(currentVal - 1);
            qtyField.attr("value", currentVal - 1);
        } else {
            qtyField.val(min);
            qtyField.attr("value", min);
        }
    } else {
        if (!isNaN(currentVal) && currentVal > 0) {
            qtyField.val(currentVal - 1);
            qtyField.attr("value", currentVal - 1);
        } else {
            qtyField.val(0);
            qtyField.attr("value", 0);
        }
    }
    $(this).parents(".quantity").change();
});

$(".quantity").on("keydown", function (event) {
    var $this = $(this).find(".qtyValue");
    // Allow special chars + arrows 
    if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9
        || event.keyCode == 27 || event.keyCode == 13
        || (event.keyCode == 65 && event.ctrlKey === true)
        || (event.keyCode >= 35 && event.keyCode <= 39)) {
        return;

    } else {
        // If it's not a number stop the keypress
        if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
            event.preventDefault();
        }
    }
});

$(".quantity").on("change", function (event) {
    var $this = $(this).find(".qtyValue");
    var qty = $this.val();
    $this.val(qty.replace(/^0+/, ''));
    $this.attr("value", qty.replace(/^0+/, ''));

    if ($this.val() == "") {
        $this.val(1);
        $this.attr("value", 1);
    }
});