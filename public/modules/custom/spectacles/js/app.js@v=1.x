(function ($) {
    $(document).ready(function(){
        $('[data-calendar-header-trigger]').click(function(e){
            e.preventDefault();
            $('[data-calendar-header]').toggleClass('is-active');
            
        });

        $('[data-calendar-spectacle-trigger]').click(function(e){
            e.preventDefault();
            $('[data-calendar-spectacle]').parent('.calendar-spectacle-wrapper').toggleClass('is-active').siblings('.button-container').toggleClass('is-hidden');
        });

        $(document).mouseup(function(e) {
            var container = $('[data-calendar]');
            // if the target of the click isn't the container nor a descendant of the container
            if((!container.is(e.target) && container.has(e.target).length === 0) && (!$('[data-calendar-header-trigger]').is(e.target) && $('[data-calendar-header-trigger]').has(e.target).length === 0)){
                $('[data-calendar-header]').removeClass('is-active');
            }
            if((!container.is(e.target) && container.has(e.target).length === 0) && (!$('[data-calendar-header-trigger]').is(e.target) && $('[data-calendar-header-trigger]').has(e.target).length === 0)){
                $('.calendar-spectacle-wrapper').removeClass('is-active');
                $('.button-container').removeClass('is-hidden');
            }
        });

        
        
        // $('[data-calendar-header-trigger]').hover(function(e){
        //     e.preventDefault();
        //     $('.l-header').toggleClass('is-hover');
        // });
        // $('[data-calendar-header]').hover(function(e){
        //     e.preventDefault();
        //     $('.l-header').toggleClass('is-hover');
        //     $('[data-calendar-header-trigger]').toggleClass('is-hover-trigger');
        // });
        // $('.l-header.page-inside').hover(function(e){
        //     e.preventDefault();
        //     $('[data-calendar-header-trigger]').toggleClass('is-hover');
        // });
        
        setCalendar();
        selectDate();
        function closeCalendar(){
            $('[data-calendar-spectacle]').parent('.calendar-spectacle-wrapper').toggleClass('is-active').siblings('.button-container').toggleClass('is-hidden');
        }
        function setCalendar(){
            $('[data-calendar-switch]').click(function(e){
                e.preventDefault();
                $this = $(this);
                url = $(this).attr('href');
                $.ajax({
                    cache: false,
                    url: url,
                    success: function (data) {
                        $this.parents('[data-calendar]').html(data);
                        setCalendar();
                        selectDate();
                    }
                });
            });
        }

        function selectDate(){
            $('[data-select-date]').click(function(e){
                $this = $(this);
                url = $this.data('href');

                e.preventDefault();
                $.ajax({
                    cache: false,
                    url: url,
                    success: function (data) {
                        $('[data-select-date]').removeClass('is-active');
                        $this.addClass('is-active');
                        if(data.link){
                            //display buy button
                            $('[data-calendar-hours]').html('').hide();
                            displayButtons(data.link);
                        }else{
                            //display hours
                            $('[data-calendar-buttons]').html('');
                            $('[data-calendar-hours]').html(data.display_hours).show();
                            selectDate();
                        }
                    }
                });
            });
        }
        function displayButtons(link){
            var button = '';
            if(typeof link.abo != 'undefined'){
                button += '<a data-create-subscription href="'+link.abo.url+'">'+link.abo.title+'</a>'
            }
            if(link.url){
                button += '<a '+link.data+' href="'+link.url+'" target="'+link.target+'">'+link.title+'</a>'
            }else if(link.notavailable){
                button += '<p>'+link.notavailable+'</p>';
            }
            
            $('[data-calendar-buttons]').html(button);
            $('[data-add-subscription]').click(function(e){
                e.preventDefault();
                $.ajax({
                    cache: false,
                    url: $(this).attr('href'),
                    success: function (data) {
                        closeCalendar();
                        displayMessage(data.message, data.type);
                        updateShowsNb();
                    }
                });
            });
        }

        function displayMessage(message, type){
            $('[data-ajax-message]').html(message).addClass(type).show();
        }

        function updateShowsNb(){
            var newVal = parseInt($('[data-nb-shows]').text()) + 1;
            $('[data-nb-shows]').text(newVal);
        }
    });
}(jQuery));