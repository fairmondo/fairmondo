selected_categories_input = "#selected_categories_input" # Input Box if multiselect
native_select_categories  = ".Category-nativeselect" # the original select
select_button_html_id = "Category-selectbutton" # the select button class

changed_select_box = (event) ->
  selected_categories_list = $(selected_categories_input)
  is_multiselect = $(selected_categories_input).length > 0
  $(event.target).nextAll("select").remove() # Remove all selectboxes after this one
  selected_category_id = $("option:selected", $(this)).attr("value") # retrieve the category_id from the changed box
  unless selected_category_id is "-1" |selected_category_id is ""
    $.getJSON "/categories/" + selected_category_id, (data) ->
      if data.children.length > 0 # only if we have any children in this category

        # Build Select Box
        select_tag = "<select><option value=\"-1\"></option>" # Add empty option
        $.each data.children, (index, child) ->
          select_tag += "<option value=\"" + child.id + "\">" + child.name + "</option>"

        select_tag += "</select>"

        # Append select box to old box
        jq_selecttag = $(select_tag)
        lastselectbox = $(event.target).next(".selectboxit-container")
        jq_selecttag.insertAfter lastselectbox

        # Add handlers and style
        jq_selecttag.change changed_select_box
        jq_selecttag.selectBoxIt({autoWidth:false})
      if !is_multiselect
        selected_value = $(event.target).find("option:selected:first").attr("value")
        hidden_tag = $(native_select_categories).siblings("input[type=hidden]")
        hidden_tag.remove()
        $(native_select_categories).parent().prepend("<input type=\"hidden\" name=\"article[categories_and_ancestors][]\" value=\""+selected_value+"\"></input>")

select_category = ->
  selected_categories_list = $(selected_categories_input)
  selected_values = []
  selected_texts = []

  # get the values and category texts from the selectboxes
  $(this).parent().find("select").each (index) ->
    option = $("option:selected:first", $(this))
    value = option.attr("value")
    text = option.text()
    if value and value isnt "-1"
      selected_values.push value
      selected_texts.push text
  selectboxit = $(this).parent().find("select").first().data("selectBox-selectBoxIt");
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
      $.get "/categories/" + selected_category_id + ".js?object_name=" + $(selected_categories_input).data("object-name"), ((data) ->
        selected_item = $(data)
        selected_categories_list.append selected_item
        selected_item.append "<a class=\"Btn Category-delete\">"+I18n.t("javascript.common.actions.remove")+"</a>"
      ), "html"


$(document).ready ->
  native_category_input = $(native_select_categories)
  selected_categories_list = $(selected_categories_input)
  is_multiselect = $(selected_categories_input).length > 0

  if is_multiselect
    #Create the select category button
    select_button_html = "<a class='Btn' id='"+ select_button_html_id + "'>"+I18n.t("javascript.common.actions.select")+"</a>"
    select_button = $(select_button_html)
    native_category_input.parent().append select_button
    # Event for select button
    select_button.click select_category # On select action

  #event handler
  native_category_input.change changed_select_box

  # Dont let the native element do anything
  # used to be removeAttr, but this caused IE to crash
  native_category_input.attr "name", 'ignore'

  #Create remove buttons
  selected_categories_list.find("li").append "<a class=\"Btn Category-delete\">"+I18n.t("javascript.common.actions.remove")+"</a>"

  # Delegate events on remove buttons
  selected_categories_list.on "click", "li > a", ->
    $(this).parent().remove()


