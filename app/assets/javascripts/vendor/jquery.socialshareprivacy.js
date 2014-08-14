/*
 * jquery.socialshareprivacy.js | 2 Klicks fuer mehr Datenschutz
 *
 * http://www.heise.de/extras/socialshareprivacy/
 * http://www.heise.de/ct/artikel/2-Klicks-fuer-mehr-Datenschutz-1333879.html
 *
 * Copyright (c) 2011 Hilko Holweg, Sebastian Hilbig, Nicolas Heiringhoff, Juergen Schmidt,
 * Heise Zeitschriften Verlag GmbH & Co. KG, http://www.heise.de
 *
 * is released under the MIT License http://www.opensource.org/licenses/mit-license.php
 *
 * Spread the word, link to us if you can.
 */
(function ($) {

    "use strict";

	/*
	 * helper functions
	 */

    // abbreviate at last blank before length and add "\u2026" (horizontal ellipsis)
    function abbreviateText(text, length) {
        var abbreviated = decodeURIComponent(text);
        if (abbreviated.length <= length) {
            return text;
        }

        var lastWhitespaceIndex = abbreviated.substring(0, length - 1).lastIndexOf(' ');
        abbreviated = encodeURIComponent(abbreviated.substring(0, lastWhitespaceIndex)) + "\u2026";

        return abbreviated;
    }

    // returns content of <meta name="" content=""> tags or '' if empty/non existant
    function getMeta(name) {
        var metaContent = $('meta[name="' + name + '"]').attr('content');
        return metaContent || '';
    }

    // create tweet text from content of <meta name="DC.title"> and <meta name="DC.creator">
    // fallback to content of <title> tag
    function getTweetText() {
        var title = getMeta('DC.title');
        var creator = getMeta('DC.creator');

        if (title.length > 0 && creator.length > 0) {
            title += ' - ' + creator;
        } else {
            title = $('title').text();
        }

        return encodeURIComponent(title);
    }

    // build URI from rel="canonical" or document.location
    function getURI() {
        var uri = document.location.href;
        var canonical = $("link[rel=canonical]").attr("href");

        if (canonical && canonical.length > 0) {
            if (canonical.indexOf("https") < 0) {
                canonical = document.location.protocol + "//" + document.location.host + canonical;
            }
            uri = canonical;
        }

        return uri;
    }



    // extend jquery with our plugin function
    $.fn.socialSharePrivacy = function (settings) {
        var defaults = {
            'services' : {
                'facebook' : {
                    'status'            : 'on',
                    'txt_fb_off'        : 'nicht mit Facebook verbunden',
                    'txt_fb_on'         : 'mit Facebook verbunden',
                    'display_name'      : 'Facebook',
                    'referrer_track'    : '',
                    'language'          : 'de_DE',
                    'action'            : 'recommend'
                },
                'twitter' : {
                    'status'            : 'on',
                    'txt_twitter_off'   : 'nicht mit Twitter verbunden',
                    'txt_twitter_on'    : 'mit Twitter verbunden',
                    'display_name'      : 'Twitter',
                    'referrer_track'    : '',
                    'tweet_text'        : getTweetText,
                    'language'          : 'en'
                },
                'gplus' : {
                    'status'            : 'on',
                    'txt_gplus_off'     : 'nicht mit Google+ verbunden',
                    'txt_gplus_on'      : 'mit Google+ verbunden',
                    'display_name'      : 'Google+',
                    'referrer_track'    : '',
                    'language'          : 'de'
                },
                'pinterest' : {
                	'status'			: 'on',
                    'txt_pinterest_off'     : 'nicht mit Pinterest verbunden',
                    'txt_pinterest_on'      : 'mit Pinterest verbunden',
                    'display_name'      : 'Pinterest',
                    'referrer_track'    : '',
                    'language'          : 'de'
                }
            },
            'txt_info'          : '2 Klicks f&uuml;r mehr Datenschutz: Erst wenn Sie auf das Schloss klicken, wird der jeweilige Button aktiv und Sie k&ouml;nnen Ihre Empfehlung an das entsprechende Soziale Netzwerk senden. Schon beim Aktivieren werden Daten an Dritte &uuml;bertragen.',

            'css_path'          : '',
            'uri'               : getURI
        };

        // Standardwerte des Plug-Ings mit den vom User angegebenen Optionen ueberschreiben
        var options = $.extend(true, defaults, settings);

        var facebook_on = (options.services.facebook.status === 'on');
        var twitter_on  = (options.services.twitter.status  === 'on');
        var gplus_on    = (options.services.gplus.status    === 'on');
		var pinterest_on    = (options.services.pinterest.status    === 'on');

        // check if at least one service is "on"
        if (!facebook_on && !twitter_on && !gplus_on &&!pinterest_on) {
            return;
        }

        // insert stylesheet into document and prepend target element
        if (options.css_path.length > 0) {
            // IE fix (noetig fuer IE < 9 - wird hier aber fuer alle IE gemacht)
            if (document.createStyleSheet) {
                document.createStyleSheet(options.css_path);
            } else {
                $('head').append('<link rel="stylesheet" type="text/css" href="' + options.css_path + '" />');
            }
        }

        return this.each(function () {

            $(this).prepend('<ul class="social_share_privacy_area"></ul>');
            var context = $('.social_share_privacy_area', this);

            // canonical uri that will be shared
            var uri = $(this).data('uri') || options.uri;
            if (typeof uri === 'function') {
                uri = uri(context);
            }

            //
            // Facebook
            //
            if (facebook_on) {
                var fb_enc_uri = encodeURIComponent(uri + options.services.facebook.referrer_track);
                var fb_code = '<iframe src="https://www.facebook.com/plugins/like.php?locale=' + options.services.facebook.language + '&amp;href=' + fb_enc_uri + '&amp;send=false&amp;layout=button_count&amp;width=120&amp;show_faces=false&amp;action=' + options.services.facebook.action + '&amp;colorscheme=light&amp;font&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:123px; height:21px;" allowTransparency="true"></iframe>';
                var fb_dummy_btn = '<i class="fa fa-facebook-square fa-lg" id="facebook-dummy"></i>';

                context.append('<li class="facebook help_info"><span class="switch fa fa-lock" title="' + options.services.facebook.txt_fb_off + '"></span><div class="fb_like dummy_btn">' + fb_dummy_btn + '</div></li>');

                var $container_fb = $('li.facebook', context);

                $('li.facebook i,li.facebook span.switch', context).on('click', function () {
                    if ($container_fb.find('span.switch').hasClass('fa-lock')) {
                        $container_fb.addClass('info_off');
                        $container_fb.find('span.switch').addClass('fa-unlock-alt').removeClass('fa-lock').attr('title', options.services.facebook.txt_fb_on);
                        $container_fb.find('#facebook-dummy').replaceWith(fb_code);
                    } else {
                        $container_fb.removeClass('info_off');
                        $container_fb.find('span.switch').addClass('fa-lock').removeClass('fa-unlock-alt').attr('title', options.services.facebook.txt_fb_off);
                        $container_fb.find('.fb_like').html(fb_dummy_btn);
                    }
                });
            }

            //
            // Twitter
            //
            if (twitter_on) {
                var text = $(this).data('title') || options.services.twitter.tweet_text;
                if (typeof text === 'function') {
                    text = text();
                }
                // 120 is the max character count left after twitters automatic url shortening with t.co
                text = abbreviateText(text, '120');

                var twitter_enc_uri = encodeURIComponent(uri + options.services.twitter.referrer_track);
                var twitter_count_url = encodeURIComponent(uri);
                var twitter_code = '<iframe allowtransparency="true" frameborder="0" scrolling="no" src="https://platform.twitter.com/widgets/tweet_button.html?url=' + twitter_enc_uri + '&amp;counturl=' + twitter_count_url + '&amp;text=' + text + '&amp;count=horizontal&amp;lang=' + options.services.twitter.language + '" style="width:95px; height:25px;"></iframe>';
                var twitter_dummy_btn = '<i class="fa fa-twitter-square fa-lg" id="twitter-dummy"></i>';

                context.append('<li class="twitter help_info"><span class="switch fa fa-lock" title="' + options.services.twitter.txt_twitter_off + '"></span><div class="tweet dummy_btn">' + twitter_dummy_btn + '</div></li>');

                var $container_tw = $('li.twitter', context);

                $('li.twitter i,li.twitter span.switch', context).on('click', function () {
                    if ($container_tw.find('span.switch').hasClass('fa-lock')) {
                        $container_tw.addClass('info_off');
                        $container_tw.find('span.switch').addClass('fa-unlock-alt').removeClass('fa-lock').attr('title', options.services.twitter.txt_twitter_on);
                        $container_tw.find('#twitter-dummy').replaceWith(twitter_code);
                    } else {
                        $container_tw.removeClass('info_off');
                        $container_tw.find('span.switch').addClass('fa-lock').removeClass('fa-unlock-alt').attr('title', options.services.twitter.txt_twitter_off);
                        $container_tw.find('.tweet').html(twitter_dummy_btn);
                    }
                });
            }

            //
            // Google+
            //
            if (gplus_on) {
                // fuer G+ wird die URL nicht encoded, da das zu einem Fehler fuehrt
                var gplus_uri = uri + options.services.gplus.referrer_track;

                // we use the Google+ "asynchronous" code, standard code is flaky if inserted into dom after load
                var gplus_code = '<div class="g-plusone" data-size="medium" data-href="' + gplus_uri + '"></div><script type="text/javascript">window.___gcfg = {lang: "' + options.services.gplus.language + '"}; (function() { var po = document.createElement("script"); po.type = "text/javascript"; po.async = true; po.src = "https://apis.google.com/js/plusone.js"; var s = document.getElementsByTagName("script")[0]; s.parentNode.insertBefore(po, s); })(); </script>';
                var gplus_dummy_btn = '<i class="fa fa-google-plus-square fa-lg" id="gplusone-dummy"></i>';

                context.append('<li class="gplus help_info"><span class="switch fa fa-lock" title="' + options.services.gplus.txt_gplus_off + '"></span><div class="gplusone dummy_btn">' + gplus_dummy_btn + '</div></li>');

                var $container_gplus = $('li.gplus', context);

                $('li.gplus i,li.gplus span.switch', context).on('click', function () {
                    if ($container_gplus.find('span.switch').hasClass('fa-lock')) {
                        $container_gplus.addClass('info_off');
                        $container_gplus.find('span.switch').addClass('fa-unlock-alt').removeClass('fa-lock').attr('title', options.services.gplus.txt_gplus_on);
                        $container_gplus.find('#gplusone-dummy').replaceWith(gplus_code);
                    } else {
                        $container_gplus.removeClass('info_off');
                        $container_gplus.find('span.switch').addClass('fa-lock').removeClass('fa-unlock-alt').attr('title', options.services.gplus.txt_gplus_off);
                        $container_gplus.find('.gplusone').html(gplus_dummy_btn);
                    }
                });
            }

            //
            // Pinterest
            //
            if (pinterest_on) {
                // fuer G+ wird die URL nicht encoded, da das zu einem Fehler fuehrt
                var pinterest_uri = uri + options.services.pinterest.referrer_track;

                // we use the Google+ "asynchronous" code, standard code is flaky if inserted into dom after load
                var pinterest_code = '<div class="pintrest"><a href="//pinterest.com/pin/create/button/" data-pin-do="buttonBookmark" ><img src="//assets.pinterest.com/images/pidgets/pin_it_button.png" /></a></div>';
                var pinterest_dummy_btn = '<i class="fa fa-pinterest-square fa-lg" id="pintrest-dummy"></i>';
	            var pinterest_script = document.createElement('script');
				pinterest_script.type = 'text/javascript';
				pinterest_script.src='https://assets.pinterest.com/js/pinit.js';
				pinterest_script.async = true;



                context.append('<li class="pinterest help_info"><span class="switch fa fa-lock" title="' + options.services.pinterest.txt_pinterest_off + '"></span><div class="pinterest dummy_btn">' + pinterest_dummy_btn + '</div></li>');

                var $container_pinterest = $('li.pinterest', context);

                $('li.pinterest i,li.pinterest span.switch', context).on('click', function () {
                    if ($container_pinterest.find('span.switch').hasClass('fa-lock')) {
                        $container_pinterest.addClass('info_off');
                        $container_pinterest.find('span.switch').addClass('fa-unlock-alt').removeClass('fa-lock').attr('title', options.services.pinterest.txt_pinterest_on);
                        $container_pinterest.find('#pintrest-dummy').replaceWith(pinterest_code);
                       document.getElementsByTagName('head')[0].appendChild(pinterest_script);
                    } else {
                        $container_pinterest.removeClass('info_off');
                        $container_pinterest.find('span.switch').addClass('fa-lock').removeClass('fa-unlock-alt').attr('title', options.services.pinterest.txt_pinterest_off);
                        $container_pinterest.find('.pinterest').html(pinterest_dummy_btn);
                    }
                });
            }

			//
            // Der Info/Settings-Bereich wird eingebunden
            //
            context.append('<span class="sprite_helper" title="' + options.txt_info + '"></span>')

        }); // this.each(function ()
    };      // $.fn.socialSharePrivacy = function (settings) {
}(jQuery));

