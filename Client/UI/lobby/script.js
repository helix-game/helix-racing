// $(".lobby").hide()

// lobby
const toggleButton = $('.option .toggle-button');
const arrowButton = $('.option .arrow');
const readyButton = $('.lobby button.ready');
const mapArrowButton = $('.map-select .arrow');

// default values
const MaxRacers = 14;
const MinRacers = 2;
const maxLaps = 10;

let animating = false;

toggleButton.on('click', function (e) {
    if (animating) return;
    animating = true;
    let button = $(this);
    $(this).toggleClass('on');
    $(this).toggleClass('off');
    let text = $(this).find('p');

    if (button.attr('data-state') === 'on') {
        text.css({ 'transition': '0.1s' });
        text.css({
            'transform': 'translateX(-200px)',
            'opacity': '0'
        });
        setTimeout(function () {
            text.css({ 'transition': '0s' });
            text.text('OFF');
            text.css({
                'transform': 'translateX(200px)',
                'opacity': '0'
            });
            setTimeout(function () {
                text.css({ 'transition': '0.1s' });
                text.css({
                    'transform': 'translateX(0)',
                    'opacity': '1'
                });
                button.attr('data-state', 'off');
                animating = false;
            }, 100);
        }, 100);
    } else {
        text.css({ 'transition': '0.1s' });
        text.css({
            'transform': 'translateX(200px)',
            'opacity': '0'
        });
        setTimeout(function () {
            text.text('ON');
            text.css({ 'transition': '0s' });
            text.css({
                'transform': 'translateX(-200px)',
                'opacity': '0'
            });
            setTimeout(function () {
                text.css({ 'transition': '0.1s' });
                text.css({
                    'transform': 'translateX(0)',
                    'opacity': '1'
                });
                button.attr('data-state', 'on');
                animating = false;
            }, 100);
        }, 100);
    }


});
arrowButton.on('click', function (e) {
    if (animating) return;
    animating = true;
    let isLeftArrow = $(this).hasClass('left');

    let text = $(this).parent().find('p');

    let minRacersActualValue = parseInt($('.min-racers p').text());
    let maxRacersActualValue = parseInt($('.max-racers p').text());

    let isMinRacers = $(this).parent().parent().hasClass('min-racers');
    let isMaxRacers = $(this).parent().parent().hasClass('max-racers');
    let isLapsQuantity = $(this).parent().parent().hasClass('laps-quantity');

    let number = parseInt(text.text());

    if(isMinRacers) {
        if(isLeftArrow) {
            if(minRacersActualValue-1 >= MinRacers) {
                minRacersActualValue--;
            }
        } else if(minRacersActualValue+1 < maxRacersActualValue) {
            minRacersActualValue++;
        }
    } else if(isMaxRacers) {
        if(isLeftArrow && maxRacersActualValue-1 > minRacersActualValue) {
            maxRacersActualValue--;
        } else if(!isLeftArrow && maxRacersActualValue+1 <= MaxRacers) {
            maxRacersActualValue++;
        }
    } else if(isLapsQuantity) {
        if(isLeftArrow && number-1 >= 2) {
            number--;
        } else if(!isLeftArrow && number+1 <= maxLaps) {
            number++;
        }
    } else {
        if (isLeftArrow) {
            number--;
        } else {
            number++;
        }
    }

    text.css({ 'transition': '0.1s' });
    text.css({
        'transform': isLeftArrow ? 'translateY(-200px)' : 'translateY(200px)',
        'opacity': '0'})
    setTimeout(function () {
        // let text = $(this).parent().find('p');
        if(isMinRacers) {
            $(text).text(minRacersActualValue);
        } else if(isMaxRacers) {
            $(text).text(maxRacersActualValue);
        } else {
            $(text).text(number);
        }
        text.css({ 'transition': '0s' });
        text.css({
            'transform': isLeftArrow ? 'translateY(200px)' : 'translateY(-200px)',
            'opacity': '0'
        });
        setTimeout(function () {
            text.css({ 'transition': '0.1s' });
            text.css({
                'transform': 'translateY(0)',
                'opacity': '1'
            });
            animating = false;
        }, 100);
    }, 100);
});
readyButton.on('click', function (e) {
    $(this).toggleClass('clicked');

    if (!$(this).hasClass('clicked')) {
        $(this).text('READY');
    } else {
        $(this).text('YOU ARE READY');
    }

    //event to update, use "not readyVariable" to switch to opposite without repeating code and more secure
    Events.Call("click");

});


let lobbyPlayers = [
    {
        name: "Bradcoxy",
        ready: true,
        joined: true,
    },
    {
        name: "Dobby",
        ready: false,
        joined: false,
    },
];

function updateLobbyPlayers(playersArray){
    $('.right-side .slots').empty();
    for (let i = 0; i < playersArray.length; i++) {
        let element = `<div class="player ${playersArray[i].ready ? "ready" : "not-ready"} ${!playersArray[i].joined ? "joining" : ""}">
                            <h1>${playersArray[i].name}</h1>
                            <span class="state">${playersArray[i].ready ? "ready" : !playersArray[i].joined ? "joining" : "not ready"}</span>
                        </div>`
        $('.right-side .slots').append(element);
    }
    // si hay menos de 8 players, llenar con elementos con clase .player .empty
    if(playersArray.length < 8) {
        for (let i = 0; i < 8-playersArray.length; i++) {
            let element = `<div class="player empty">
                                <img src="./media/add-user.svg" alt="">
                            </div>`
            $('.right-side .slots').append(element);
        }
    }
    $('#actualLobbyPlayers').text(playersArray.length + "/8");
}

//updateLobbyPlayers(lobbyPlayers);

Events.Subscribe("loadMenu_Info", function(players,map) {

    if(map == "track::Demo_Level_V1_5") {
        $('.map-name').text("Bullish Arena");
        
    } else if(map == "track::RaceTrack_demonstration") {
        $('.map-name').text("Power Motor Speedway");
        
    } else if(map == "track::main_map") {
        $('.map-name').text("Advanced Stunt Map");
    }
    

    updateLobbyPlayers(players)

});

Events.Subscribe("update_Menu", function(players) {
    console.log(players)
    updateLobbyPlayers(players)

});