# TODO
# * Limit lists displayed
# * Clean up code
update: (output, domEl) ->
    # Widget Settings
    tasksPerList = 5    # Number of tasks to show per list, 0 for all
    showNotes = false   # Whether notes get shown
    # Do not alter below here
    str = '<ul class="lists">'
    listNameTpl = ''
    reminders = JSON.parse(output)
    listTasks = @tasksByList(output)
    if !@content
        @content = $(domEl).find('.reminders-wrap')
    for listName in reminders.lists.sort()
        n = 0
        if listTasks[listName]?
            n = if tasksPerList > 0 and listTasks[listName].length > tasksPerList then tasksPerList else listTasks[listName].length
        if n > 0
            listNameTpl = '<div class="list-info">' +
                '<div class="list-name">' + listName + '</div>' +
                '<div class="tasks-length">' + n + '</div>' +
                '</div>'
            str +=  '<li class="list">' +
            listNameTpl + '<ul class="tasks">'
            i = 0
            for task in listTasks[listName]
                priority =  switch(task.priority)
                    when "1" then '!!!'
                    when "5" then '!!'
                    when "9" then '!'
                    else ''
                if i < n
                    task = listTasks[listName][i]
                    notes = if showNotes and task.notes then task.notes else ''
                    str += '<li class="task">' +
                        '<mark class="priority">' + priority + '</mark> ' + task.title
                    if task.dueDate != " "
                        divcls = if task.secondsLeft < 0 then 'overdue' else 'due'
                        str += '<div class="' + divcls + '">Due @ ' + task.dueDate + '</div>'
                    if showNotes and task.notes
                        str += '<div class="notes">' + task.notes + '</div>'
                    str += '</li>'
                    i++
                else
                    break
            str += '</ul></li>'
    str += '</ul>'
    @content.html(str)

# Set the refresh frequency (milliseconds).
refreshFrequency: 1000 * 60	#1 minute

# Command
command: 'reminders.widget/pending.sh'

tasksByList: (output) ->
    reminders = JSON.parse(output)
    listTasks = {}
    for t in reminders.tasks
        listTasks[t.list] = [] if !listTasks[t.list]
        listTasks[t.list].push(t)
    return listTasks

# Most of the following was cribbed from
showError: (err) ->
	if @content
		@content.html '<div class="error">' + err + '</div>'

render: (output) -> """
	<div class='reminders-wrap'>
	</div>
"""

style: """
    top: 190px
    left: 10px
    color: #fff
    background: rgba(0,0,0,0.2)
    font-family: Arial
    font-size: 10pt
    width: 360px
    -webkit-backdrop-filter: blur(10px)


    .lists,.tasks
        margin: 0
        padding: 0

    .list,.task
        list-style: none

    .list-info
        background: rgba(0,0,0,0.2)
        position: relative
        font-weight: bold

    .list-name
        padding: 5px 10px
        margin: 0 40px 0 0
        overflow: hidden
        position: relative
        white-space: nowrap
        opacity: 0.85

    .tasks-length
        position: absolute
        top: 0px
        right: 5px
        opacity: 0.85
        padding: 5px 5px

    .task
        margin: 0 10px
        padding: 5px 0 5px 20px
        position: relative
        opacity: 0.85

    .task::after
        content: ""
        position: absolute
        width: 10px
        height: 10px
        background: rgba(0,0,0,0.2)
        -webkit-border-radius: 20px
        border-style: solid
        border-color: rgba(190, 133, 42, 1);
        left: 0px
        top: 8px

    .due
        text-decoration: underline

    .overdue
        text-decoration: underline
        color: red

    .notes
        font-style: oblique

    mark
        color: red
        background-color: transparent

    .error
        padding: 5px
        background: rgba(0,0,0,0.3)
"""
