// datastore-refresh module
//
// For CSV/XLSX resources whose data is pushed to the DataStore asynchronously
// by DataPusher. It polls the DataPusher job status, shows the processing
// state, auto-reloads the embedded data view once processing finishes, and
// provides a manual "Refresh table" button (the displayed table otherwise
// keeps showing stale data until a manual page reload).
this.ckan.module('datastore-refresh', function (jQuery) {
  return {
    options: {
      resourceId: null,
      poll: 3000,
      msgChecking: 'Checking data status…',
      msgProcessing: 'Processing data to DataStore…',
      msgReady: 'Data is up to date',
      msgError: 'Failed to process data',
      msgIdle: 'Click refresh to reload the table'
    },

    initialize: function () {
      jQuery.proxyAll(this, /_on/);
      this.$text = this.el.find('.js-dsr-text');
      this.$icon = this.el.find('.js-dsr-icon');
      this.$btnIcon = this.el.find('.js-dsr-refresh-icon');
      this.wasProcessing = false;
      this._timer = null;

      this.el.find('.js-dsr-refresh').on('click', this._onRefreshClick);
      this._setStatus('fa-circle-info', '#185A75', this.options.msgChecking, false);
      this._check();
    },

    // Locate the embedded data-viewer iframe rendered for this resource (if any).
    _iframe: function () {
      return jQuery('.ckanext-datapreview iframe[data-module="data-viewer"]').first();
    },

    // Reload the embedded view so the iframe re-runs datastore_search and shows
    // the freshly pushed data. Falls back to a full page reload when no view
    // exists yet (e.g. first upload still being processed).
    _reloadView: function () {
      var $f = this._iframe();
      if ($f.length) {
        var src = $f.attr('src').split('#')[0];
        var sep = src.indexOf('?') === -1 ? '?' : '&';
        $f.attr('src', src + sep + '_ts=' + Date.now());
      } else {
        window.location.reload();
      }
    },

    _setStatus: function (icon, color, text, spin) {
      this.$icon.html(
        '<i class="fa-solid ' + icon + (spin ? ' fa-spin' : '') +
        '" style="color:' + color + ';" aria-hidden="true"></i>'
      );
      this.$text.text(text);
    },

    _onRefreshClick: function () {
      var self = this;
      this.$btnIcon.addClass('fa-spin');
      this._reloadView();
      setTimeout(function () { self.$btnIcon.removeClass('fa-spin'); }, 1500);
      this._check();
    },

    _check: function () {
      if (!this.options.resourceId) { return; }
      this.sandbox.client.call(
        'GET', 'datapusher_status', '?resource_id=' + this.options.resourceId,
        this._onStatus, this._onStatusError
      );
    },

    _onStatus: function (resp) {
      var status = resp && resp.result && resp.result.status;
      if (status === 'pending' || status === 'submitting') {
        this.wasProcessing = true;
        this._setStatus('fa-spinner', '#d97706', this.options.msgProcessing, true);
        clearTimeout(this._timer);
        this._timer = setTimeout(this._onPoll, this.options.poll);
      } else if (status === 'complete') {
        this._setStatus('fa-circle-check', '#16a34a', this.options.msgReady, false);
        if (this.wasProcessing) {
          this.wasProcessing = false;
          this._reloadView();
        }
      } else if (status === 'error') {
        this._setStatus('fa-triangle-exclamation', '#dc2626', this.options.msgError, false);
      } else {
        this._setStatus('fa-circle-info', '#185A75', this.options.msgIdle, false);
      }
    },

    _onStatusError: function () {
      // Status unavailable (no job yet, or no permission) — manual refresh still works.
      this._setStatus('fa-circle-info', '#185A75', this.options.msgIdle, false);
    },

    _onPoll: function () {
      this._check();
    }
  };
});
