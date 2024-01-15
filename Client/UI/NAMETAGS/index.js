$(document).ready(function(){

function createBlueprint(info){
    document.getElementById("playerPosition").innerHTML = info.pos;
    document.getElementById("playerName").innerHTML = info.name;
}

function updateBlueprint({position}){
    document.getElementById("playerPosition").innerHTML = position;
}

/*
createBlueprint({
    position: 1, 
    name: "HELIX Racer 21"
})
*/

//createBlueprint("cat","1")


Events.Subscribe("load_NameTag", function(info) {
    createBlueprint(info)
    
    //console.log("cat world")
    //$('.playerPosition').text(info.pos);
    //$('.playerName').text(info.name.toUpperCase());
    //$('.position').text(info.pos);
    //$('.name').text(info.name.toUpperCase());
});

Events.Subscribe("updateNameTag", function(position) {
    //console.log(position)
  
    updateBlueprint({position})
    //$('.playerPosition').text(info);
});


});