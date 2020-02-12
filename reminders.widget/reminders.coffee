#############################
# Widget Settings
settings =
# Widget theme:
# - default (original)
# - sidebar (sidebar)
  theme: 'default'
# Number of tasks to show per list, 0 for all
  tasksPerList: 0
# Whether notes get shown. Either true or false
  showNotes: true
# Lists to hide, or leave empty as [] to show all
  listsToNotShow: []
# For American's and such. Either true or false
  monthBeforeDay: false
# Set the refresh frequency (milliseconds).
  refreshFrequency: '6000'
#############################

#############################
# Do not alter below here.
#############################

#############################
# CSS styling for the widget
setStyle: (err, output) ->
  settings.style = output

#############################
# Widget refresh frequency
refreshFrequency: settings.refreshFrequency

#############################
# Widget update behavior
update: (output, domEl) ->
    str = '<ul class="lists">'
    listNameTpl = ''
    reminders = JSON.parse(output)
    listTasks = @tasksByList(output)

    # Set the widget's style
    @run("cat reminders.widget/styles/" + settings.theme + ".css", @setStyle)
    $(domEl).parent().children("style").html(settings.style)

    if !@content
        @content = $(domEl).children('#reminders-wrap').html(str)
    for listName in reminders.lists.sort().reverse() # For each list
    		if listName not in settings.listsToNotShow
                n = 0
                if listTasks[listName]? # if tasks exist
                    n = if settings.tasksPerList > 0 and listTasks[listName].length > settings.tasksPerList then settings.tasksPerList else listTasks[listName].length
                if n > 0 # if there are tasks in the list
                    # Add list name to title, and number of tasks shown if not all are being shown
                    if settings.tasksPerList <= 0
                        listNameTpl = '<div class="list-info">' +
                        '<div class="list-name">' + listName + '</div>' +
                        '</div>'
                    else if settings.tasksPerList > 0
                        listNameTpl = '<div class="list-info">' +
                        '<div class="list-name">' + listName + '</div>' +
                        '<div class="tasks-length">' + n + ' of ' + listTasks[listName].length + '</div>' +
                        '</div>'
                    str +=  '<li class="list">' + listNameTpl + '<ul class="tasks">'

                    i = 0
                    for task in listTasks[listName]
                        priority =  switch(task.priority)
                            when "1" then '!!!'
                            when "5" then '!!'
                            when "9" then '!'
                            else ''
                        if i < n
                            task = listTasks[listName][i]
                            notes = if settings.showNotes and task.notes then task.notes else ''
                            str += '<li class="task">' +
                                '<mark class="priority">' + priority + '</mark> ' + task.title
                            if task.dueDate != " "
                                now = new Date()
                                d = new Date(task.dueDate)

                                # - - Formatting - -
                                # Format times and dates
                                hours = d.getHours();
                                minutes = d.getMinutes();

                                if hours >= 12
                                    ampm = 'pm'
                                else
                                    ampm = 'am'

                                hours = hours % 12;
                                if hours == 0 # the hour '0' should be '12'
                                    hours = 12

                                if minutes < 10
                                    minutes = '0'+minutes # Append leading zero

                                timeStr = hours + ':' + minutes + ' ' + ampm;
                                if settings.monthBeforeDay
                                    dateStr = (d.getMonth() + 1) + '/' + d.getDate()
                                else
                                    dateStr = d.getDate() + '/' + (d.getMonth() + 1)
                                # End format times and dates

                                # - - Natural wording - -
                                tomorrow = new Date()
                                tomorrow.setDate(now.getDate() + 1)
                                yesterday = new Date()
                                yesterday.setDate(now.getDate() - 1)

                                # Calculate days between now and task due
                                oneDay = 24*60*60*1000; # hours*minutes*seconds*milliseconds
                                diffDays = Math.ceil(Math.abs((d.getTime() - now.getTime())/(oneDay)))

                                # format wording
                                if d.getDate() == now.getDate() && d.getMonth() == now.getMonth() && d.getFullYear() == now.getFullYear()
                                    dStr = 'today at ' + timeStr
                                else if d.getDate() == tomorrow.getDate() && d.getMonth() == tomorrow.getMonth() && d.getFullYear() == tomorrow.getFullYear()
                                    dStr = 'tomorrow at ' + timeStr
                                else if diffDays <= 7 && (d.getDate() > now.getDate() || d.getMonth() > now.getMonth() || d.getFullYear() > now.getFullYear())
                                    dStr = 'in ' + diffDays.toString() + ' days at ' + timeStr
                                else if d.getDate() == yesterday.getDate() && d.getMonth() == yesterday.getMonth() && d.getFullYear() == yesterday.getFullYear()
                                    dStr = 'yesterday at ' + timeStr
                                else if d.getFullYear() > now.getFullYear()
                                    dStr = dateStr + '/' + (d.getFullYear() - 2000) + ' at ' + timeStr
                                else
                                    dStr = dateStr + ' at ' + timeStr # Formatted date
                                # End formatting

                                divcls = if d < now then 'overdue' else 'due'
                                str += '<div class="' + divcls + '">Due ' + dStr + '</div>'
                            if settings.showNotes and task.notes
                                str += '<div class="notes">' + task.notes + '</div>'
                            str += '</li>'
                            i++
                        else
                            break
                    str += '</ul></li>'
    str += '</ul>'
    @content.html(str)

#############################
# Command
command: 'reminders.widget/pending.sh'

#############################
# Transforms kludgy JSON from pending.sh
# into something more reasonable.
# TODO: Fix the shell script
tasksByList: (output) ->
    reminders = JSON.parse(output)
    listTasks = {}
    for t in reminders.tasks
        listTasks[t.list] = [] if !listTasks[t.list]
        listTasks[t.list].push(t)
    return listTasks

#############################
# Shows errors if they occur
showError: (err) ->
	if @content
		@content.html '<div class="error">' + err + '</div>'

#############################
# Wrapper div
render: (_) -> """
	<div id='reminders-wrap'>
	</div>
"""

#############################
# Launch Reminders on click
afterRender: (domEl)->
  $(domEl).on 'click', => @run "open /Applications/Reminders.app"

#############################
# CSS styling for the widget
# style: null
