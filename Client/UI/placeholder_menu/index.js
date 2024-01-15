$(document).ready(function(){


   let gamemodes = {
    
      trackrace : {title : "TRACK RACE", img : "images/v481_123.png"},
      face2face : {title : "FACE 2 FACE", img : "images/v481_123.png"}, 
      sumo : {title : "SUMO" , img : "images/v481_123.png"}

   }

   let selected = "trackrace"

   $(".gamemodes div").click(function(div){
      console.log(div.target.className)

      //remove old tags
      selected = div.target.className
      let gamemode = gamemodes[selected]
      console.log(selected)
      
      $(".gamemodes div").each(function(){ this.id = "unselected" 
      console.log(this.className,selected)
      if (this.className == selected) { this.id = "selected" } });

      $(".v481_118").text(gamemode.title)


   });

   $("#play").click(function(){

    Events.Call("play",selected)

   });

});
