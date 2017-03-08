# RemindersWidget

An [Übersicht](http://tracesof.net/uebersicht/) widget to display your pending
Reminders tasks in a sidebar on the desktop. 

Uses natural language to help you stay organised with due dates as well.

## Configuration

When configuring, be sure to use [Sublime Text Editor](https://www.sublimetext.com/3) or similar.

The following configuration items are available at the top of reminders.coffee:

* tasksPerList: Number of tasks to show per list, 0 for all. 0 by default.
* showNotes: Whether notes get shown. True by default.
* listsToNotShow: Which lists to not show. Leave empty for all. Empty by default.
* monthBeforeDay: Use date format *mm/dd/yyyy* instead of *dd/mm/yyyy*. False by default.

### If text looks blurry on your screen

Find and replace the line `font-size: 10pt` with `font-size: 11pt`. Additionally, change the `11pt` to `12pt` or `13pt` for added readability.

### Changing which lists to not show

Say for example you want to hide the following lists, Habits, Shopping List, and Someday. You would change the `listsToNotShow` variable as such:

`listsToNotShow = ["Someday", "Habits", "Shopping List"]`

Alternatively, leave it empty to show all lists, as such:

`listsToNotShow = []`

## Screenshot

![Screenshot of the widget](/screenshot.png?raw=true)

## Other Stuff

I pretty much cobbled this together by looking at a bunch of stuff other people
cobbled together. Here are all the things I looked at in order to get this working.

* [iCal Reminders Geeklet](http://www.macosxtips.co.uk/geeklets/productivity/ical-reminders/)
* [Übersicht AnyDo.widget](http://tracesof.net/uebersicht-widgets/#anydo)
* [Übersicht OmniFocus Task Widget](http://tracesof.net/uebersicht-widgets/#omnifocus-widget)
* [Übersicht Wunderlist Tasks Widget](http://tracesof.net/uebersicht-widgets/#wunderlist-tasks)

UI elements cribbed from both the OmniFocus Task Widget and the Wunderlist Tasks Widget.

Sidebar design, listsToNotShow functionality, and natural langauge additions added by Jordi Kitto.
