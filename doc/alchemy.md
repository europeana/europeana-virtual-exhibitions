# Exhibitions

The virtual exhibitions platform for Europeana is based on the Alchemy CMS and open source ruby project. As of July 2016 we are using version *3.3* which can be found on [Github](https://github.com/AlchemyCMS/alchemy_cms/tree/3.3-stable).

The goal was to make the differences between the virtual exhibitions application and a default Alchemy CMS deployment as small as possible to make upgrading in the future as easy as possible. This document will point out where we altered default Alchemy CMS behaviour and how we map data from Alchemy to the styleguide.

## Differences between VE and default Alchemy

We made changes to default Alchemy behaviour on a couple of levels:

1. We added mapping code, this code can be found in *lib/europeana* and does not overlap with Alchemy code.
2. We use some *extensions* magic to override Alchemy behaviour. This happens for Alchemy::Page, Alchemy:Element, Alchemy::Picture models and the page_redirects and legacy_page_redirects controller concerns.
3. We added a sitemap controller to render sitemaps. Can be found in *app/controllers/sitemap_controller.rb*
4. Some views that needed adjustments are overridden in the folder *app/views/alchemy* this mostly concerns the admin. To override certain templates we copied from the *3.3* version and adjusted where need. For all the files found in the *app/views/alchemy* you can find a corresponding file the Alchemy source code that you can use to create a diff.
5. Override *app/controllers/concerns/alchemy/locale_redirect*. Since all urls should have a language code we remove some logic that deals with this in the default Alchemy CMS.
6. Override *app/controllers/pictures_controller.rb* changes are commented out. 

## Data mapping

Since we will be using the Europeana styleguide ruby gem in the Virtual Exhibitions app (VE for short) we need to create a mapping from the Alchemy CMS to a struture that can be used by Mustache templates. This document will briefly outline some guiding principles for this mapping.

### Page > Elements > Essences

In Alchemy a [*page*](http://guides.alchemy-cms.com/edge/pages.html) consists of one or more [*elements*](http://guides.alchemy-cms.com/edge/elements.html), each element is composed of one or more [*essences*](http://guides.alchemy-cms.com/edge/essences.html).

In the VE app a number of elements will be used, examples are:
* an image
* text
* quote
* full_width_image

Elements are defined in a simple YAML file that can be found in */config/alchemy/elements.yml*. Documentation about elements can be found here: http://guides.alchemy-cms.com/edge/elements.html

Below you will find some examples of how an element is defined and how it is mapped to mustache.

### Example 1 - a text element
#### elements.yml

```yaml
- name: text
  hint: false
  unique: false
  contents:
  - name: body
    type: EssenceRichtext
```

#### mapped to mustache
```json
{
    "type" : "text",
    "is_text" : true,
    "is_image" : false,
    "body" : {
        "html" : "<p>Text formatted</p>",
        "text" : "Text formatted"
    }
}
```

### Example 2 - an image element

#### elements.yml
```yaml
- name: image
  hint: false
  unique: false
  contents:
  - name: image
    type: EssencePicture
  - name: title
    type: EssenceText
```

#### mapped to mustache
```json
{
    "type" : "true",
    "is_text" : false,
    "is_image" : true,
    "title" : "Plain text title",
    "image" : {
        "versions" :
        {
            "thumbnail" : {
                "url" : "http://www.seemyimagehere.com/image.jpg"
            },
            "thumbnail" : {
                "url" : "http://www.seemyimagehere.com/image.jpg"
            }
        }
    }
}
```

### How to render an element in mustache?

As you can see in the example above an element of the type *image* has five attributes:
- type
- is_text
- is_image
- title
- image


#### Attributes starting with is_
Attributes starting with *is_* are just helper attributes that we need in mustache since there is no logic. These can be used in the templates to switch between different ways of rendering an element.

```mustache

{{#elements.present}}
    {{#elements.items}}
        {{#is_text}}
            // render text element
        {{/is_text}}

        {{#is_image}}
            // render image element
        {{is_image}}
    {{/elements.items}}
{{/elements.present}}
```

#### Other attributes

As can be seen the other attributes of the image object correspond to names used in the *contents* part of the definition in the elements.yml file. As a rule of thumb you can expect an element of the type image to have at the very least an attribute for each item listed under *contents*.

In the case of an image element there are two attributes: image and title. The *image* attribute refers to an EssencePicture and the *title* attribute refers to an EssenceText.

### Essence mapping

Every Alchemy *essence* will be mapped to a regular ruby hash used that will be used in the mustache templates.

Mapping in *Europeana::Elements::Embed* for the element with the type *embed* for example. All the classes in the *Europeana::Elements* namespace have a method called *data* that returns an hash with all the attributes for an element.
