# RemindersWidget

An [Übersicht](http://tracesof.net/uebersicht/) widget to display your pending
Reminders tasks in a sidebar on the desktop.

Uses natural language to help you stay organised with due dates as well.

## Configuration

When configuring, be sure to use [Sublime Text Editor](https://www.sublimetext.com/3) or similar.

The following configuration items are available at the top of reminders.coffee:

* style: Uses @import for external CSS styles to permit multiple skins with minimal configuration changes in the main script.
* tasksPerList: Number of tasks to show per list, 0 for all. 0 by default.
* showNotes: Whether notes get shown. True by default.
* listsToNotShow: Which lists to not show. Leave empty for all. Empty by default.
* monthBeforeDay: Use date format *mm/dd/yyyy* instead of *dd/mm/yyyy*. False by default.

### Customizing styles

[Felix](https://github.com/felixhageloh), creator of Ubersicht, is encouraging users to [submit pull requests for widgets over creating new ones](https://github.com/felixhageloh/uebersicht-widgets#readme)

In support of his direction, I'm taking steps to separate the styling from the code used to pull tasks from Reminders. A new subdirectory was added (./reminders.widget/styles) which contains contributed styles, and which can be tweaked to your heart's content. While you're free to tweak any of the css files in that directory, I suggest you copy the style you want to work with to custom.css and make your changes there. I won't accept any style submissions using that filename.

At the top of the reminders.coffee script, look for the line:

    @import url(reminders.widget/styles/default.css);

Change "default.css" to whatever style file you want to apply.

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

* All pull requests go against the develop branch. This project is managed using [gitflow](https://github.com/nvie/gitflow).
* Please don't touch reminders.widget.zip. Doing so may cause unnecessary merge conflicts. I will rezip the files during the release process.
* Same goes for the screenshot. I am considering how to create a gallery of styles where style contributors can add their screenshots.
* If you're contributing a style, do not use custom.css as the filename.

## Other Stuff

I pretty much cobbled this together by looking at a bunch of stuff other people
cobbled together. Here are all the things I looked at in order to get this working.

* [iCal Reminders Geeklet](http://www.macosxtips.co.uk/geeklets/productivity/ical-reminders/)
* [Übersicht AnyDo.widget](http://tracesof.net/uebersicht-widgets/#anydo)
* [Übersicht OmniFocus Task Widget](http://tracesof.net/uebersicht-widgets/#omnifocus-widget)
* [Übersicht Wunderlist Tasks Widget](http://tracesof.net/uebersicht-widgets/#wunderlist-tasks)

UI elements cribbed from both the OmniFocus Task Widget and the Wunderlist Tasks Widget.

Sidebar design, listsToNotShow functionality, and natural langauge additions added by Jordi Kitto.
