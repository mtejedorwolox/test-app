on_load = ->

  processToggle = (self) ->
    $(self).find('span.selected').toggleClass('glyphicon-triangle-bottom');
    $(self).find('span.selected').toggleClass('glyphicon-triangle-top');
    $(self).find('span.hide').addClass('selected');
    $(self).find('span.hide').removeClass('hide');
    others = $('th').not(self).find('span.glyphicon')
    others.removeClass('selected');
    others.addClass('hide');
    others.removeClass('glyphicon-triangle-top');
    others.addClass('glyphicon-triangle-bottom');

  postOrder = (field) ->
#    $.ajax '/order_closed_trades',
#      type: 'POST'
#      datatype: 'json'
#      data: { field: field }

  $('#sort-currency').click ->
    processToggle(this);
#    postOrder('currency');

  $('#sort-start-date').click ->
    processToggle(this);
#    postOrder('start_date');

  $('#sort-end-date').click ->
    processToggle(this);
#    postOrder('end_date');

  $('#sort-profit-loss').click ->
    processToggle(this);
#    postOrder('profit');

  $('#sort-profit-loss-percentage').click ->
    processToggle(this);
#    postOrder('profit');


$(document).on 'turbolinks:load', on_load