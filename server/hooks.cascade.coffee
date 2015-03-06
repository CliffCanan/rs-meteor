Buildings.after.remove (userId, building) ->
  Buildings.find({parentId: building._id}).forEach (unit) ->
    Buildings.direct.update({_id: unit._id}, {$set: {title: building.title + " " + unit.title}, $unset: {parentId: true}})
