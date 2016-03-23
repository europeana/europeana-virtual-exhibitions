a = [:facebook, :twitter, :pinterest, :instagram].each.collect do |e|
  [e , 1]
end.to_h


puts a.inspect
