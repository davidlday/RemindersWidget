# TODO
# * Parse due date into a more presentable format
# * Add priority lookup (high, medium, low)
# * Limit number of tasks displayed
# * Limit lists displayed


# Widget Settings
settings =
    colors:
        default: 'rgba(255, 255, 255, .75)'
        background: 'rgba(255, 255, 255, .1)'
    shadows:
        box: '0 0 1.25em rgba(0, 0, 0, .5)'
        text: '0 0 0.625em rgba(0, 0, 0, .25)'
    show:
        noDueDate: true
        tasksPerList: 0
        listNames: true # Show names of lists or just show tasks in order due?
        priority: true
        notes: false
    lists:
        show: [] # Empty means show all not in hide list
        hide: [] # Empty means hide none

# Set the refresh frequency (milliseconds).
refreshFrequency: 1000 * 60	#1 minute

# Command
command: 'reminders.widget/pending.sh'

render: (output) -> """
	<div class='reminders-wrap'>
	</div>
"""

update: (output, domEl) ->
    str = '<ul class="lists">'
    listNameTpl = ''
    reminders = JSON.parse(output)
    listTasks = @tasksByList(output)
    if !@content
        @content = $(domEl).find('.reminders-wrap')
    for listName in reminders.lists.sort()
        n = if listTasks[listName] then listTasks[listName].length else 0
        if n > 0
            listNameTpl = '<div class="list-info">' +
            '<div class="list-name">' + listName + '</div>' +
            '<div class="tasks-length">' + n + '</div>' +
            '</div>'
            str +=  '<li class="list">' +
            listNameTpl + '<ul class="tasks">'
            for task in listTasks[listName]
                str += '<li class="task">' + task.title
                if task.dueDate != " "
                    str += '<br />Due: ' + task.dueDate
                str += '<br />Priority: ' + task.priority
                str += '</li>'
            str += '</ul></li>'
    str += '</ul>'
    @content.html(str)

showError: (err) ->
	if @content
		@content.html '<div class="error">' + err + '</div>'


style: """
    top: 190px
    left: 10px
    color: #fff
    background: rgba(0,0,0,0.2)
    font-family: Arial
    font-size: 10pt
    width: 360px

    .reminders-wrapx
        position: relative
        height: 100%
        padding: 1rem
        border-radius: 1rem
        background: #{ @settings.colors.background }
        box-shadow: #{ @settings.shadows.box }
        text-shadow: #{ @settings.shadows.text }
        overflow: hidden
        -webkit-backdrop-filter: blur(10px)
        vertical-align: middle

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
        text-overflow: ellipsis
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
        white-space: nowrap
        overflow: hidden
        text-overflow: ellipsis
        position: relative
        opacity: 0.85

    .task::after
        content: ""
        position: absolute
        width: 10px
        height: 10px
        background: rgba(0,0,0,0.3)
        -webkit-border-radius: 20px
        left: 0
        top: 8px

    .error
        padding: 5px
        background: rgba(0,0,0,0.3)
"""

tasksByList: (output) ->
    reminders = JSON.parse(output)
    listTasks = {}
    for t in reminders.tasks
        listTasks[t.list] = [] if !listTasks[t.list]
        listTasks[t.list].push(t)
    return listTasks
