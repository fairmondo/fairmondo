Internationalization Guidelines
===============================

Prelude
--------------------------------------------------------------------------------

In order to know where strings should be located, how to find them, how to
name them, etc. we here list general guidelines.

If you find yourself in a situation not covered by this guide, or where the
rules do not make sense for your specific problem, please make a note at the
bottom of this file. PRs should not be merged until the issue is resolved.

General Guidelines
--------------------------------------------------------------------------------

*A selection from the [Rails Style Guide](https://github.com/bbatsov/rails-style-guide#internationalization).*

* No strings or other locale specific settings should be used in the views,
  models and controllers. These texts should be moved to the locale files in
  the `config/locales` directory.

* When the labels of an ActiveRecord model need to be translated, use the
  `activerecord` scope:

  ```yaml
  en:
    activerecord:
      models:
        user: Member
      attributes:
        user:
          name: 'Full name'
  ```

  Then `User.model_name.human` will return "Member" and
  `User.human_attribute_name("name")` will return "Full name". These
  translations of the attributes will be used as labels in the views.

* Separate the texts used in the views from translations of ActiveRecord
  attributes. Place the locale files for the models in a folder `models` and
  the texts used in the views in folder `views`.

* Place the shared localization options, such as date or currency formats, in
  files under the root of the `locales` directory.

* Use the short form of the I18n methods: `I18n.t` instead of `I18n.translate`
  and `I18n.l` instead of `I18n.localize`.

* Use "lazy" lookup for the texts used in views. Let's say we have the
  following structure:

  ```yaml
  en:
    users:
      show:
        title: 'User details page'
  ```

  The value for `users.show.title` can be looked up in the template
  `app/views/users/show.html.haml` like this:

  ```Ruby
  = t '.title'
  ```

Specific Guidelines
--------------------------------------------------------------------------------

**Where to put my translation?**

Folder structure after the `models/`, `views/`, and `gems/` subfolders **MUST**
follow the yaml structure. Not every yaml key needs a folder, but every
subfolder must be reflected in the yaml.

Meaning: If you want to translate a `title` string from
`app/views/layouts/partials/_header.html.erb`, the yaml structure would be
`layouts.partials.header.title`. The yaml file can be located in either of:

* `config/locales/views/`
* `config/locales/views/layouts`
* `config/locales/views/layouts/partials`
* `config/locales/views/layouts/partials/header`

Nowhere else.


**How much nesting?**

Subfolder nesting should be as low as feasible and should only be expanded
once a translation file gets too long. Maximum length should be around
**100 lines**.

So once `config/locales/views/articles/en.yml` gets too long, we would split
it up into `config/locales/views/articles/index/en.yml`,
`config/locales/views/articles/show/en.yml`, etc.


**What if a gem forces translation structure?**

Special translations, for example required by gems, get nested in the
`gems/` subfolder (as opposed to `views/` or `models/`), even if they
technically don't belong to a gem but to the ruby source (like date).

For example, the formtastic gem requires transations in
`[locale].formtatic.*`. The file will thus be located in
`config/locales/gems/formtastic/`


**What about shared strings?**

If exactly the same string is used in different files, put reference-anchors
it in both yaml paths and place the reference-source in a `*.shared.*` path.
Careful: Just because a string is the same in your language doesn't mean it
will be in every language.

If, for example, the exact same element is used in
`app/views/users/show.html.erb` and in `app/views/users/new.html.erb`
then it should generally be located in a partial. If that's not feasible,
you would write the following translations:

  ```yaml
  en:
    users:
      new:
        same_element_string: *user_element_string
      show:
        same_element_string: *user_element_string
      shared:
        same_element_string: &user_element_string 'MyString'
  ```

If the element transcends a single controller it should *really* be in a
separate partial, otherwise move the "shared" key up the hierarchy as needed.
E.g.:

  ```yaml
  en:
    users:
      new:
        same_element: *user_element
  ```

  ```yaml
  en:
    articles:
      show:
        same_element: *user_element
  ```

  ```yaml
  en:
    shared:
      same_element: &user_element_string
        foo: 'bar'
        baz: 'fuz'
  ```


**Translation-Key Naming Conventions**

* Keys of strings containing HTML that will be rendered onto the page should have the suffix `_html`
* *TBD...*
