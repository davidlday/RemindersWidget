# RemindersWidget

An [Übersicht](http://tracesof.net/uebersicht/) widget to display your pending
Reminders tasks in a sidebar on the desktop.

Uses natural language to help you stay organised with due dates as well.

## Configuration

The following configuration items are available at the top of reminders.coffee:

* theme: Name of theme to use.
* tasksPerList: Number of tasks to show per list, 0 for all. 0 by default.
* showNotes: Whether notes get shown. True by default.
* listsToNotShow: Which lists to not show. Leave empty for all. Empty by default.
* monthBeforeDay: Use date format *mm/dd/yyyy* instead of *dd/mm/yyyy*. False by default.
* refreshFrequency:

### Customizing styles

[Felix](https://github.com/felixhageloh), creator of [Übersicht](http://tracesof.net/uebersicht/), is encouraging users to [submit pull requests for widgets over creating new ones](https://github.com/felixhageloh/uebersicht-widgets#readme)

In support of his direction, I'm taking steps to separate the styling from the code used to pull tasks from Reminders. A new subdirectory was added (./reminders.widget/styles) which contains contributed styles, and which can be tweaked to your heart's content. While you're free to tweak any of the css files in that directory, I suggest you copy the style you want to work with to custom.css and make your changes there. I won't accept any style submissions using that filename.

At the top of the reminders.coffee script, look for:

```coffee
#############################
# Widget Settings
settings =
# Widget theme:
# - default (original)
# - sidebar (sidebar)
  theme: 'default'
```

Change theme to any of the listed themes, or ```custom``` if you're making your own. The .css extension gets added automatically.

### If text looks blurry on your screen

Find and replace the line `font-size: 10pt` with `font-size: 11pt`. Additionally, change the `11pt` to `12pt` or `13pt` for added readability.

### Changing which lists to not show

Say for example you want to hide the following lists, Habits, Shopping List, and Someday. You would change the `listsToNotShow` variable as such:

`listsToNotShow = ["Someday", "Habits", "Shopping List"]`

Alternatively, leave it empty to show all lists, as such:

`listsToNotShow = []`

## Screenshot

![Screenshot of the widget](/screenshot.png?raw=true)

## Tips For Contributors

* All pull requests go against the master branch. This project is managed using [GitHub Flow](https://guides.github.com/introduction/flow/).
* Please don't update the screenshot. If enough enough styles are contributed, I'll figure out how to create a gallery.
* All contributed styles must be in css due to how I managed to get styles out of the main script.
* If you're contributing a style, do not use custom.css as the filename.

## Contributors

* [David L. Day](https://github.com/davidlday): Original widget author
* [Jordi Kitto](https://github.com/jordikitto): Sidebar design, listsToNotShow functionality, and natural langauge additions

## Credits

I pretty much cobbled this together by looking at a bunch of stuff other people
cobbled together. Here are all the things I looked at in order to get this working.

* [iCal Reminders Geeklet](http://www.macosxtips.co.uk/geeklets/productivity/ical-reminders/)
* [Übersicht AnyDo.widget](http://tracesof.net/uebersicht-widgets/#anydo)
* [Übersicht OmniFocus Task Widget](http://tracesof.net/uebersicht-widgets/#omnifocus-widget)
* [Übersicht Wunderlist Tasks Widget](http://tracesof.net/uebersicht-widgets/#wunderlist-tasks)
