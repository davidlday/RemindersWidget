
command: 'reminders.widget/pending.sh'

render: (output) -> """
	<div class='reminders-wrap' id='reminders-wrap'>
	</div>
"""


update: (output, domEl) ->
    reminders = JSON.parse(output)
    listnames = ""
    reminders.lists.forEach (l) =>
        listnames += "<li>" + l + "</li>"
        console.log(l)
    $('#reminders-wrap').html("<ul>" + listnames + "</ul>")


showError: (err) ->
	if @content
		@content.html '<div class="error">' + err + '</div>'


#Show names of lists
showListsNames: true, # true / false

#Show lists by names
#Example: ['Inbox', 'Products', 'Starred']
showLists: [] #show all by default

#Show only a certain number of tasks from a specific list
iNumbers:
	'ListsName': 2
#	'Products': 1

# Set the refresh frequency (milliseconds).
refreshFrequency: 1000 * 60	#1 minute

style: """
  top: 190px
  left: 10px
  color: #fff
  background: rgba(0,0,0,0.2)
  font-family: Roboto
  font-size: 10pt
  width: 270px

.reminders-wrap
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

getToken: () ->
	df = new $.Deferred

	if @token == null
		$.ajax
			type: "POST"
			url: @api + "/login"
			data:
				email: @email
				password: @password
			error: (jqXHR) =>
				err = 'No internet connection'
				if jqXHR && jqXHR.responseJSON
					err = jqXHR.responseJSON.errors.message
				console.log err
				df.reject err
			success: (data) =>
				if data.token
					@token = data.token
					df.resolve @token
				else
					err = 'token is empty'
					console.log err
					df.reject err
	else
		df.resolve @token

	return df.promise()

_fetch: (name) ->
	df = new $.Deferred

	$.ajax
		url: @api + "/me/" + name
		headers:
			'Authorization': @token
		error: (jqXHR) =>
			err = 'No internet connection'
			if jqXHR && jqXHR.responseJSON
				err = jqXHR.responseJSON.errors.message
			console.log err
			df.reject err
		success: (data) =>
			@[name] = data || []
			df.resolve data

	return df.promise()

fetchLists: () ->
	return @_fetch 'lists'

fetchTasks: () ->
	return @_fetch 'tasks'

_sort: (arr) ->
	arr.sort (a, b) ->
		if a.position < b.position
			return -1
		else
			return 1
	return arr

buildTree: () ->
	tree = {}
	lists = [{
			title: 'Inbox',
			id: 'inbox'
		},{
			title: 'Assigned to Me',
			id: 'assigned_to_me'
		},{
			title: 'Starred',
			id: 'starred'
		}]
	lists = lists.concat @_sort(@lists)
	tasks = @_sort @tasks
	iNumbers = @iNumbers

	lists.forEach (l) =>
		tasksArr = []
		n = 0
		tasks.forEach (t) ->
			if ((!iNumbers[l.title] || n < iNumbers[l.title]) && t.completed_at == null && (l.id == t.list_id || (l.id == 'starred' && t.starred) || (l.id == 'assigned_to_me' && t.assignee_id != null)))
				tasksArr.push t.title
				n++;
		tree[l.title] = tasksArr

	@tree = tree

_render: () ->
	str = '<ul class="lists">'
	listNameTpl = ''
	tree = if @showLists.length then @showLists else Object.keys(@tree)
	tree.forEach (listName) =>
		tasks = @tree[listName]
		n = tasks.length
		if n
			if @showListsNames
				listNameTpl = '<div class="list-info">' +
								'<div class="list-name">' + listName + '</div>' +
								'<div class="tasks-length">' + n + '</div>' +
							'</div>'
			str +=  '<li class="list">' +
						listNameTpl +
						'<ul class="tasks">' +
							'<li class="task">' + tasks.join('</li><li class="task">') + '</li>' +
						'</ul>' +
				   	'</li>'
	str += '</ul>'
	@content.html str
