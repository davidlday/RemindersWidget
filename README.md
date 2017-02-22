# RemindersWidget

An [Übersicht](http://tracesof.net/uebersicht/) widget to display your pending
Reminders tasks in sidebar on the desktop. Uses natural language to help you
stay organised with due dates.

## Configuration

The following configuration items are available at the top of reminders.coffee:

* tasksPerList: Number of tasks to show per list, 0 for all. 0 by default.
* showNotes: Whether notes get shown. False by default.
* listsToNotShow: Which lists to not show. Leave empty for all. Empty by default.
* monthBeforeDay: Use date format mm/dd/yyyy instead of dd/mm/yyyy. False by default.

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
