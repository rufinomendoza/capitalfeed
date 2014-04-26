jQuery ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 205
        $('.pagination').text("Fetching more articles...")
        $.getScript(url)
    $(window).scroll()