JavaScript Templates
====================

Are implemented via the `hogan_assets` gem.

Please do not write HTML inside strings in JS/Coffee files to render them onto the page. Instead, put your target HTML/HAML/SLIM inside a template file in this folder and use `Template['templatename'].render()`.

You can use moustache syntax. E.g.

*flash_message.slimstache*

  ```slim
  .Flash
    a href="{{ href }}"
      | {{ anchor }}
  ```

*create_flash.coffee*

  ```coffee
  html = Template['flash_message'].render
    href: '/my/path'
    anchor: 'Foobar'

  $('.#selector').append html
  ```

~~**NOT** `$('.#selector').append "<div class=\"Flash\">...`~~
