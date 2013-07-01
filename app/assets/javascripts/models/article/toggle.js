/*
 *
 * == License:
 * Fairnopoly - Fairnopoly is an open-source online marketplace.
 * Copyright (C) 2013 Fairnopoly eG
 *
 * This file is part of Fairnopoly.
 *
 * Fairnopoly is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Fairnopoly is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
 */


// refs #151

$(document).ready(function(){
	$("input[data-select-toggle][type=checkbox]")
		.on('change ifChanged', function () {
			box = $(this);
			area_id = box.attr("data-select-toggle");
			$("#" + area_id).parent().toggle(box.is(":checked"));
		}).trigger('change')

	if (!$.support.leadingWhitespace) { // IE 7 / 8 version
		$("input[data-select-toggle][type=radio]")
			.on('change ifChanged',function (e) {
				box = $(this);
				area_id = box.attr("data-select-toggle");
				boxes_for_other_areas = $("input[data-select-toggle][type=radio]")

				boxes_for_other_areas.each(function(i) {
					other_box = $(this);
					if (! other_box.attr("checked")) {
						other_area_id = other_box.attr("data-select-toggle");
						$("#" + other_area_id).parent().toggle(false);
					}
				});
				if (box.attr("checked")) {
					$("#" + area_id).parent().toggle(true);
				}
			}).trigger('change');
	} else {
		$("input[data-select-toggle][type=radio]")
			.on('change ifChanged',function (e) {
				box = $(this);
				area_id = box.attr("data-select-toggle");
				$("#" + area_id).parent().toggle(box.is(":checked"));
				if(e.isTrigger == undefined) {
				  $("input[name='" + box.attr("name") + "']:not([data-select-toggle=" + area_id + "])").trigger('change');
				}
			}).trigger('change')
	}

});
