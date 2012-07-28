Cubes = new Meteor.Collection("cubes")
Messages = new Meteor.Collection("messages")

if Meteor.is_client
  Template.chat.messages = ->
    Messages.find({}, sort:{created_at:-1})
    
  Template.board.cubes = ->
    Cubes.find({}, sort:{row:1, col:1})
  
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
      black_at_first = Cubes.find({$or:[{row:"4", col:"4"},{row:"5", col:"5"}]})
      white_at_first = Cubes.find({$or:[{row:"4", col:"5"},{row:"5", col:"4"}]})
      black_at_first.forEach (cube)->
        Cubes.update(cube, $set:{color:'black'})
      white_at_first.forEach (cube)->
        Cubes.update(cube, $set:{color:'white'})
    
    'click li': (e)->
      console.log cube_id = $(e.target).attr("id")
      cube = Cubes.findOne(cube_id)
      console.log cube.color
      if cube.color == "green"
        Cubes.update(cube_id, $set:{color:'black'})
      else if cube.color == "black"
        Cubes.update(cube_id, $set:{color:'white'})
      else
        Cubes.update(cube_id, $set:{color:'green'})
      
  
  hit= (cube_id)->
    cube = Cubes.findOne(cube_id)
    cube_x = cube.row #縦方向に何番目かの情報
    cube_y = cube.col #横方向に何番目かの情報
    
    while cube_x > 0
      cube_x -= 1
      target_cube   = Cubes.findOne()
      cubes_between = Cubes.find()
      if target_cube.color == cube.color
        for cube in cubes_between
          Cubes.update(cube, $set:{color:cube.color})

if Meteor.is_server
  Meteor.startup ->
    if Cubes.find() && Cubes.find().count() == 0
        cubes = [{row:"1", col:"1", color:'green'},
                 {row:"1", col:"2", color:'green'},
                 {row:"1", col:"3", color:'green'},
                 {row:"1", col:"4", color:'green'},
                 {row:"1", col:"5", color:'green'},
                 {row:"1", col:"6", color:'green'},
                 {row:"1", col:"7", color:'green'},
                 {row:"1", col:"8", color:'green'},
                 {row:"2", col:"1", color:'green'},
                 {row:"2", col:"2", color:'green'},
                 {row:"2", col:"3", color:'green'},
                 {row:"2", col:"4", color:'green'},
                 {row:"2", col:"5", color:'green'},
                 {row:"2", col:"6", color:'green'},
                 {row:"2", col:"7", color:'green'},
                 {row:"2", col:"8", color:'green'},
                 {row:"3", col:"1", color:'green'},
                 {row:"3", col:"2", color:'green'},
                 {row:"3", col:"3", color:'green'},
                 {row:"3", col:"4", color:'green'},
                 {row:"3", col:"5", color:'green'},
                 {row:"3", col:"6", color:'green'},
                 {row:"3", col:"7", color:'green'},
                 {row:"3", col:"8", color:'green'},
                 {row:"4", col:"1", color:'green'},
                 {row:"4", col:"2", color:'green'},
                 {row:"4", col:"3", color:'green'},
                 {row:"4", col:"4", color:'black'},
                 {row:"4", col:"5", color:'white'},
                 {row:"4", col:"6", color:'green'},
                 {row:"4", col:"7", color:'green'},
                 {row:"4", col:"8", color:'green'},
                 {row:"5", col:"1", color:'green'},
                 {row:"5", col:"2", color:'green'},
                 {row:"5", col:"3", color:'green'},
                 {row:"5", col:"4", color:'white'},
                 {row:"5", col:"5", color:'black'},
                 {row:"5", col:"6", color:'green'},
                 {row:"5", col:"7", color:'green'},
                 {row:"5", col:"8", color:'green'},
                 {row:"6", col:"1", color:'green'},
                 {row:"6", col:"2", color:'green'},
                 {row:"6", col:"3", color:'green'},
                 {row:"6", col:"4", color:'green'},
                 {row:"6", col:"5", color:'green'},
                 {row:"6", col:"6", color:'green'},
                 {row:"6", col:"7", color:'green'},
                 {row:"6", col:"8", color:'green'},
                 {row:"7", col:"1", color:'green'},
                 {row:"7", col:"2", color:'green'},
                 {row:"7", col:"3", color:'green'},
                 {row:"7", col:"4", color:'green'},
                 {row:"7", col:"5", color:'green'},
                 {row:"7", col:"6", color:'green'},
                 {row:"7", col:"7", color:'green'},
                 {row:"7", col:"8", color:'green'},
                 {row:"8", col:"1", color:'green'},
                 {row:"8", col:"2", color:'green'},
                 {row:"8", col:"3", color:'green'},
                 {row:"8", col:"4", color:'green'},
                 {row:"8", col:"5", color:'green'},
                 {row:"8", col:"6", color:'green'},
                 {row:"8", col:"7", color:'green'},
                 {row:"8", col:"8", color:'green'},]
        for cube in cubes
          Cubes.insert(cube)

