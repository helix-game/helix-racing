// $(".game").hide()
$(".green-shadows").hide()
$(".black-shadows").hide()

//hide for sumo

//*
$(".position").hide()
$(".progress").hide()

//*/

const gameTimer = $('.game .timer p');

function startTimer(){
    $('.game .timer').css('display', 'flex');
    let time = 3;
    gameTimer.text(time);
    let timer = setInterval(function(){
        time--;
        gameTimer.text(time);
        if(time <= 0) {
            clearInterval(timer);
            gameTimer.addClass('go');
            gameTimer.text('GO!');
            $(".game .black-shadows").fadeOut("slow");
            setTimeout(function(){
                gameTimer.text('');
                $('.game .timer').css('display', 'none');
                gameTimer.removeClass('go');
               
            }, 1000);
        }
    }, 1000);
}



function setProgressPercetage(progress){

    //console.log(progress)
    //console.log(currentCheckpoint,maxCheckpoint)
    progress = Math.floor(progress);
    $('.progress .percentage').text(progress + '%');
}

function setTime(time){
    $('.progress .time').text(time);
}

function setPosition(position, maxPosition){
    $('.position #position').text(position);
    $('.position p span').text(maxPosition);
}

function setSpeed(rpm,mph,gear){
    //console.log(rpm,mph,gear)
    if ( rpm == 0 ) { rpm = 1 } ;
    if ( gear == -1 ) { gear = "R" } ;
    if ( gear == 0 ) { gear = "N" } ;
    
    
    let rotate = (rpm / 7000) * (221 - (-42)) - 42;
    //console.log(rotate)
    $('.speedometer .needle').css('transform', 'translate(-100%, -50%) rotate(' + rotate + 'deg)');
    
    $('.gear span').text(gear)

    let kmh = Math.floor(mph);
    let currentSpeed = parseInt($('.speedometer h1').text(mph));
    let incrementing = kmh > currentSpeed ? true : false;

    let speedInterval = setInterval(function(){
        incrementing ? currentSpeed++ : currentSpeed--;
        //console.log(currentSpeed)
        $('.speedometer h1').text();
        //console.log(currentSpeed)
        if(currentSpeed < 100) {
            $('.speedometer h1').prepend(mph);
        }
        if(currentSpeed == kmh) {
            clearInterval(speedInterval);
        }
    }, //950 / ( incrementing ? kmh - currentSpeed : currentSpeed - kmh )
     );}


// Debug

//startTimer()

//setInterval(function(){
    //let rpm = Math.floor(Math.random() * 7000);
    //setSpeed(rpm);
//}, 1000);

//setProgressPercetage(7, 14)

//setPosition(2, 14)

//setTime("00:23:12")

Events.Subscribe("updateDashboard",function(info) {
    //console.log(info);
    let mph = info.speed;
    let rpm = info.rpm;
    let gear = info.gear;

    setSpeed(rpm,mph,gear)

});


function Vignette(vignette_type){
   
    if (vignette_type == "green") { 
        $(".green-shadows").fadeIn("slow");
        $(".green-shadows").fadeOut("slow");
    }

    else if (vignette_type == "black") { 
        $(".game .black-shadows").fadeIn(1500);
        $(".game .black-shadows").fadeOut(3500); 
    };
}

Events.Subscribe("Vignette", function(vignette) {
    Vignette(vignette)
});



Events.Subscribe("updateInfo", function(info) {

    let progress = info.checkpoints.progress;
    let target = info.checkpoints.target;
    let pos = info.position.pos;
    let max = info.position.max;
    //let time = info.time;

    setProgressPercetage(progress)
    //setTime(time)
    setPosition(pos, max)
    
});


Events.Subscribe("updateTimer", function(info) {
    setTime(info)
});



$(".screen").hide()

$(document).ready(function(){
    $(".screen").fadeIn("slow");
});

