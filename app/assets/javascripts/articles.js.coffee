jQuery ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 250
        $('.pagination').text("Fetching more articles…")
        $.getScript(url)
    $(window).scroll()