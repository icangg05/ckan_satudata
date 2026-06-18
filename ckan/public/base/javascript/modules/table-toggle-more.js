/* Table toggle more
 * When a table has more things to it that need to be hidden and then shown more
 */
this.ckan.module('table-toggle-more', function($) {
  return {
    /* options object can be extended using data-module-* attributes */
    options: {},

    /* Initialises the module setting up elements and event listeners.
     *
     * Returns nothing.
     */
    initialize: function () {
      $.proxyAll(this, /_on/);
      this.el.addClass('table-toggle-more');
      // Do we actually want this table to expand?
      var rows = $('.toggle-more', this.el).length;
      if (rows) {
        // How much is the colspan?
        var cols = $('thead tr th', this.el).length;
        var template_more = [
          '<tr class="toggle-show toggle-show-more">',
          '<td colspan="'+cols+'" class="tw-py-3 tw-text-center">',
          '<a href="#" class="show-more tw-text-[#185A75] tw-text-sm tw-font-semibold tw-no-underline hover:tw-underline">' +
            '<i class="fa-solid fa-chevron-down tw-text-xs" aria-hidden="true"></i> ' + this._('Show more') + '</a>',
          '<a href="#" class="show-less tw-text-[#185A75] tw-text-sm tw-font-semibold tw-no-underline hover:tw-underline">' +
            '<i class="fa-solid fa-chevron-up tw-text-xs" aria-hidden="true"></i> ' + this._('Hide') + '</a>',
          '</td>',
          '</tr>'
        ].join('\n');
        var template_seperator = [
          '<tr class="toggle-seperator">',
          '<td colspan="'+cols+'">',
          '</td>',
          '</tr>'
        ].join('\n');

       var seperator = $(template_seperator).insertAfter($('.toggle-more:last-child', this.el));
        $(template_more).insertAfter(seperator);

        $('.show-more', this.el).on('click', this._onShowMore);
        $('.show-less', this.el).on('click', this._onShowLess);
      }
    },

    _onShowMore: function($e) {
      $e.preventDefault();
      this.el
        .removeClass('table-toggle-more')
        .addClass('table-toggle-less');
    },

    _onShowLess: function($e) {
      $e.preventDefault();
      this.el
        .removeClass('table-toggle-less')
        .addClass('table-toggle-more');
    }

  }
});
