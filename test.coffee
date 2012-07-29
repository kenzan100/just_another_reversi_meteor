Cubes = new Meteor.Collection("cubes")
Messages = new Meteor.Collection("messages")

if Meteor.is_client
  Meteor.startup ->
    console.log Session.get('which_player')
    if Session.get('which_player') is undefined
      Session.set('which_player', 'black')
  
  Template.chat.messages = ->
    Messages.find({}, sort:{created_at:-1})
    
  Template.board.cubes = ->
    Cubes.find({}, sort:{row:1, col:1})
  
  Template.board.which_player = ->
    Session.get('which_player')
  
  Template.chat.events = 
    'click #clearChat': (e)->
      Messages.remove({})
      
    'submit #new_msg': (e)->
      e.preventDefault()
      msg_txt = $('#new_msg_txt').val()
      now = new Date().getTime()
      Messages.insert({txt:msg_txt, created_at:now})
      $('#new_msg_txt').val('')
      
  Template.board.events =
    'click #resetBoard': (e)->
      Cubes.update({}, $set:{color:'green'}, {multi:true})
      black_at_first = Cubes.find({$or:[{row:4, col:4},{row:5, col:5}]})
      white_at_first = Cubes.find({$or:[{row:4, col:5},{row:5, col:4}]})
      black_at_first.forEach (cube)->
        Cubes.update(cube, $set:{color:'black'})
      white_at_first.forEach (cube)->
        Cubes.update(cube, $set:{color:'white'})
      Session.set('which_player', 'black')
    
    'click li': (e)->
      cube_id = $(e.target).attr("id")
      cube    = Cubes.findOne(cube_id)

      which_player = Session.get('which_player')
      flipping_color = 'black' if which_player == 'white'
      flipping_color = 'white' if which_player == 'black'
      
      flip_count = 0
      if cube && cube.color == 'green'
        flip_count += flipping_cubes([cube.row, cube.col], [ 1, 0], flipping_color, which_player)
        flip_count += flipping_cubes([cube.row, cube.col], [-1, 0], flipping_color, which_player)
        flip_count += flipping_cubes([cube.row, cube.col], [ 0, 1], flipping_color, which_player)
        flip_count += flipping_cubes([cube.row, cube.col], [ 0,-1], flipping_color, which_player)
        flip_count += flipping_cubes([cube.row, cube.col], [ 1, 1], flipping_color, which_player)
        flip_count += flipping_cubes([cube.row, cube.col], [-1,-1], flipping_color, which_player)
        flip_count += flipping_cubes([cube.row, cube.col], [ 1,-1], flipping_color, which_player)
        flip_count += flipping_cubes([cube.row, cube.col], [-1, 1], flipping_color, which_player)
      
      console.log flip_count
      if flip_count > 0
        Cubes.update(cube_id, $set:{color:which_player})
        Session.set('which_player', 'white') if which_player == 'black'
        Session.set('which_player', 'black') if which_player == 'white'
  
  flipping_cubes = (current_index, moving_index, flipping_color, your_color, cube_id_in_try)->
    may_flipping_cubes = []
    will_flipping_cubes = []
    stopper = 0
    
    flip_or_extend = (current_index, moving_index, flipping_color, your_color)->
      stopper += 1
      new_index = []
      new_index[0] = current_index[0]+moving_index[0]
      new_index[1] = current_index[1]+moving_index[1]
      current_cube = Cubes.findOne({row:new_index[0], col:new_index[1]})
      console.log current_cube
  
      if stopper > 10
        console.log "stopped"
      else if current_cube && current_cube.color == flipping_color
        may_flipping_cubes.push(new_index)
        flip_or_extend(new_index, moving_index, flipping_color, your_color)
      else if current_cube && current_cube.color == your_color
        will_flipping_cubes = may_flipping_cubes
      else
  
    flip_or_extend(current_index, moving_index, flipping_color, your_color)
    console.log will_flipping_cubes  
    for [x,y] in will_flipping_cubes
      cube = Cubes.findOne(row:x, col:y)
      Cubes.update(cube, $set:{color:your_color})
      
    return will_flipping_cubes.length
  
if Meteor.is_server
  Meteor.startup ->
    if Cubes.find() && Cubes.find().count() == 0
        cubes = [{row:1, col:1, color:'green'},
                 {row:1, col:2, color:'green'},
                 {row:1, col:3, color:'green'},
                 {row:1, col:4, color:'green'},
                 {row:1, col:5, color:'green'},
                 {row:1, col:6, color:'green'},
                 {row:1, col:7, color:'green'},
                 {row:1, col:8, color:'green'},
                 {row:2, col:1, color:'green'},
                 {row:2, col:2, color:'green'},
                 {row:2, col:3, color:'green'},
                 {row:2, col:4, color:'green'},
                 {row:2, col:5, color:'green'},
                 {row:2, col:6, color:'green'},
                 {row:2, col:7, color:'green'},
                 {row:2, col:8, color:'green'},
                 {row:3, col:1, color:'green'},
                 {row:3, col:2, color:'green'},
                 {row:3, col:3, color:'green'},
                 {row:3, col:4, color:'green'},
                 {row:3, col:5, color:'green'},
                 {row:3, col:6, color:'green'},
                 {row:3, col:7, color:'green'},
                 {row:3, col:8, color:'green'},
                 {row:4, col:1, color:'green'},
                 {row:4, col:2, color:'green'},
                 {row:4, col:3, color:'green'},
                 {row:4, col:4, color:'black'},
                 {row:4, col:5, color:'white'},
                 {row:4, col:6, color:'green'},
                 {row:4, col:7, color:'green'},
                 {row:4, col:8, color:'green'},
                 {row:5, col:1, color:'green'},
                 {row:5, col:2, color:'green'},
                 {row:5, col:3, color:'green'},
                 {row:5, col:4, color:'white'},
                 {row:5, col:5, color:'black'},
                 {row:5, col:6, color:'green'},
                 {row:5, col:7, color:'green'},
                 {row:5, col:8, color:'green'},
                 {row:6, col:1, color:'green'},
                 {row:6, col:2, color:'green'},
                 {row:6, col:3, color:'green'},
                 {row:6, col:4, color:'green'},
                 {row:6, col:5, color:'green'},
                 {row:6, col:6, color:'green'},
                 {row:6, col:7, color:'green'},
                 {row:6, col:8, color:'green'},
                 {row:7, col:1, color:'green'},
                 {row:7, col:2, color:'green'},
                 {row:7, col:3, color:'green'},
                 {row:7, col:4, color:'green'},
                 {row:7, col:5, color:'green'},
                 {row:7, col:6, color:'green'},
                 {row:7, col:7, color:'green'},
                 {row:7, col:8, color:'green'},
                 {row:8, col:1, color:'green'},
                 {row:8, col:2, color:'green'},
                 {row:8, col:3, color:'green'},
                 {row:8, col:4, color:'green'},
                 {row:8, col:5, color:'green'},
                 {row:8, col:6, color:'green'},
                 {row:8, col:7, color:'green'},
                 {row:8, col:8, color:'green'},]
        for cube in cubes
          Cubes.insert(cube)

