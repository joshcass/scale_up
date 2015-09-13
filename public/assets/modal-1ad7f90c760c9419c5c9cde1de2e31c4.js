var hideModal = function() {
  $(".modal-content").remove();
};

$(document).ready(function(){
    calcPercentages();
});

$(document).on('click', '#pageLinks', function(){
    setTimeout(function(){calcPercentages();}, 500);
});

function calcPercentages(){
    var $progressBars = $('.progress-bar');
    $progressBars.each(function(_, progressBar){
        var amount = $(this).data('amount');
        var contributed = $(this).data('contributed');
        var percent = percentage(amount, contributed);
        for(var i = 0; i <= percent; i++){
            $(this).css('width', i + '%');
        };
        $(this).fadeIn('slow', function(){
            $(this).text(percent + '%');
        });
        console.log('loaded!');
    });
};

function percentage(amount, contributed){
    var remaining = amount - contributed;
    var percent = Math.round(((1.00 - (remaining / amount)) * 100));
    return percent;
};
