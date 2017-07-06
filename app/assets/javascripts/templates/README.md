JavaScript Templates
====================

Are implemented via the `handlebars_assets` gem.

Please do not write HTML inside strings in JS/Coffee files to render them onto the page. Instead, put your target HTML inside a template file in this folder and use `HandlebarsTemplates['folder/file']()`.

You can use Handlebars syntax. E.g.

*flash/notice.hbs*

  ```hbs
  <div class="Flash">
    <a href="{{href}}">
      {{anchor}}
    </a>
  </div>
  ```

*create_flash.coffee*

  ```coffee
  html = HandlebarsTemplates['flash/notice']
    href: '/my/path'
    anchor: 'Foobar'

  $('.#selector').append html
  ```

~~**NOT** `$('.#selector').append "<div class=\"Flash\">...`~~
