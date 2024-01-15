
const gameTimer = $('.game .timer p');
const blackShadows = $('.game .black-shadows');
const gameLights = $('.game .game-lights');


const showUi = () => {
    $('.screen').removeClass('hidden')
}
showUi()
const hideUi = () => {
    $('.screen').addClass('hidden')
}

function startTimer() {
    $('.game .timer').css('opacity', '1');
    let time = 3;
    gameTimer.text(time);
    blackShadows.css('transition', 'all .1s');
    blackShadows.css('opacity', '1');
    setTimeout(function () {
        blackShadows.css('transition', 'all 2s');
        blackShadows.css('opacity', '0');
    }, 300);
    let timer = setInterval(function () {
        blackShadows.css('transition', 'all .1s');
        blackShadows.css('opacity', '1');
        setTimeout(function () {
            blackShadows.css('transition', 'all 2s');
            blackShadows.css('opacity', '0');
        }, 300);
        time--;
        gameTimer.text(time);
        if (time <= 0) {
            gameLights.css('transition', 'all .3s');
            gameLights.css('opacity', '1');
            setTimeout(function () {
                gameLights.css('transition', 'all 8s');
                gameLights.css('opacity', '0');
            }, 300);

            blackShadows.css('opacity', '0');
            clearInterval(timer);
            gameTimer.addClass('go');
            gameTimer.text('GO!');
            setTimeout(function () {
                gameTimer.text('');
                $('.game .timer').css('opacity', '0');
                gameTimer.removeClass('go');
            }, 1550);
        }
    }, 1550);
}

function setProgressPercetage(progress) {
    //let progress = (currentCheckpoint / maxCheckpoint) * 100;
    //progress = Math.floor(progress);
    $('.progress .percentage').text(progress + '%');
}

function setTime(time) {
    $('.progress .time').text(time); //hmm add interval to this
}

function setPosition(position, maxPosition) {
    $('.position #position').text(position);
    $('.position p span').text(maxPosition);
}

function setSpeed(rpm,mph,gear) {

    if (gear == -1) {gear = "R"};
    if (gear == 0) {gear = "N"};

    let rotate = (rpm / 7000) * (221 - (-42)) - 42;
    $('.speedometer .needle').css('transform', 'translate(-100%, -50%) rotate(' + rotate + 'deg)');

    //let kmh = Math.floor(rpm / 7000 * 300);
    let currentSpeed = parseInt($('.speedometer h1').text());
    let incrementing = mph > currentSpeed ? true : false;

    let speedInterval = setInterval(function () {
        incrementing ? currentSpeed++ : currentSpeed--;
        //console.log(currentSpeed)
        $('.speedometer h1').text(mph);
        $('.gear span').text(gear);

        if (currentSpeed < 100) {
            $('.speedometer h1').prepend('<span>0</span>');
        }
        if (incrementing && currentSpeed >= mph || !incrementing && currentSpeed <= mph) {
            clearInterval(speedInterval);
        }
    }, 950 / (incrementing ? mph - currentSpeed : currentSpeed - mph));
}


//EVENTS

Events.Subscribe("SetDashboard", function(rpm,speed,gear) {

    setSpeed(rpm,speed,gear)

});


Events.Subscribe("SetProgress", function(progress) {
    setProgressPercetage(Math.floor(progress))
});


Events.Subscribe("SetPosition", function(pos,racers) {

    setPosition(pos,racers)

});




Events.Subscribe("StartCountdown", function(t) {

    startTimer()

});


Events.Subscribe("StartTimer", function(t) {

    let startTime;
    let timerInterval;

    function startTimer() {
      startTime = Date.now();
      timerInterval = setInterval(updateTimer, 10); // Update every 10 milliseconds
    }

    function updateTimer() {
      const currentTime = Date.now();
      const elapsedTime = currentTime - startTime;

      const minutes = Math.floor(elapsedTime / (1000 * 60));
      const seconds = Math.floor((elapsedTime % (1000 * 60)) / 1000);
      const milliseconds = Math.floor((elapsedTime % 1000));

      let min_string = minutes
      let sec_string = seconds
      let milsec_string = milliseconds

      if (minutes < 10) {min_string = "0"+minutes}
      if (seconds < 10) {sec_string = "0"+seconds}
      if (milliseconds < 10) {milsec_string = "0"+milliseconds}

      setTime(minutes+":"+seconds+":"+milliseconds);
    }


    function formatTime(time) {
      return time < 10 ? `0${time}` : time;
    }

    function stopTimer() {
      clearInterval(timerInterval);
    }

    function resetTimer() {
      clearInterval(timerInterval);
      //
    }

    // Example of starting the timer
    startTimer();

    // Example of stopping the timer after 5000 milliseconds (5 seconds)
    //setTimeout(stopTimer, 5000);

    // Example of resetting the timer after 10000 milliseconds (10 seconds)
    //setTimeout(resetTimer, 10000);

});

// Debug

/*
setTimeout(function () {
    startTimer()
}, 2000);

setInterval(function () {
    let rpm = Math.floor(Math.random() * 7000);
    setSpeed(rpm);
}, 1000);

//setProgressPercetage(7, 14)

//setPosition(2, 14)

//setTime("00:23:12")
*/

