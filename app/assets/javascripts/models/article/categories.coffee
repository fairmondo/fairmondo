selected_categories_input = "#selected_categories_input" # Input Box if multiselect
native_select_categories  = ".category-nativeselect" # the original select
select_button_html_id = "category-selectbutton" # the select button class

#
# Callback for changed selectboxes
# @param (event)
#
changed_select_box = (event) ->
  selected_categories_list = $(selected_categories_input)
  $(event.target).nextAll("select").remove() # Remove all selectboxes after this one
  selected_category_id = $("option:selected", $(this)).attr("value") # retrieve the category_id from the changed box
  # Append select box to old box
  add_new_selectbox selected_category_id

# Add a new selectbox after selector with categories that are children of selected_category_id
add_new_selectbox = (selected_category_id,selected_value = null) ->

  unless selected_category_id is "-1" |selected_category_id is ""
    params_extra = ".json?"
    hideEmpty = $(native_select_categories).data("hide-empty")
    if hideEmpty
      params_extra += "hide_empty=true"
    $.getJSON "/categories/" + selected_category_id + params_extra, (data) ->

      if data.length > 0 # only if we have any children in this category

        # Build Select Box
        select_tag = "<select><option value=\"-1\">Alle Unterkategorien</option>" # Add empty option
        $.each data, (index, child) ->
          select_tag += "<option value=\"" + child.id + "\""
          if child.id == selected_value
            select_tag += " selected"
          select_tag += ">" + child.name + "</option>"

        select_tag += "</select>"

        jq_selecttag = $(select_tag)

        #Append the selectbox

        jq_selecttag.insertBefore $('#'+select_button_html_id)

        # Add style and preselect a value
        #jq_selecttag.selectBoxIt({autoWidth:false});
        document.Fairnopoly.selectboxit()

        # add handler
        jq_selecttag.change changed_select_box

      # For sigle selects we have to instantly add form ids of the selected category and remove the old one


# Get the selected category values for a multiselect
get_selected_values = ->
  selected_values = []

  # get the values and category texts from the selectboxes
  $('#'+select_button_html_id).parent().find("select").each (index) ->
    option = $("option:selected:first", $(this))
    value = option.attr("value")
    text = option.text()
    if value and value isnt "-1"
      selected_values.push value
  return selected_values

# For automatically adding the selected category on form submit
auto_append_selected_category = ->
  selected_values = get_selected_values()
  selected_category_id = selected_values[selected_values.length - 1]
  $(native_select_categories).parent().prepend("<input type=\"hidden\" name=\""+$(selected_categories_input).data("object-name")+"[category_ids][]\" value=\""+selected_category_id+"\"></input>")

# Category Add event of a multiselect
select_category = ->
  selected_categories_list = $(selected_categories_input)

  selected_values = get_selected_values()

  selectboxit = $('#'+select_button_html_id).parent().find("select").first().data("selectBox-selectBoxIt")
  selectboxit.selectOption 0
  if selected_values.length > 0 # if we selected anything
    selected_category_id = selected_values[selected_values.length - 1]
    add_this_category = true
    exsisting_items = selected_categories_list.find("li")
    exsisting_items.each (index, element) ->
      ancestors = $(this).data("ancestors")
      unless jQuery.inArray(selected_category_id, ancestors) is -1
        add_this_category = false
        false # Element already contained in others

    $(selected_values).each (index, element) ->
      element_with_this_category = selected_categories_list.find("li[data-category=" + element + "]")
      if element_with_this_category.length > 0
        if element is selected_category_id
          add_this_category = false # Element already present
        else
          element_with_this_category.remove() # Remove ancestor catergories
    if add_this_category # Add the new category to the field
      $.get "/categories/" + selected_category_id + "/select_category?object_name=" + $(selected_categories_input).data("object-name"), ((data) ->
        selected_item = $(data)
        selected_categories_list.append selected_item
        selected_item.append "<a class=\"Button Button--red\">x</a>"
      ), "html"


$(document).ready ->
  native_category_input = $(native_select_categories)
  selected_categories_list = $(selected_categories_input)
  if native_category_input.length > 0

    #Create the select category button
    select_button_html = "<a class='Button' id='"+ select_button_html_id + "' title='" + I18n.t('javascript.common.actions.select_another_category') + "'>"+I18n.t("javascript.common.actions.add_category_picker")+"</a>"
    select_button = $(select_button_html)
    native_category_input.parent().append select_button
    # Event for select button
    select_button.on 'click', select_category # On select action


    #Create remove buttons
    selected_categories_list.find("li").append "<a class=\"Button Button--red\">x</a>" # "+I18n.t("javascript.common.actions.remove")+"

    # Delegate events on remove buttons
    selected_categories_list.on "click", "li > a", ->
      $(this).parent().remove()

    # for form autosubmit
    $(".js-category-add").submit ->
      auto_append_selected_category()

    #event handler
    native_category_input.change changed_select_box

    # Dont let the native element do anything
    # used to be removeAttr, but this caused IE to crash
    native_category_input.attr "name", 'ignore'
